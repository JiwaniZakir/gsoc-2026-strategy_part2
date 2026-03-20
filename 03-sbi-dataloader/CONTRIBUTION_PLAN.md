# sbi DataLoader — Aggressive 5-Day Contribution Plan (Mar 20–24)

**Target: 6–8 PRs in 5 days**
**Strategy: Share some PRs with Project #2 (same repo) — don't duplicate effort.**

## Environment Setup

Same as Project #2 (sbi-azula):
```bash
git clone https://github.com/sbi-dev/sbi
cd sbi
pip install -e ".[dev]"
pip install h5py zarr  # DataLoader backends
pytest tests/ -v --tb=short -x
```

---

## Day 1 — March 20: Shared PR + DataLoader Reading

**PR #1 is shared with Project #2** — one good-first-issue fix establishes your
presence in the repo regardless of which proposal wins.

### Architecture reading:
```python
# sbi/inference/base.py

def append_simulations(
    self,
    theta: Tensor,
    x: Tensor,
    exclude_invalid_x: bool = True,
    from_round: int = 0,
    data_device: Optional[str] = None,
) -> "NeuralInference":
    """
    Store simulations for later training.
    CURRENT: requires theta and x as in-memory Tensors.
    TARGET: also accept Dataset or DataLoader.
    """
    # ... current implementation stores to self._theta_roundwise / self._x_roundwise
```

---

## Day 2 — March 21: SimulationDataset Skeleton PR

### PR #2: `SimulationDataset` draft

```python
# sbi/utils/dataset.py (new file)

from pathlib import Path
from typing import Optional, Union
import torch
from torch import Tensor
from torch.utils.data import Dataset


class SimulationDataset(Dataset):
    """
    PyTorch Dataset wrapping (theta, x) simulation pairs.

    Supports both in-memory tensors (current sbi behavior) and
    on-disk storage via HDF5 or zarr for large-scale training.

    Examples:
        # From tensors (backward-compatible):
        dataset = SimulationDataset(theta=theta, x=x)

        # From HDF5 (lazy-loaded):
        dataset = SimulationDataset.from_hdf5("simulations.h5")

        # Use with DataLoader:
        loader = DataLoader(dataset, batch_size=512, shuffle=True, num_workers=4)
    """

    def __init__(self, theta: Tensor, x: Tensor):
        assert theta.shape[0] == x.shape[0], "theta and x must have same length"
        self._theta = theta
        self._x = x

    def __len__(self) -> int:
        return self._theta.shape[0]

    def __getitem__(self, idx: int):
        return self._theta[idx], self._x[idx]

    @classmethod
    def from_hdf5(cls, path: Union[str, Path], theta_key: str = "theta", x_key: str = "x"):
        """Load from HDF5 file (lazy-loaded via h5py)."""
        try:
            import h5py
        except ImportError:
            raise ImportError("Install h5py: pip install h5py")

        with h5py.File(path, "r") as f:
            theta = torch.from_numpy(f[theta_key][:])
            x = torch.from_numpy(f[x_key][:])
        return cls(theta=theta, x=x)

    @classmethod
    def from_zarr(cls, path: Union[str, Path]):
        """Load from zarr array store."""
        try:
            import zarr
        except ImportError:
            raise ImportError("Install zarr: pip install zarr")

        store = zarr.open(str(path), mode="r")
        theta = torch.from_numpy(store["theta"][:])
        x = torch.from_numpy(store["x"][:])
        return cls(theta=theta, x=x)

    def to_hdf5(self, path: Union[str, Path], theta_key: str = "theta", x_key: str = "x"):
        """Save dataset to HDF5 file."""
        import h5py
        with h5py.File(path, "w") as f:
            f.create_dataset(theta_key, data=self._theta.numpy())
            f.create_dataset(x_key, data=self._x.numpy())
```

---

## Day 3 — March 22: DataLoader Training Loop PR

### PR #3: Modify training loop to accept DataLoader

