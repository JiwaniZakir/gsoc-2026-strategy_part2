# sbi Azula — Aggressive 5-Day Contribution Plan (Mar 20–24)

**Target: 6–8 PRs in 5 days**
**Approach: Start with simple bug/test fixes to establish presence, then move toward Azula integration.**

## Environment Setup (Day 1 Morning)

```bash
git clone https://github.com/sbi-dev/sbi
cd sbi

python -m venv venv
source venv/bin/activate

# Install development dependencies
pip install -e ".[dev]"
# or:
pip install -r requirements/dev.txt

# Install Azula (the library to integrate)
pip install azula
# or from source:
pip install git+https://github.com/probabilists/azula.git

# Run tests
pytest tests/ -v --tb=short -x

# Run a quick sanity check
python -c "import sbi; import azula; print('Both installed')"
```

---

## Day 1 — March 20: Read + First PR

### Morning: Codebase orientation
```python
# Understand the NeuralPosterior interface
# sbi/inference/posteriors/direct_posterior.py

class DirectPosterior(NeuralPosterior):
    """Wraps a density estimator as a posterior."""

    def sample(self, sample_shape, x=None, **kwargs) -> Tensor: ...
    def log_prob(self, theta, x=None, **kwargs) -> Tensor: ...
```

### PR #1: Good-first-issue or documentation fix

Find via:
```
https://github.com/sbi-dev/sbi/issues?q=is%3Aopen+label%3A%22good+first+issue%22
```

Good targets:
- Docstring improvement on any inference class
- Type annotation addition
- Test for an edge case in existing posterior
- CI timeout fix

```bash
git checkout -b fix/[issue-description]
pytest tests/ -v  # MUST PASS
gh pr create --title "fix: [description]" --body "Closes #[n]"
```

---

## Day 2 — March 21: PRs #2 and #3

### PR #2: Add test for existing sampler

Pick an inference algorithm (e.g., NPE-C) and add a test for an untested edge case:

```python
# tests/test_npe.py

def test_npe_c_with_single_observation():
    """NPE-C should handle single-observation x without broadcasting errors."""
    prior = BoxUniform(low=torch.zeros(2), high=torch.ones(2))
    simulator = lambda theta: theta + torch.randn_like(theta) * 0.1

    inference = NPEC(prior=prior)
    theta, x = simulate_for_sbi(simulator, prior, num_simulations=100)
    inference.append_simulations(theta, x).train(max_num_epochs=2)
    posterior = inference.build_posterior()

    # Single observation (no batch dim)
    x_obs = torch.zeros(2)
    samples = posterior.sample((10,), x=x_obs)
    assert samples.shape == (10, 2)
```

### PR #3: Azula exploration PR (opens discussion)

Open a draft PR with a skeleton of the Azula integration — this starts the
architectural conversation with maintainers before committing to a full implementation:

```python
# sbi/neural_nets/flow_matching.py (new file)

"""Flow matching density estimators using Azula."""

import torch
from torch import Tensor
from azula.nn import FlattenLayer  # example import
from sbi.neural_nets.estimators.base import ConditionalDensityEstimator


class AzulaFlowMatchingEstimator(ConditionalDensityEstimator):
    """
    DRAFT: Conditional density estimator using Azula flow matching.

    This is a proof-of-concept for the GSoC 2026 Azula integration project.
    See: https://github.com/sbi-dev/sbi/issues/[GSoC issue number]

    Not ready for production use.
    """

    def __init__(self, input_dim: int, condition_dim: int):
        super().__init__()
        # TODO: initialize Azula network here
        pass

    def forward(self, input: Tensor, condition: Tensor) -> Tensor:
        # TODO: flow matching forward pass
        raise NotImplementedError("WIP — Azula integration in progress")
```

Mark as `[Draft]` — the goal is to start the design conversation.

---

## Day 3 — March 22: PRs #4 and #5 — Deeper Integration

### PR #4: Azula FlowMatchingPosterior skeleton

