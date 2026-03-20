# Project #3: sbi — PyTorch DataLoader Support

**Rank: #3 | Org: NumFOCUS | Size: 175h | Difficulty: Medium | Confirmed GSoC 2026**

## Organization Overview

Same as Project #2 — **sbi** under **NumFOCUS**. This is a separate GSoC idea in the
same repository. Both #2 and #3 can be applied to independently.

- **GitHub:** https://github.com/sbi-dev/sbi
- **NumFOCUS GSoC:** https://numfocus.org/programs/google-summer-of-code (confirmed)
- **Language:** Python, PyTorch

## GSoC Project Idea: PyTorch DataLoader Support

**Goal:** Add full `torch.utils.data.DataLoader` support to sbi's simulation pipeline,
enabling training on pre-simulated datasets too large to fit in RAM. Currently sbi
loads all simulations into memory as tensors, which breaks at large scale.

**Size:** 175h | **Difficulty:** Medium

### What Gets Built
- `SimulationDataset` extending `torch.utils.data.Dataset`
- `DataLoader`-compatible training loop in sbi's inference algorithms
- Support for HDF5 and zarr as on-disk storage backends
- Lazy loading for large simulation datasets
- Streaming integration with existing sbi API (`append_simulations` stays the same)

## Why This Matters

Current limitation:
```python
# This fails if theta/x don't fit in RAM:
theta = torch.randn(1_000_000, 10)  # 10M floats — borderline
x = torch.randn(1_000_000, 100)     # 100M floats — too large
inference.append_simulations(theta, x)  # Loads everything into VRAM
```

With DataLoader support:
```python
# Works regardless of dataset size:
dataset = SimulationDataset.from_hdf5("simulations.h5")
inference.append_simulations(dataset)  # Lazy-loaded in batches
```

## Zakir's Edge

| Proof Point | Relevance |
|-------------|-----------|
| Transformers (merged PRs) | Knows `DataLoader` patterns in production ML |
| aegis (338 tests) | Experience with data pipelines at scale |
| spectra (RAG eval) | Familiarity with dataset abstraction patterns |
| Python packaging | Can add HDF5/zarr as optional dependencies correctly |

## Tech Stack

| Component | Technology |
|-----------|-----------|
| Core | Python 3.9+, PyTorch |
| Dataset interface | `torch.utils.data.Dataset`, `DataLoader` |
| On-disk storage | HDF5 (h5py), zarr |
| Testing | pytest, `torch.testing` |
| CI | GitHub Actions |

## Key Modules to Understand

| Module | Purpose |
|--------|---------|
| `sbi/inference/base.py` | `NeuralInference.append_simulations()` — modify this |
| `sbi/inference/snpe/snpe_c.py` | Training loop — add DataLoader support here |
| `sbi/utils/simulation_wrapper.py` | Simulation utilities |
| `tests/` | Test patterns to follow |

## Communication Channels

Same as Project #2:

| Channel | Link | Purpose |
|---------|------|---------|
| GitHub Issues | https://github.com/sbi-dev/sbi/issues | Primary |
| GitHub Discussions | https://github.com/sbi-dev/sbi/discussions | Proposals |

---
**Note on applying to both #2 and #3:** Both are in sbi. You can contribute to both
but should apply to only one as your primary GSoC proposal. Recommend #2 (Azula) as
primary unless you get strong mentor signal that DataLoader is higher priority.

---
*Priority: #3 — Same org as #2, orthogonal work, strong engineering problem.*