```python
# sbi/inference/base.py

from torch.utils.data import DataLoader, TensorDataset
from sbi.utils.dataset import SimulationDataset

def _get_dataloader(
    self,
    batch_size: int = 50,
    num_workers: int = 0,
    shuffle: bool = True,
) -> DataLoader:
    """Build DataLoader from stored simulations."""
    theta = torch.cat(self._theta_roundwise)
    x = torch.cat(self._x_roundwise)

    if isinstance(self._dataset, SimulationDataset):
        dataset = self._dataset
    else:
        dataset = TensorDataset(theta, x)

    return DataLoader(
        dataset,
        batch_size=batch_size,
        shuffle=shuffle,
        num_workers=num_workers,
        pin_memory=torch.cuda.is_available(),
    )
```

### PR #4: Update `append_simulations` to accept Dataset

```python
def append_simulations(
    self,
    theta: Union[Tensor, "SimulationDataset"],
    x: Optional[Tensor] = None,
    **kwargs,
) -> "NeuralInference":
    """Accept both tensor pairs (legacy) and SimulationDataset."""
    if isinstance(theta, SimulationDataset):
        # New path: store the Dataset directly
        self._dataset = theta
    else:
        # Legacy path: in-memory tensors
        self._dataset = None
        # ... existing logic
```

---

## Day 4 — March 23: Tests + Edge Cases

### PR #5: Tests for SimulationDataset

```python
# tests/test_simulation_dataset.py

import pytest
import torch
import tempfile
from pathlib import Path
from sbi.utils.dataset import SimulationDataset


def test_simulation_dataset_from_tensors():
    theta = torch.randn(100, 2)
    x = torch.randn(100, 5)
    dataset = SimulationDataset(theta=theta, x=x)
    assert len(dataset) == 100
    t, xi = dataset[0]
    assert t.shape == (2,)
    assert xi.shape == (5,)


def test_simulation_dataset_hdf5_roundtrip(tmp_path):
    theta = torch.randn(50, 3)
    x = torch.randn(50, 10)
    dataset = SimulationDataset(theta=theta, x=x)

    path = tmp_path / "test.h5"
    dataset.to_hdf5(path)

    loaded = SimulationDataset.from_hdf5(path)
    assert len(loaded) == 50
    assert torch.allclose(loaded._theta, theta)
    assert torch.allclose(loaded._x, x)


def test_simulation_dataset_in_dataloader():
    from torch.utils.data import DataLoader
    theta = torch.randn(200, 2)
    x = torch.randn(200, 5)
    dataset = SimulationDataset(theta=theta, x=x)
    loader = DataLoader(dataset, batch_size=32, shuffle=True)
    batch = next(iter(loader))
    assert batch[0].shape == (32, 2)
    assert batch[1].shape == (32, 5)


def test_simulation_dataset_mismatched_dims_raises():
    with pytest.raises(AssertionError):
        SimulationDataset(theta=torch.randn(100, 2), x=torch.randn(50, 5))
```

### PR #6: Integration test — full training with DataLoader

```python
def test_snpe_trains_with_simulation_dataset():
    prior = BoxUniform(low=torch.zeros(2), high=torch.ones(2))
    simulator = diagonal_linear_gaussian

    theta, x = simulate_for_sbi(simulator, prior, num_simulations=100)
    dataset = SimulationDataset(theta=theta, x=x)

    inference = NPEC(prior=prior)
    inference.append_simulations(dataset).train(max_num_epochs=2, batch_size=32)
    posterior = inference.build_posterior()
    samples = posterior.sample((10,), x=torch.zeros(2))
    assert samples.shape == (10, 2)
```

---

## Day 5 — March 24: Documentation + Tutorial

### PR #7: Tutorial notebook

`tutorials/dataloader_large_scale.ipynb`:
- Show current limitation (RAM overflow on large datasets)
- Show SimulationDataset solution
- Benchmark: training speed with num_workers=0 vs num_workers=4

### PR #8: Documentation

Update `docs/` with:
- "Scaling to large datasets" guide
- HDF5 vs zarr trade-offs
- DataLoader configuration options

---

## PR Summary

| Day | PR | Type |
|-----|-----|------|
| Mar 20 | #1 (shared) | Good-first-issue fix |
| Mar 21 | #2 | Feature: SimulationDataset |
| Mar 22 | #3 | Feature: DataLoader training loop |
| Mar 22 | #4 | Feature: append_simulations accepts Dataset |
| Mar 23 | #5 | Tests: SimulationDataset |
| Mar 23 | #6 | Integration test: SNPE + DataLoader |
| Mar 24 | #7 | Tutorial notebook |
| Mar 24 | #8 | Docs |
