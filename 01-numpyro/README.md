# Project #1: pyro-ppl/numpyro

**Score: 69.26 | Merge Rate: 92.9% | External PRs: 14 | Rank: #1**

## Organization Overview

**NumPyro** is a lightweight probabilistic programming library built on [JAX](https://github.com/google/jax). It is part of the **Pyro** ecosystem developed by Uber AI and maintained under **NumFOCUS** as a confirmed GSoC 2026 umbrella organization.

- **GitHub:** https://github.com/pyro-ppl/numpyro
- **Stars:** ~2,100
- **Language:** Python (JAX)
- **GSoC Umbrella:** NumFOCUS (confirmed)
- **GSoC Ideas Page:** https://github.com/numfocus/gsoc/blob/master/2026/ideas-list.md

## Why NumPyro is #1

- **92.9% merge rate** — highest of all candidates. The core team actively merges external contributions.
- Zakir already has a PR in numpyro — the team knows his name.
- 14 external PRs in the window — small enough that contributions stand out.
- JAX/probabilistic programming aligns directly with Zakir's ML/AI background.

## GSoC Project Ideas (NumFOCUS Track)

| Idea | Difficulty | Fit |
|------|-----------|-----|
| Automatic Structured Variational Inference (ASVGD) | Hard | Excellent — issue #1117 |
| New distributions and constraints (CatTransform, batched scale_tril) | Medium | Good — issues #1872, #1623 |
| Improved MCMC diagnostics and weighted statistics | Medium | Good — issue #810 |
| User-contributed examples and tutorials | Easy | Easy entry — issue #189 |
| Sparse GP support and documentation | Medium | Good — issue #829 |

## Tech Stack

| Component | Technology |
|-----------|-----------|
| Core inference | Python, JAX, NumPy |
| Distributions | SciPy, custom JAX transforms |
| MCMC | NUTS, HMC, MCMC kernels |
| Variational inference | SVI, AutoGuides |
| Testing | pytest, JAX test utilities |
| Docs | Sphinx, Jupyter notebooks |
| CI | GitHub Actions |

## Key Modules

| Module | Purpose |
|--------|---------|
| `numpyro/distributions/` | All probability distributions |
| `numpyro/infer/` | MCMC, SVI, autoguide |
| `numpyro/primitives.py` | Core model primitives (sample, param, plate) |
| `numpyro/contrib/` | User-contributed extras |
| `docs/source/` | Tutorials and examples |

## Open Issues (Target)

| # | Title | Strategy |
|---|-------|---------|
| [#1872](https://github.com/pyro-ppl/numpyro/issues/1872) | Support constraints.cat and CatTransform | Implement new constraint/transform |
| [#1623](https://github.com/pyro-ppl/numpyro/issues/1623) | Batched scale_tril | Fix batching logic in matrix ops |
| [#810](https://github.com/pyro-ppl/numpyro/issues/810) | Weighted statistics in summary diagnostics | Extend summary() function |
| [#1117](https://github.com/pyro-ppl/numpyro/issues/1117) | Automatic structured variational inference | GSoC-scale project |
| [#189](https://github.com/pyro-ppl/numpyro/issues/189) | User-contributed examples/tutorials | Good first PR — notebook |

## Mentors

- **Du Phan** (dphan) — primary maintainer, active reviewer
- **Martin Jankowiak** — core contributor, probabilistic programming theory
- Check NumFOCUS GSoC page for 2026-specific mentor list

## Communication Channels

| Channel | Link | Purpose |
|---------|------|---------|
| GitHub Discussions | https://github.com/pyro-ppl/numpyro/discussions | Technical questions, proposals |
| Pyro Forum | https://forum.pyro.ai | Community discussions |
| GitHub Issues | https://github.com/pyro-ppl/numpyro/issues | Bug reports, feature requests |
| NumFOCUS Slack | Via NumFOCUS application | GSoC coordination |

## Zakir's Unique Edge

1. Already has an existing numpyro PR — the maintainers have already reviewed his work
2. Python/ML background with transformers, LangChain, DSPy — aligns with probabilistic ML
3. Prior JAX familiarity from ML work
4. Proposal can reference existing numpyro contribution directly

---
*Priority: #1 — Highest merge rate, existing relationship with maintainers, best effort-to-merge ratio*
