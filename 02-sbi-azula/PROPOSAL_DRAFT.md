# GSoC 2026 Proposal — sbi: Azula Diffusion Sampling Integration

**Applicant:** Zakir Jiwani (JiwaniZakir)
**Organization:** NumFOCUS (sbi project)
**Project:** Integrate Azula Diffusion Model into sbi
**Size:** 175 hours | **Difficulty:** Medium

---

## Abstract

I will integrate [Azula](https://github.com/probabilists/azula), a diffusion-based
density estimation library, into sbi as a first-class density estimator backend.
This will give sbi users an expressive, non-normalizing-flow posterior sampler
that excels on multimodal and high-dimensional posteriors where current flow-based
methods struggle. By the end of GSoC, sbi users will be able to run:

```python
inference = SNPE(prior=prior, density_estimator="azula_flow_matching")
inference.append_simulations(theta, x).train()
posterior = inference.build_posterior()
samples = posterior.sample((1000,), x=x_obs)
```

---

## Motivation

Simulation-based inference with sbi depends critically on the expressiveness of
the density estimator. Current options (normalizing flows via nflows, glasflow) can
struggle on:
- Multimodal posteriors
- High-dimensional parameter spaces
- Posteriors with complex dependencies

Diffusion models and flow matching have demonstrated superior performance on these
cases in the generative modeling literature. Azula provides a clean, PyTorch-native
implementation of DDPM and flow matching — a natural fit for sbi's architecture.

---

## Technical Design

### New Classes

**1. `AzulaFlowMatchingEstimator`** — extends `ConditionalDensityEstimator`

Wraps Azula's `GaussianDenoiser` as a sbi-compatible density estimator.
Implements `.forward()` (training loss) and `.sample()` (posterior sampling).

**2. `AzulaFlowMatchingPosterior`** — extends `NeuralPosterior`

Wraps the trained `AzulaFlowMatchingEstimator` behind sbi's standard posterior API.
Users interact with `.sample()` and `.log_prob()` exactly as they do with existing
`DirectPosterior`.

**3. SNPE integration**

Add `"azula_flow_matching"` as a valid `density_estimator` argument in SNPE:

```python
# sbi/inference/snpe/snpe_c.py

def _build_neural_net(self, theta, x):
    if self._density_estimator == "azula_flow_matching":
        return AzulaFlowMatchingEstimator(
            input_dim=theta.shape[1],
            condition_dim=x.shape[1],
        )
    # existing logic...
```

### Training Loop

Azula uses score matching / DDPM training. The loss function:

```python
def training_step(self, theta, x):
    # Corrupt theta at random noise level
    t = torch.rand(theta.shape[0])
    noise = torch.randn_like(theta)
    sigma = self.noise_schedule(t)
    theta_noisy = theta + sigma.unsqueeze(1) * noise

    # Denoiser predicts original theta
    theta_pred = self.denoiser(theta_noisy, t, condition=x)
    loss = F.mse_loss(theta_pred, theta)
    return loss
```

### Sampling

DDPM reverse process (50 steps default):

```python
def sample(self, sample_shape, x):
    sampler = DDPMSampler(self.denoiser, steps=self.num_steps)
    return sampler.sample(shape=sample_shape, condition=x)
```

---

## Evaluation Plan

Compare `AzulaFlowMatchingPosterior` against `DirectPosterior` (flow-based) on:

| Benchmark | Why |
|-----------|-----|
| Two Moons | Multimodal — where flows struggle |
| Gaussian Linear | Simple baseline, should match |
| SLCP | Complex likelihood, 5D posterior |
| Lotka-Volterra | Real simulation, irregular posterior |

Metrics: C2ST (classifier two-sample test), MMD, expected coverage.

---

## Timeline

| Period | Deliverables |
|--------|-------------|
| **Community Bonding** (May) | Deep-dive sbi architecture, finalize Azula version pinning, discuss training hyperparameters with mentors |
| **Week 1–2** (Jun 1–14) | `AzulaFlowMatchingEstimator` — forward pass (loss computation) + unit tests |
| **Week 3–4** (Jun 15–28) | `AzulaFlowMatchingEstimator` — sampling + integration with sbi's data pipeline |
| **Week 5–6** (Jun 29–Jul 12) | `AzulaFlowMatchingPosterior` — full NeuralPosterior interface, log_prob via score |
| **Week 7** (Jul 13–19) | SNPE integration: `density_estimator="azula_flow_matching"` end-to-end |
| **Midterm eval** | Full end-to-end training and sampling working on toy examples |
| **Week 8–9** (Jul 20–Aug 2) | Benchmark evaluation (Two Moons, SLCP, Lotka-Volterra) |
| **Week 10** (Aug 3–9) | Hyperparameter configuration system, sensible defaults |
| **Week 11** (Aug 10–16) | Tutorial notebook: Azula vs flow comparison |
| **Week 12** (Aug 17–23) | Documentation, stretch goals (SNLE/SNRE support) |
| **Final week** (Aug 24–25) | Cleanup, final mentor review, GSoC submission |

---

## Deliverables

1. `sbi/neural_nets/flow_matching.py` — `AzulaFlowMatchingEstimator`
2. `sbi/inference/posteriors/flow_matching_posterior.py` — `AzulaFlowMatchingPosterior`
3. SNPE integration (`density_estimator="azula_flow_matching"` option)
4. Test suite: unit tests + benchmark comparison
5. Tutorial notebook: `tutorials/azula_flow_matching.ipynb`
6. Documentation update

---

## Why I'm the Right Person

| Requirement | My Evidence |
|-------------|------------|
| PyTorch large codebase | Merged PRs in huggingface/transformers (100k+ lines) |
| Probabilistic ML | DSPy, graphrag (graphRAG = probabilistic text analysis) |
| Python packaging | spectra, lattice — both properly packaged Python libraries |
| Test-driven development | aegis (338 tests), sentinel (209 tests) |

I have sbi running locally, Azula installed, and have read through the
`NeuralPosterior` and `ConditionalDensityEstimator` interfaces.

---

*Last Updated: March 20, 2026*
