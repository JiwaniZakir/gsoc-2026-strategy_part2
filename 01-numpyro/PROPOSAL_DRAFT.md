# GSoC 2026 Proposal — NumPyro / NumFOCUS

**Applicant:** Zakir Jiwani | GitHub: JiwaniZakir | jiwzakir@gmail.com
**Organization:** NumFOCUS (NumPyro project)
**Project Title:** Enhanced Variational Inference and MCMC Diagnostics in NumPyro
**Duration:** 350 hours (large project)
**Mentors:** TBD — targeting Du Phan, Martin Jankowiak

---

## Synopsis

NumPyro lacks two features that significantly limit its usability for production Bayesian workflows: (1) Automatic Structured Variational Inference (ASVGD), which enables efficient approximate inference in models with complex dependency structures, and (2) importance-weighted diagnostics in `summary()`, which are essential when samples come from IS/SMC estimators. This project delivers both, along with a suite of practical tutorial notebooks demonstrating their use.

---

## Background and Motivation

NumPyro's SVI interface is powerful but currently relies on mean-field approximations (`AutoNormal`, `AutoDiagonalNormal`) that ignore posterior correlations. For models with strong latent variable correlations — hierarchical models, state-space models, neural networks — this leads to overconfident posteriors and poor predictive performance.

**ASVGD** (Automatic Structured Variational Inference, [Ambrogioni et al. 2021](https://arxiv.org/abs/2007.06505)) addresses this by automatically constructing a structured guide that captures posterior dependencies using a mean-field approximation over the *residuals* of an autoregressive flow. It has been implemented in Pyro (PyTorch) but not yet in NumPyro/JAX.

Additionally, `numpyro.diagnostics.summary()` does not support importance weights (issue #810), making it unusable for Sequential Monte Carlo and Importance Sampling workflows where each sample has a different weight.

---

## Deliverables

### Deliverable 1: Weighted Diagnostics in `summary()` (Weeks 1–3)
- Add `weights` parameter to `numpyro.diagnostics.summary()`
- Implement weighted mean, variance, and quantile estimation using JAX operations
- Add weighted ESS (Effective Sample Size) calculation
- Full test coverage with known analytical distributions
- Documentation and docstring update

### Deliverable 2: `CatTransform` and `constraints.cat` (Weeks 4–6)
- Implement `CatTransform` for concatenating transformed distributions (issue #1872)
- Implement `constraints.cat` constraint
- Ensure JAX JIT compatibility and correct batching behavior
- Tests covering forward, inverse, and log-abs-det-jacobian

### Deliverable 3: Automatic Structured Variational Inference (Weeks 7–14)
- Implement `AutoStructuredGuide` class in `numpyro/infer/autoguide.py`
- Build dependency graph from model trace using existing `Trace` utilities
- Implement residual computation and autoregressive flow approximation
- Integration with existing `SVI` and `Predictive` interfaces
- Benchmark against `AutoNormal` on standard test cases (Neal's funnel, Gaussian mixture)

### Deliverable 4: Tutorial Notebooks (Weeks 10–14)
- "Bayesian hierarchical modeling with ASVGD" — full notebook with posterior comparison
- "Sequential Monte Carlo with weighted diagnostics" — practical IS/SMC workflow
- "Custom distributions with CatTransform" — mixture model example
- All notebooks validated to run end-to-end with pytest-nbval

---

## Technical Approach

### ASVGD Implementation Plan

```python
class AutoStructuredGuide(AutoGuide):
    """
    Automatic Structured Variational Inference guide.

    Constructs a structured variational family by learning
    conditional dependencies between latent variables.

    :param model: The probabilistic model.
    :param init_loc_fn: Initialization strategy for guide parameters.
    """

    def __init__(self, model, init_loc_fn=init_to_median, ...):
        super().__init__(model)
        self._dependencies = None  # populated on first __call__

    def _setup_prototype(self, *args, **kwargs):
        # Run model, collect trace, infer dependency structure
        trace = handlers.trace(self.model).get_trace(*args, **kwargs)
        self._dependencies = self._infer_dependencies(trace)

    def _infer_dependencies(self, trace):
        # Build DAG from model conditional independencies
        # Use existing plate/mask information in trace
        ...

    def __call__(self, *args, **kwargs):
        # Sample using structured approximation
        # Residual-based parameterization
        ...
```

### Weighted Statistics Implementation

```python
def _weighted_quantile(samples, weights, probs):
    """Weighted quantiles via sorted cumulative weights."""
    sorted_idx = jnp.argsort(samples, axis=0)
    sorted_weights = weights[sorted_idx]
    cumulative = jnp.cumsum(sorted_weights, axis=0)
    cumulative = cumulative / cumulative[-1]
    return jnp.interp(probs, cumulative, samples[sorted_idx])
```

---

## Timeline

| Week | Milestone |
|------|-----------|
| 1–2 | Community bonding: deep codebase study, align with mentors on API design |
| 3–4 | Implement weighted statistics in `summary()`, all tests passing |
| 5–6 | Implement `CatTransform` and `constraints.cat` |
| 7–8 | Design and prototype `AutoStructuredGuide` API |
| 9–10 | Core ASVGD implementation — dependency inference |
| 11–12 | ASVGD optimization loop, integration with SVI |
| 13 | Benchmarking, bug fixes, tutorial notebooks |
| 14 | Documentation, cleanup, final PR |

---

## About Me

I am a Python/ML developer with strong experience in probabilistic programming, ML infrastructure, and large open-source codebases.

**Relevant experience:**
- Existing contributor to pyro-ppl/numpyro (PR submitted, under review)
- Merged PR in huggingface/transformers — navigating a 100k+ line ML codebase
- Merged PRs in prowler-cloud/prowler — production Python at scale
- Built **lattice** (multi-agent framework with safety guarantees) and **spectra** (RAG evaluation toolkit) — demonstrates ability to architect and ship complex Python systems
- Hands-on with JAX, LangChain, LangGraph, DSPy, transformers — fluent in the ML Python ecosystem

**Why I'll succeed:**
In the past week I contributed to 20+ repositories including huggingface/transformers (merged) and prowler-cloud/prowler (merged), demonstrating I can navigate large, unfamiliar codebases and deliver working code quickly. NumPyro is the project I'm most excited about because probabilistic programming is where I want to go deep — not just for GSoC but long-term.

---

## References

- [ASVGD paper (Ambrogioni et al. 2021)](https://arxiv.org/abs/2007.06505)
- [Pyro AutoStructured implementation](https://github.com/pyro-ppl/pyro/blob/dev/pyro/infer/autoguide/guides.py)
- [NumPyro issue #1117](https://github.com/pyro-ppl/numpyro/issues/1117)
- [NumPyro issue #810](https://github.com/pyro-ppl/numpyro/issues/810)
