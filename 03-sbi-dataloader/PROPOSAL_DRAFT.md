# GSoC 2026 Proposal — sbi: PyTorch DataLoader Support for Large-Scale Training

**Applicant:** Zakir Jiwani (JiwaniZakir)
**Organization:** NumFOCUS (sbi project)
**Project:** Add PyTorch DataLoader Support for Large-Scale SBI
**Size:** 175 hours | **Difficulty:** Medium

---

## Abstract

I will add full `torch.utils.data.DataLoader` support to sbi's simulation pipeline,
removing the current constraint that all simulations must fit in RAM. By the end of
GSoC, sbi users will be able to train on arbitrarily large pre-simulated datasets
stored in HDF5 or zarr, using PyTorch's native streaming I/O with multi-worker
prefetching, GPU pin_memory, and shuffle — while keeping the existing API fully
backward-compatible.

---

## Problem Statement

sbi currently requires all simulation data in memory:

```python
# Works fine for 10K simulations:
inference.append_simulations(theta, x)

# Crashes or OOMs for 5M simulations at 100D:
theta = torch.randn(5_000_000, 10)   # 200MB
x = torch.randn(5_000_000, 100)      # 2GB — often too large
inference.append_simulations(theta, x)  # Tries to cat() all of this
```

This caps sbi's scalability. Practitioners using sbi for real scientific simulators
(climate models, neuroscience simulators, cosmological models) routinely need
millions of simulations, often pre-computed on cluster nodes without direct Python
access.

---

## Technical Design

### `SimulationDataset`

A `torch.utils.data.Dataset` subclass wrapping (theta, x) pairs:

```python
class SimulationDataset(Dataset):
    """Lazy-loadable (theta, x) simulation dataset."""

    def __init__(self, theta: Tensor, x: Tensor): ...

    @classmethod
    def from_hdf5(cls, path, theta_key="theta", x_key="x"): ...

    @classmethod
    def from_zarr(cls, path): ...

    def to_hdf5(self, path): ...
    def to_zarr(self, path): ...

    def __len__(self) -> int: ...
    def __getitem__(self, idx) -> Tuple[Tensor, Tensor]: ...
```

### Modified `append_simulations`

```python
def append_simulations(
    self,
    theta: Union[Tensor, SimulationDataset],
    x: Optional[Tensor] = None,
    **kwargs,
) -> "NeuralInference":
    if isinstance(theta, SimulationDataset):
        self._dataset = theta
    else:
        # legacy path — unchanged
        ...
```

### DataLoader Integration

Replace the `TensorDataset` + `DataLoader` construction in training loops:

```python
def _get_dataloader(self, batch_size: int, num_workers: int = 0) -> DataLoader:
    if self._dataset is not None:
        dataset = self._dataset
    else:
        theta = torch.cat(self._theta_roundwise)
        x = torch.cat(self._x_roundwise)
        dataset = TensorDataset(theta, x)

    return DataLoader(
        dataset,
        batch_size=batch_size,
        shuffle=True,
        num_workers=num_workers,
        pin_memory=torch.cuda.is_available(),
        worker_init_fn=_h5py_worker_init if isinstance(dataset, SimulationDataset) else None,
    )
```

---

## Timeline

| Period | Deliverables |
|--------|-------------|
| **Community Bonding** (May) | Survey sbi user base for storage preferences (HDF5 vs zarr), discuss chunking strategy with mentors |
| **Week 1–2** (Jun 1–14) | `SimulationDataset` — tensor and HDF5 backends, unit tests |
| **Week 3–4** (Jun 15–28) | zarr backend + multiprocessing-safe h5py worker_init_fn |
| **Week 5–6** (Jun 29–Jul 12) | `append_simulations` overload + backward-compatibility tests |
| **Week 7** (Jul 13–19) | DataLoader integration in SNPE training loop, end-to-end test |
| **Midterm eval** | SimulationDataset working end-to-end with SNPE, tests passing |
| **Week 8–9** (Jul 20–Aug 2) | Integrate into SNLE and SNRE training loops |
| **Week 10** (Aug 3–9) | Performance benchmarks: I/O speed vs in-memory, num_workers sweep |
| **Week 11** (Aug 10–16) | Tutorial notebook: large-scale sbi workflow |
| **Week 12** (Aug 17–23) | Documentation, stretch goals (distributed training via DistributedSampler) |
| **Final week** (Aug 24–25) | Cleanup, final mentor review |

---

## Deliverables

1. `sbi/utils/dataset.py` — `SimulationDataset` with HDF5 + zarr backends
2. Modified `NeuralInference.append_simulations()` accepting Dataset
3. `_get_dataloader()` in all training loops (SNPE, SNLE, SNRE)
4. Test suite: unit + integration + backward-compatibility
5. Tutorial notebook: `tutorials/dataloader_large_scale.ipynb`
6. Documentation: "Scaling to large datasets" guide

---

## Why I'm the Right Person

| Requirement | My Evidence |
|-------------|------------|
| PyTorch DataLoader patterns | Merged PRs in huggingface/transformers — large models use DataLoader heavily |
| Python data pipelines | aegis intelligence platform — production async data ingestion |
| h5py / zarr | spectra RAG eval toolkit uses disk-based storage for eval datasets |
| Test-driven development | aegis (338 tests), sentinel (209 tests) |
| Backward-compatible design | Multiple open source contributions that don't break existing APIs |

---

## Post-GSoC Plans

I'll maintain the DataLoader module — adding cloud storage backends (S3, GCS via
`fsspec`) and distributed training support (`DistributedSampler`) as stretch goals
and post-GSoC contributions.

---

*Last Updated: March 20, 2026*
