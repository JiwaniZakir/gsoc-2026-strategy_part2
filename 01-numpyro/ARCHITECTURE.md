# numpyro — Codebase Architecture

**Repo:** https://github.com/pyro-ppl/numpyro
**Language:** Python (JAX backend)
**Python version:** 3.9+

---

## Directory Structure

```
numpyro/
├── numpyro/                    # Main package
│   ├── __init__.py             # Top-level exports
│   ├── primitives.py           # Core model primitives: sample(), param(), plate()
│   ├── util.py                 # JAX utilities, caching helpers
│   ├── ops/                    # Low-level JAX operations
│   │   ├── linalg.py           # Matrix operations (scale_tril, cholesky, etc.)
│   │   └── special.py          # Special math functions
│   ├── distributions/          # Probability distributions
│   │   ├── __init__.py         # Exports all distributions
│   │   ├── continuous.py       # Normal, Beta, Gamma, etc.
│   │   ├── discrete.py         # Bernoulli, Categorical, Binomial, etc.
│   │   ├── multivariate.py     # MultivariateNormal, Dirichlet, etc.
│   │   ├── mixtures.py         # Mixture distributions
│   │   ├── constraints.py      # Constraint classes (positive, simplex, etc.)
│   │   ├── transforms.py       # Transform classes (ExpTransform, SigmoidTransform, etc.)
│   │   └── kl.py               # KL divergence implementations
│   ├── infer/                  # Inference algorithms
│   │   ├── __init__.py
│   │   ├── mcmc.py             # MCMC base class
│   │   ├── hmc.py              # HMC kernel
│   │   ├── nuts.py             # NUTS kernel
│   │   ├── svi.py              # Stochastic Variational Inference
│   │   ├── autoguide.py        # AutoGuides (AutoNormal, AutoDiagonalNormal, etc.)
│   │   ├── elbo.py             # ELBO objectives (Trace_ELBO, RenyiELBO, etc.)
│   │   ├── reparam.py          # Reparameterization strategies
│   │   └── initialization.py   # Parameter initialization strategies
│   ├── diagnostics.py          # MCMC diagnostics (summary, r_hat, ess)
│   ├── handlers.py             # Effect handlers (trace, condition, substitute)
│   ├── optim.py                # Optimizer wrappers (Adam, Adagrad, etc.)
│   └── contrib/                # User-contributed models and utilities
│       ├── nested_sampling.py  # Nested sampling interface
│       └── ...
├── docs/
│   ├── source/
│   │   ├── conf.py             # Sphinx config
│   │   ├── tutorials/          # Tutorial RST files
│   │   └── api/                # API reference
│   └── Makefile
├── notebooks/                  # Jupyter example notebooks
│   ├── bayesian_regression.ipynb
│   ├── mcmc_diagnostics.ipynb
│   └── ...
├── tests/
│   ├── test_distributions.py   # Distribution tests
│   ├── test_mcmc.py            # MCMC tests
│   ├── test_svi.py             # SVI tests
│   ├── test_transforms.py      # Transform tests
│   └── test_diagnostics.py     # Diagnostic tests
├── setup.py
├── requirements.txt
└── .github/
    └── workflows/
        ├── test.yml            # CI: pytest on Python 3.9–3.12, CPU and GPU
        └── docs.yml            # Docs build
```

---

## Key Concepts

### Effect Handlers (primitives.py, handlers.py)

NumPyro uses an effect handler system similar to Pyro. The core primitives are:
- `numpyro.sample(name, dist)` — declare a random variable
- `numpyro.param(name, init)` — declare a trainable parameter
- `numpyro.plate(name, size)` — declare conditional independence (vectorized)

Effect handlers intercept these primitives:
- `handlers.trace` — records all primitive calls
- `handlers.condition` — fixes values of named sites
- `handlers.substitute` — replaces samples with given values

### Distributions (distributions/)

All distributions extend `Distribution`. Key methods:
- `sample(key, sample_shape)` — JAX-based sampling
- `log_prob(value)` — log probability density
- `support` — a `Constraint` object

Transforms extend `Transform`:
- `__call__(x)` — forward pass
- `_inverse(y)` — inverse
- `log_abs_det_jacobian(x, y)` — LADJ for change-of-variables

### Inference (infer/)

**MCMC:**
```python
kernel = NUTS(model)
mcmc = MCMC(kernel, num_warmup=500, num_samples=1000)
mcmc.run(rng_key, *args)
samples = mcmc.get_samples()
```

**SVI:**
```python
guide = AutoNormal(model)
optimizer = numpyro.optim.Adam(0.01)
svi = SVI(model, guide, optimizer, loss=Trace_ELBO())
svi_result = svi.run(rng_key, 1000, *args)
params = svi_result.params
```

### Diagnostics (diagnostics.py)

Key functions:
- `summary(samples)` — computes mean, std, quantiles, r_hat, n_eff per site
- `effective_sample_size(samples)` — ESS computation
- `gelman_rubin(samples)` — R-hat convergence diagnostic
- `split_gelman_rubin(samples)` — Split-R-hat (more robust)

---

## Build and Test Commands

```bash
# Install for development
pip install -e ".[dev]"

# Run all tests
pytest tests/ -v

# Run specific test file
pytest tests/test_distributions.py -v

# Run with JAX CPU backend (faster for CI)
JAX_PLATFORM_NAME=cpu pytest tests/ -q

# Run tests matching a pattern
pytest tests/ -k "test_normal or test_transform" -v

# Build docs
cd docs && make html

# Lint (uses flake8 + black)
flake8 numpyro/
black --check numpyro/
```

---

## Where to Start Contributing

| Goal | File to Read First |
|------|--------------------|
| New distribution | `numpyro/distributions/continuous.py` |
| New transform/constraint | `numpyro/distributions/transforms.py`, `constraints.py` |
| MCMC kernel | `numpyro/infer/hmc.py` |
| SVI / guide | `numpyro/infer/autoguide.py` |
| Diagnostics | `numpyro/diagnostics.py` |
| Tutorial notebook | `notebooks/` |
| Tests | `tests/test_distributions.py` for distribution-level tests |

---

## JAX-Specific Patterns

```python
import jax
import jax.numpy as jnp
from jax import random

# Always use JAX random keys, not numpy
key = random.PRNGKey(0)
key, subkey = random.split(key)

# Use jnp instead of np
x = jnp.array([1.0, 2.0, 3.0])

# JIT-compile for performance
@jax.jit
def my_function(x):
    return jnp.sum(x ** 2)

# vmap for vectorization
batched_fn = jax.vmap(my_function)

# grad for automatic differentiation
grad_fn = jax.grad(my_function)
```

**Critical:** All numpyro code must be JAX-JIT compatible. Avoid Python control flow that depends on traced values — use `jax.lax.cond`, `jax.lax.while_loop`, `jax.lax.scan` instead.
