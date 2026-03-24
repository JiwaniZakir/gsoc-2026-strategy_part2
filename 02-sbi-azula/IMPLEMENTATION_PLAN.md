# GSoC 2026 Implementation Plan
## Integrate Azula Library for Diffusion Sampling in sbi

**Applicant:** Zakir Jiwani | jiwzakir@gmail.com
**Mentors:** Jan Teusen (Boelts) & Nicholas Junge
**Organization:** NumFOCUS / sbi-dev
**Date:** March 24, 2026

---

## 1. Verified Project Details (from Wiki)

### 1.1 Expected Outcomes (Verbatim from Wiki)

- **Outcome 1 – SBIDenoiser adapter:** Bridge class connecting sbi's score estimator interface to azula's denoiser protocol
- **Outcome 2 – AzulaDiffuser wrapper:** User-facing class exposing azula samplers (Heun, DDIM, etc.) with sbi-compatible API
- **Outcome 3 – Shape broadcasting utilities:** Handle dimension conventions between libraries (azula: `[B]`, sbi: `[B, 1, ...]`)
- **Outcome 4 – Comprehensive benchmarks:** Compare azula samplers against sbi's current ODE solver on standard tasks (two-moons, SLCP, Gaussian mixture)
- **Outcome 5 – Documentation and examples:** Tutorial showing how to use azula samplers with FMPE/NPSE

### 1.2 Required Skills

- PyTorch and neural network basics
- Prior exposure to generative models (VAEs, normalizing flows, or diffusion models) is beneficial
- Understanding of score-based generative models (can be deepened during community bonding)
- Familiarity with ODE solvers is helpful but not required

### 1.3 Resources Listed

