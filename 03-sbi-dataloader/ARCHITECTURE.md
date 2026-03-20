# sbi DataLoader Integration — Architecture Notes

See `02-sbi-azula/ARCHITECTURE.md` for full repo structure.
This file focuses on the data pipeline specifically.

---

## Current Data Flow (In-Memory)

```
User calls:
    inference.append_simulations(theta, x)
        │
        ▼
    NeuralInference._theta_roundwise.append(theta)
    NeuralInference._x_roundwise.append(x)
        │
Training:
        ▼
    theta = torch.cat(self._theta_roundwise)
    x = torch.cat(self._x_roundwise)
    dataset = TensorDataset(theta, x)
    loader = DataLoader(dataset, batch_size=batch_size, shuffle=True)
        │
        ▼
    for theta_batch, x_batch in loader:
        loss = self._loss(theta_batch, x_batch)
        loss.backward()
```

**Problem:** `torch.cat()` materializes all simulations in RAM at training time.
For 1M simulations × 100D observations = 400MB minimum, often much more.

---

## Target Data Flow (DataLoader-Native)

```
User calls:
    dataset = SimulationDataset.from_hdf5("big_sims.h5")
    inference.append_simulations(dataset)
        │
        ▼
    NeuralInference._dataset = dataset  # stored by reference, not loaded
        │
Training:
        ▼
    loader = DataLoader(
        self._dataset,
        batch_size=batch_size,
        shuffle=True,
        num_workers=4,       # parallel I/O workers
        pin_memory=True,     # faster GPU transfer
        prefetch_factor=2,   # prefetch next batch while training current
    )
        │
        ▼
    for theta_batch, x_batch in loader:
        loss = self._loss(theta_batch, x_batch)
        loss.backward()
```

**Benefit:** Only `batch_size` rows in RAM at any time, regardless of total dataset size.

---

## HDF5 Layout

```
simulations.h5
├── theta        (N, D_theta)  float32
├── x            (N, D_x)      float32
└── metadata/
    ├── prior_type    scalar string
    ├── simulator     scalar string
    └── num_rounds    scalar int
```

## zarr Layout

```
simulations.zarr/
├── theta/        (N, D_theta)  float32, chunk=(512, D_theta)
├── x/            (N, D_x)      float32, chunk=(512, D_x)
└── .zattrs       metadata JSON
```

---

## num_workers Gotchas

When using `num_workers > 0` with HDF5 via h5py:
- h5py is NOT multiprocessing-safe by default
- Use `h5py.File(path, "r", swmr=True)` for read-only concurrent access
- OR open one file handle per worker using `worker_init_fn`

```python
def _h5py_worker_init(worker_id):
    """Re-open HDF5 file per worker to avoid multiprocessing conflicts."""
    worker_info = torch.utils.data.get_worker_info()
    dataset = worker_info.dataset
    dataset._file = h5py.File(dataset._path, "r", swmr=True)
```

For zarr: multiprocessing is safe by design — zarr uses atomic chunk reads.

---

## Key Files to Modify

| File | Change |
|------|--------|
| `sbi/utils/dataset.py` | NEW: SimulationDataset class |
| `sbi/inference/base.py` | Modify `append_simulations()` + `_get_dataloader()` |
| `sbi/inference/snpe/snpe_c.py` | Update training loop to use `_get_dataloader()` |
| `sbi/inference/snle/snle_a.py` | Same update |
| `setup.cfg` / `pyproject.toml` | Add h5py, zarr as optional `[large-scale]` extras |
| `tests/test_simulation_dataset.py` | NEW: dataset tests |
| `tutorials/dataloader_large_scale.ipynb` | NEW: tutorial |

---

## Backward Compatibility

The change must be 100% backward-compatible:

```python
# This must still work exactly as before:
inference.append_simulations(theta_tensor, x_tensor)

# This is the new path:
inference.append_simulations(SimulationDataset(theta, x))
inference.append_simulations(SimulationDataset.from_hdf5("big.h5"))
```

Implement via overloaded type detection in `append_simulations()`.
