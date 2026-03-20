# sbi — Codebase Architecture

**GitHub:** https://github.com/sbi-dev/sbi
**Stack:** Python 3.9+, PyTorch, SciPy, NumPy

---

## Repository Structure

```
sbi/
├── sbi/
│   ├── inference/              # Main inference algorithms
│   │   ├── snpe/               # Sequential Neural Posterior Estimation
│   │   │   ├── snpe_a.py       # NPE-A (SNPE)
│   │   │   ├── snpe_b.py       # NPE-B
│   │   │   └── snpe_c.py       # NPE-C (APT — most widely used)
│   │   ├── snle/               # Sequential Neural Likelihood Estimation
│   │   ├── snre/               # Sequential Neural Ratio Estimation
│   │   └── posteriors/
│   │       ├── base.py         # NeuralPosterior ABC
│   │       ├── direct_posterior.py    # For SNPE
│   │       ├── likelihood_based_posterior.py
│   │       └── ratio_based_posterior.py
│   ├── neural_nets/
│   │   ├── estimators/
│   │   │   ├── base.py         # ConditionalDensityEstimator ABC
│   │   │   └── categorical.py
│   │   └── flow_matching.py    # NEW — Azula integration goes here
│   ├── samplers/               # MCMC, rejection, importance samplers
│   ├── analysis/               # Posterior analysis utilities
│   └── utils/                  # Torch utilities
├── tests/                      # pytest test suite
├── tutorials/                  # Jupyter notebooks
├── docs/                       # Sphinx documentation
└── benchmarks/                 # Benchmark suite
```

---

## Key Interfaces for the Azula Integration

### NeuralPosterior (ABC)

```python
# sbi/inference/posteriors/base.py

class NeuralPosterior(ABC):
    """Base class all posteriors must implement."""

    @abstractmethod
    def sample(
        self,
        sample_shape: torch.Size = torch.Size(),
        x: Optional[Tensor] = None,
        **kwargs,
    ) -> Tensor:
        """Draw samples from p(theta | x)."""
        ...

    @abstractmethod
    def log_prob(
        self,
        theta: Tensor,
        x: Optional[Tensor] = None,
        **kwargs,
    ) -> Tensor:
        """Compute log p(theta | x)."""
        ...

    def set_default_x(self, x: Tensor) -> "NeuralPosterior":
        """Set default conditioning observation."""
        self._x = x
        return self
```

### ConditionalDensityEstimator (ABC)

```python
# sbi/neural_nets/estimators/base.py

class ConditionalDensityEstimator(nn.Module, ABC):
    """Network that estimates p(input | condition)."""

    @abstractmethod
    def forward(self, input: Tensor, condition: Tensor, **kwargs) -> Tensor:
        """Return log probability (or loss)."""
        ...

    @abstractmethod
    def sample(self, sample_shape: torch.Size, condition: Tensor, **kwargs) -> Tensor:
        """Draw samples from the estimated density."""
        ...
```

---

## Azula API (probabilists/azula)

```python
import azula
from azula.nn import FlattenLayer
from azula.denoise import GaussianDenoiser
from azula.sample import DDPMSampler

# Azula's core abstraction:
# A denoiser that learns to denoise samples corrupted at various noise levels.
# Training: minimize E[||denoiser(x_t, t, condition) - x_0||^2]
# Sampling: use DDPM or flow matching ODE to denoise from noise → sample

# Creating a conditional denoiser:
denoiser = GaussianDenoiser(
    backbone=MyNetwork(input_dim, condition_dim),
    sigma_min=0.01,
    sigma_max=20.0,
)

# Sampling:
sampler = DDPMSampler(denoiser, steps=50)
samples = sampler.sample(shape=(100,), condition=x_obs)
```

---

## How the New Classes Fit

```
SNPE_Azula (new)
    │ builds
    ▼
AzulaFlowMatchingEstimator (new, extends ConditionalDensityEstimator)
    │ wraps
    ▼
azula.GaussianDenoiser (external library)

SNPE_Azula.build_posterior()
    │ returns
    ▼
AzulaFlowMatchingPosterior (new, extends NeuralPosterior)
    │ uses
    ▼
DDPMSampler (from azula) for .sample()
```

---

## Build & Test Commands

```bash
# Install in dev mode
pip install -e ".[dev]"

# Run full test suite
pytest tests/ -v --tb=short

# Run specific test
pytest tests/test_npe.py::test_c_posterior_correction -v

# Run benchmarks
python benchmarks/run_benchmark.py --task two_moons --method npe

# Build docs
cd docs && make html

# Type checking
mypy sbi/
```

---

## Where to Find Good First Issues

```bash
# Open good-first-issue labeled issues
gh issue list --repo sbi-dev/sbi --label "good first issue" --limit 20

# Check discussion for project ideas
gh api repos/sbi-dev/sbi/discussions | jq '.[].title'
```

---

## CI Pipeline

GitHub Actions on every PR:
1. `pytest tests/` — full test suite (Linux + MacOS)
2. `mypy` — type checking
3. `black` / `isort` — code formatting
4. Coverage report

**Always run `pytest tests/ -x` locally before pushing.**