- Azula documentation: https://azula.readthedocs.io
- sbi's `VectorFieldPosterior` and `ConditionalVectorFieldEstimator` classes
- Related issue: [#1468](https://github.com/sbi-dev/sbi/issues/1468)
- Related PR: [#1736](https://github.com/sbi-dev/sbi/pull/1736) – explicit noise schedules (now merged)

---

## 2. Cross-Check Against Deep Dive Findings

### 2.1 Critical New Findings from Issue #1468

- Jan Teusen explicitly asked for **mini-sbibm benchmark comparisons** — running actual benchmarks before submission is a key differentiator
- The existing `VectorFieldPosterior` has a `solve_schedule()` method that must be preserved/extended
- PR #1736 (merged) introduced `train_schedule()` and `solve_schedule()` — the azula integration builds directly on top of this
- PR #1754 is related; understanding it shows depth of codebase knowledge

---

## 3. Application Guidelines (from Wiki)

1. **Project understanding:** Demonstrate you understand the problem and sbi's current implementation
2. **Detailed plan:** Break the project into phases with clear milestones aligned to GSoC evaluations
3. **Timeline:** Weekly goals with clear ordering
4. **Your background:** Relevant experience, coursework, or projects
5. **Community engagement:** Reference any issues, PRs, or discussions you've participated in
6. **Availability:** Confirm you can commit the required hours and note any planned absences

---

## 4. Day-by-Day Implementation Plan

### Phase 1: Pre-Application Sprint (March 24–31)

#### Day 1 – March 24 (TODAY): Environment Setup & Codebase Study

- Fork sbi repo, clone locally, set up dev environment with `uv`
- Install sbi in editable mode: `uv pip install -e ".[dev]"`
- Install pre-commit hooks: `pre-commit install`
- Run the test suite: `pytest -m "not slow and not gpu"` to verify setup
- Read through sbi tutorials in the documentation (especially FMPE/NPSE tutorials)
- Study the key files:
  - `sbi/neural_nets/estimators/score_estimator.py`, `base.py`
  - `sbi/inference/posteriors/vector_field_posterior.py`
  - `sbi/samplers/score/` directory for current diffusion sampling implementation
- Read PR #1736 changes in detail – understand `train_schedule()` and `solve_schedule()`
- Install azula: `pip install azula`, read azula docs and source code

#### Day 2 – March 25: First Contribution PR (Documentation/Bug Fix)

- Look at beginner-friendly issues on the sbi repo
- Find a documentation improvement, typo fix, or minor bug to fix
- Create a feature branch, make the fix, run tests, submit first PR
- This PR is **REQUIRED** by the application guidelines – it shows you can work with the code
- Join the sbi Discord server and introduce yourself
- Message the mentors on Discord: mention interest in the Azula GSoC project

#### Day 3 – March 26: Prototype the SBIDenoiser Adapter

- Create `sbi/samplers/score/azula_diffuser.py`
- Implement `SBIDenoiser(nn.Module)` that wraps sbi's score estimator for azula
- Handle shape broadcasting: azula `[B]` time tensors → sbi `[B, 1, ...]` format
- Write unit tests for shape consistency and broadcasting
- Test with a simple toy score estimator to verify the adapter works

#### Day 4 – March 27: Implement AzulaDiffuser Wrapper

- Implement `AzulaDiffuser(Diffuser)` class inheriting from sbi's `Diffuser` base
- Expose azula samplers (Heun, DDIM, DDPM) through sbi-compatible API
- Handle azula as optional dependency with graceful `ImportError`
- Write integration tests using sbi's existing test patterns
- Verify gradient flow through the wrapper (critical for optimization)

#### Day 5 – March 28: Run Benchmarks with mini-sbibm

- This is what Jan Teusen specifically asked for in issue #1468
- Run mini-sbibm benchmarks: `pytest --bm --bm-mode npse` (and fmpe)
- Compare sbi's current ODE solver vs azula Heun sampler on two-moons task
- Compare on SLCP task as well
- Test at least 3 azula samplers: Heun, DDIM, DDPM
- Record performance metrics, wall-clock time, and sample quality
- Create a comparison table/figure with results

#### Day 6 – March 29: Submit Benchmark PR & Draft Proposal

- Clean up benchmark code and results
- Submit as a draft PR or share results on issue #1468 (show, don't tell)
- Begin drafting the GSoC proposal document with all required sections
- Include: project understanding, detailed plan with milestones, timeline, background
- Reference your PRs and community engagement

#### Day 7 – March 30–31: Finalize Proposal & Submit

- Finalize proposal with mentor feedback (if received)
- Ensure all sections from the wiki guidelines are covered
- Confirm availability and hours commitment
- Submit proposal through the GSoC portal
- Follow up on Discord with mentors

---

### Phase 2: Community Bonding Period (if selected)

- Deepen understanding of score-based generative models theory
- Study Karras et al. EDM paper in detail (relevant to noise schedules)
- Review azula source code comprehensively – understand every sampler
- Discuss final design decisions with mentors (adapter pattern, optional dependency approach)
- Set up benchmarking infrastructure for continuous comparison
- Create detailed technical design document with mentors' input

---

### Phase 3: GSoC Coding Period – Milestone Breakdown

#### Milestone 1 (Weeks 1–4): Core Integration

- Finalize `SBIDenoiser` adapter with full test coverage
- Finalize `AzulaDiffuser` wrapper with all azula sampler types
- Shape broadcasting utilities with edge case handling
- Add azula as optional dependency in `pyproject.toml` (`[diffusion]` extra)
- Integration tests with FMPE and NPSE trainers
- Pass all CI checks (ruff, pyright, pytest)

#### Milestone 2 (Weeks 5–8): Benchmarking & Optimization

- Comprehensive benchmarks using mini-sbibm framework
- Compare all azula samplers (Heun, DDIM, DDPM, Adams-Bashforth) against sbi defaults
- Benchmark on standard tasks: two-moons, SLCP, Gaussian mixture
- Measure: posterior accuracy (C2ST), wall-clock time, memory usage
- Optimize based on results – identify which samplers are actually better
- **Mid-term evaluation deliverable:** working integration with benchmark results

#### Milestone 3 (Weeks 9–12): Documentation & Polish

- Write tutorial notebook: *Using azula samplers with FMPE/NPSE*
- Add API documentation with docstrings following Google style
- Write migration guide for users switching from default to azula samplers
- Final performance benchmarks and comparison report
- Code review iterations with mentors
- **Final evaluation deliverable:** merged PR with full feature, tests, docs

---

## 5. Competitive Differentiation Strategy

1. **Show working code, not just plans** – submit a PR with the prototype adapter + benchmarks BEFORE the proposal deadline
2. **Demonstrate benchmark results** – Jan explicitly asked for mini-sbibm comparisons; actually doing this shows you understood the conversation
3. **Have a merged contribution PR** – even a small doc fix proves you can navigate the codebase and CI pipeline
4. **Engage on Discord** – direct mentor contact is explicitly encouraged and shows genuine interest
5. **Reference PR #1736 and #1754** – show you understand the current state of the noise schedule refactoring and how azula fits into it

---

## 6. Technical Architecture Summary

### 6.1 SBIDenoiser Adapter

```python
class SBIDenoiser(nn.Module):
    """Wraps sbi's score estimator as an azula-compatible denoiser."""

    def __init__(self, score_estimator):
        self.score_estimator = score_estimator

    def forward(self, x: Tensor, t: Tensor) -> Tensor:
        # azula: t is [B] — sbi expects [B, 1, ...]
        t_sbi = t.view(-1, *([1] * (x.dim() - 1)))
        return self.score_estimator(x, t_sbi)
```

Key responsibilities:
- Convert azula's 1D time tensor `[B]` to sbi's format `[B, 1, ...]`
- Bridge the gradient-based (sbi) to denoiser-based (azula) interface gap
- Preserve gradient flow for optimization-based inference

### 6.2 AzulaDiffuser Wrapper

```python
class AzulaDiffuser(Diffuser):
    """sbi-compatible wrapper for azula samplers."""

    def __init__(self, azula_sampler_cls, **sampler_kwargs):
        self.azula_sampler_cls = azula_sampler_cls
        self.sampler_kwargs = sampler_kwargs

    def run(self, score_estimator, x_o, num_samples, **kwargs):
        denoiser = SBIDenoiser(score_estimator)
        sampler = self.azula_sampler_cls(denoiser, **self.sampler_kwargs)
        return sampler.sample(num_samples, x_o)
```

Key responsibilities:
- Accept azula sampler class (`DDPMSampler`, etc.) and configuration kwargs
- Instantiate azula sampler with `SBIDenoiser` wrapper
- Delegate the `run()` sampling loop entirely to azula
- Expose sbi-compatible API for drop-in replacement

### 6.3 Integration Points

| File | Purpose |
|------|---------|
| `sbi/samplers/score/azula_diffuser.py` | New module for both classes |
| `sbi/inference/posteriors/score_posterior.py` | Wire `AzulaDiffuser` as alternative |
| `pyproject.toml` | Add azula as optional dependency (`[diffusion]` extra) |
| `tests/azula_diffuser_test.py` | Comprehensive test suite |

---

## 7. Key Links & Resources

| Resource | Link |
|----------|------|
| sbi repository | https://github.com/sbi-dev/sbi |
| Azula library | https://github.com/probabilists/azula |
| Azula docs | https://azula.readthedocs.io |
| GSoC project issue | sbi-dev/sbi#1468 |
| Noise schedule PR (merged) | sbi-dev/sbi#1736 |
| mini-sbibm benchmarks | sbi-dev/sbi benchmarks/ |
| Karras et al. EDM paper | https://arxiv.org/abs/2206.00364 |

---

*End of Implementation Plan — Good luck, Zakir!*
