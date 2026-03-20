# Project #2: sbi — Azula Diffusion Sampling

**Rank: #2 | Org: NumFOCUS | Size: 175h | Difficulty: Medium | Confirmed GSoC 2026**

## Organization Overview

**sbi** (simulation-based inference) is a PyTorch library for Bayesian inference
on simulators — i.e., when you can't write down the likelihood function but you
can simulate from your model. It lives under the **NumFOCUS** umbrella, a confirmed
GSoC 2026 organization.

- **GitHub:** https://github.com/sbi-dev/sbi
- **NumFOCUS GSoC:** https://numfocus.org/programs/google-summer-of-code (confirmed)
- **Stars:** ~800
- **Language:** Python, PyTorch
- **Docs:** https://sbi-dev.github.io/sbi/

## GSoC Project Idea: Integrate Azula Diffusion Sampling

**Goal:** Integrate the [Azula](https://github.com/probabilists/azula) diffusion model
library into sbi, enabling diffusion-based posterior samplers as an alternative to
normalizing flows and neural posterior estimation.

**Size:** 175h | **Difficulty:** Medium

### What Gets Built
- Azula `FlowMatchingPosterior` class implementing sbi's `NeuralPosterior` interface
- Training loop for diffusion-based density estimators in sbi's training framework
- Posterior sampling via DDPM/flow matching inference
- Tests against existing sbi benchmarks (benchmark suite)
- Documentation and tutorial notebook

## Tech Stack

| Component | Technology |
|-----------|-----------|
| Core | Python 3.9+, PyTorch |
| Diffusion models | Azula (probabilists/azula) |
| SBI algorithms | NPE, NLE, NRE (normalizing flow based) |
| Testing | pytest, sbi's benchmarking suite |
| Docs | Sphinx + Jupyter notebooks |
| CI | GitHub Actions |
| Package | pip / conda-forge |

## Why Zakir Fits

| Proof Point | Relevance |
|-------------|-----------|
| Transformers (merged PRs) | PyTorch large codebase experience |
| DSPy (experience) | Probabilistic/structured prediction ML |
| ML research background | Understands diffusion models and flow matching |
| Python packaging (spectra, lattice) | Can handle pip/conda packaging requirements |

## Key Modules to Understand

| Module | Purpose |
|--------|---------|
| `sbi/inference/` | Main inference algorithms (NPE, NLE, NRE) |
| `sbi/neural_nets/` | Density estimator networks |
| `sbi/samplers/` | MCMC and rejection samplers |
| `sbi/analysis/` | Posterior analysis utilities |
| `tests/` | Existing test suite to extend |
| `tutorials/` | Jupyter notebooks to add to |

## Open Issues / Entry Points

| Issue | Type | Strategy |
|-------|------|---------|
| Check `good first issue` label | Bug / docs | First PR to establish presence |
| Azula integration discussion | Feature | Reference in proposal, open discussion issue |
| Test coverage gaps | Testing | Easy PRs while learning the codebase |

## Mentors (NumFOCUS / sbi Team)

- **Jan-Matthis Lueckmann** — sbi maintainer
- **Michael Deistler** — sbi contributor, Tübingen ML group
- Check https://github.com/sbi-dev/sbi/graphs/contributors for active reviewers

## Communication Channels

| Channel | Link | Purpose |
|---------|------|---------|
| GitHub Issues | https://github.com/sbi-dev/sbi/issues | Primary contribution channel |
| GitHub Discussions | https://github.com/sbi-dev/sbi/discussions | Proposals, questions |
| NumFOCUS Slack | See numfocus.org | GSoC coordination |

---
*Priority: #2 — Diffusion model integration, PyTorch-heavy, clean medium-difficulty scope.*
