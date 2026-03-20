# sbi DataLoader — Outreach & Engagement Guide

**Note:** This project is in the same repo as Project #2 (sbi Azula). Most outreach
overlaps — join the same Discussions thread but mention both proposals, then let
mentor feedback guide which to prioritize.

---

## Day 1 — March 20: GitHub Discussions Post

**Same thread as Project #2 if you open one, or open a separate post:**

```
Subject: GSoC 2026 — DataLoader + large-scale training proposal — questions

Hi sbi team,

I'm Zakir Jiwani (JiwaniZakir), applying for GSoC 2026. I'm interested in both
the Azula integration and the DataLoader support projects — posting here to get
early feedback on which direction is higher priority.

For the DataLoader project specifically:
- I've read through NeuralInference.append_simulations() and the training loops
  in snpe_c.py
- My plan: SimulationDataset (torch.utils.data.Dataset) with HDF5 and zarr
  backends, then thread it into the training loop via DataLoader
- Backward-compatible: existing tensor-based API stays unchanged

Question: Is there a preferred on-disk format (HDF5 vs zarr vs something else)?
Are there existing large-dataset users who've shared requirements?

First PR submitted: [link] — [brief description]

Zakir
```

---

## Day 2 — March 21: Draft PR Discussion Comment

On your SimulationDataset draft PR:

```
This draft PR adds SimulationDataset as a torch.utils.data.Dataset wrapper
for (theta, x) simulation pairs.

Design decisions I'd like mentor input on:

1. **Lazy vs eager HDF5 loading:** Currently loading everything into memory
   in from_hdf5(). For truly large datasets we'd want lazy indexing via
   h5py[idx] — but that's slower and requires careful num_workers=0 handling.
   Which should we prioritize for the initial version?

2. **zarr vs HDF5 as default:** zarr is cloud-native (S3, GCS compatible),
   HDF5 is more traditional ML. Does the sbi user base prefer one?

3. **Chunking strategy:** For zarr, should we use chunk_size matching the
   typical batch_size (e.g., 512) for cache-friendly reads?

Happy to adjust based on your input before finishing the implementation.
```

---

## Day 3 — March 22: Proposal Preview

```
Subject: GSoC 2026 — DataLoader proposal preview

Hi sbi team,

Sharing my DataLoader proposal outline:

## Goal
torch.utils.data.DataLoader support for large-scale sbi training — simulations
too large to fit in RAM, streamed from HDF5/zarr in batches.

## Core deliverables
1. SimulationDataset (Dataset, HDF5 + zarr backends)
2. DataLoader integration in SNPE/SNLE training loops
3. append_simulations() overload accepting Dataset
4. Tests + tutorial notebook

## Why this matters
A user doing 10M simulations at float32 with 100D observations needs ~40GB.
Current sbi requires all of that in RAM. DataLoader support removes that ceiling.

Progress this week: [N] PRs submitted — [links]

Specific question: should the DataLoader use `persistent_workers=True` by
default, or leave that to the user to configure?

Zakir
```

---

## Key Talking Points

1. **"Familiar with DataLoader patterns from transformers PRs"** — large models
   use DataLoader extensively; you know the gotchas (worker deadlocks, pin_memory, etc.).
2. **"Backward-compatible design"** — existing users won't break; their code still works.
3. **"HDF5 and zarr support"** — shows you've thought about real storage trade-offs.
4. **"aegis has data pipeline experience"** — production data handling.