After getting feedback on the draft PR, implement the full `NeuralPosterior` subclass:

```python
# sbi/inference/posteriors/flow_matching_posterior.py

class AzulaFlowMatchingPosterior(NeuralPosterior):
    """
    Posterior using Azula diffusion/flow matching for sampling.

    Implements the NeuralPosterior interface so it's drop-in compatible
    with the rest of sbi.
    """

    def __init__(self, net, prior, x_shape):
        super().__init__(prior=prior)
        self.net = net
        self._x_shape = x_shape

    @torch.no_grad()
    def sample(
        self,
        sample_shape: torch.Size = torch.Size(),
        x: Optional[Tensor] = None,
        **kwargs,
    ) -> Tensor:
        """Sample from posterior using Azula's DDPM sampler."""
        # Use Azula's sampling API
        samples = self.net.sample(
            shape=sample_shape,
            condition=x.repeat(sample_shape[0], 1) if x is not None else None,
        )
        return samples

    def log_prob(self, theta: Tensor, x: Optional[Tensor] = None, **kwargs) -> Tensor:
        """Approximate log prob via Azula's score function."""
        return self.net.log_prob(theta, condition=x)
```

### PR #5: Training loop for Azula estimator

```python
# sbi/inference/snpe/snpe_azula.py

class SNPE_Azula(PosteriorEstimator):
    """SNPE with Azula flow matching density estimator."""

    def __init__(self, prior, density_estimator="azula_flow_matching", **kwargs):
        super().__init__(prior=prior, density_estimator=density_estimator, **kwargs)

    def _build_neural_net(self, theta, x) -> AzulaFlowMatchingEstimator:
        theta_numel = theta.shape[1]
        x_numel = x.shape[1]
        return AzulaFlowMatchingEstimator(
            input_dim=theta_numel,
            condition_dim=x_numel,
        )
```

---

## Day 4 — March 23: Tests + Benchmark

### PR #6: Tests for Azula integration

```python
# tests/test_azula_integration.py

@pytest.mark.parametrize("num_simulations", [50, 200])
def test_snpe_azula_runs(num_simulations):
    """SNPE with Azula estimator should train and sample without errors."""
    prior = BoxUniform(low=torch.zeros(2), high=torch.ones(2))
    simulator = diagonal_linear_gaussian

    inference = SNPE_Azula(prior=prior)
    theta, x = simulate_for_sbi(simulator, prior, num_simulations=num_simulations)
    inference.append_simulations(theta, x).train(max_num_epochs=3)
    posterior = inference.build_posterior()
    samples = posterior.sample((100,), x=torch.zeros(2))

    assert samples.shape == (100, 2)
    assert not torch.isnan(samples).any()

def test_azula_posterior_log_prob():
    """log_prob should return finite values."""
    # ... setup ...
    log_probs = posterior.log_prob(samples, x=x_obs)
    assert torch.isfinite(log_probs).all()
```

### PR #7: Tutorial notebook

Add `tutorials/azula_flow_matching.ipynb`:
- Simple 2D Gaussian example
- Compare Azula vs normalizing flow posterior
- Visualization of posterior samples

---

## Day 5 — March 24: Docs + Proposal submission

### PR #8: Documentation

Update `docs/` to describe the new Azula backend:
- When to use diffusion vs normalizing flows
- Configuration options
- Performance characteristics

---

## PR Summary Table

| Day | PR | Type |
|-----|-----|------|
| Mar 20 | #1 | Good-first-issue: bug/docs |
| Mar 21 | #2 | Tests: edge case |
| Mar 21 | #3 | Draft: Azula skeleton (open discussion) |
| Mar 22 | #4 | Feature: FlowMatchingPosterior |
| Mar 22 | #5 | Feature: SNPE_Azula training loop |
| Mar 23 | #6 | Tests: Azula integration |
| Mar 23 | #7 | Tutorial notebook |
| Mar 24 | #8 | Documentation |
