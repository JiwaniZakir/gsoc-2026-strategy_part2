# sbi Azula — Outreach & Engagement Guide

---

## Day 1 — March 20: GitHub Discussions Introduction

**Channel:** https://github.com/sbi-dev/sbi/discussions (open a new discussion)

```
Subject: GSoC 2026 — Azula diffusion sampling integration — introduction and questions

Hi sbi team,

I'm Zakir Jiwani (GitHub: JiwaniZakir), applying for GSoC 2026 to work on the
Azula diffusion sampling integration under NumFOCUS.

Background: Python/ML developer with PyTorch experience (merged PRs in
huggingface/transformers), plus probabilistic ML work (DSPy, graphrag).
I've set up sbi locally and run the test suite.

I've started looking at the NeuralPosterior interface and the existing flow-based
density estimators to understand where AzulaFlowMatchingPosterior would fit.

A few questions before I open a design PR:
1. Should AzulaFlowMatchingPosterior extend NeuralPosterior directly, or should
   there be an intermediate FlowMatchingPosterior base class?
2. Is the preference to start with DDPM sampling, flow matching, or both?
3. Are there specific sbi benchmarks I should target for evaluation?

First PR submitted today: [link] — [brief description]

Looking forward to contributing.

Zakir
```

---

## Day 2 — March 21: Issue Comment

On the GSoC idea issue (or any relevant issue):

```
I've started implementing the AzulaFlowMatchingEstimator skeleton based on the
ConditionalDensityEstimator interface. Draft PR here: [link]

Architecture question: I'm currently planning to implement the training loop in a
new SNPE_Azula class that inherits from PosteriorEstimator. Does that fit with
how the project handles new estimator backends, or would you prefer the Azula
estimator to be a drop-in option for the existing SNPE/SNLE/SNRE classes?

Happy to adjust the approach based on your preference.
```

---

## Day 3 — March 22: Proposal Preview

Post a proposal outline in Discussions:

```
Subject: GSoC 2026 Proposal Preview — Azula Integration

Hi sbi team,

Here's a condensed version of my GSoC proposal for early feedback.

## Goal
Integrate Azula diffusion/flow matching as a density estimator backend in sbi,
giving users a non-flow-matching alternative posterior sampler with better
expressiveness on multimodal posteriors.

## Deliverables
1. AzulaFlowMatchingEstimator class (ConditionalDensityEstimator interface)
2. AzulaFlowMatchingPosterior class (NeuralPosterior interface)
3. SNPE_Azula training algorithm
4. Tests against sbi's benchmark suite
5. Tutorial notebook comparing Azula vs normalizing flow posteriors

## Week-by-week timeline (condensed)
- Weeks 1–3: Core Azula estimator + NeuralPosterior integration
- Weeks 4–6: Training loop, hyperparameter configuration
- Weeks 7–9: Testing against benchmarks, evaluation metrics
- Weeks 10–12: Tutorial, documentation, stretch goals

I've already submitted [N] PRs this week: [links]

Questions:
1. Is there a preferred Azula model architecture for this use case?
2. Should the tutorial compare against NPE-C or a simpler baseline?

Thanks, Zakir
```

---

## Day 4 — March 23: Direct Mentor Outreach

DM the primary reviewer on GitHub or NumFOCUS Slack:

```
Hi [maintainer],

I've submitted [N] PRs to sbi this week:
- [PR link 1]: [brief description] — [status]
- [PR link 2]: [brief description] — [status]
- Draft PR [link]: Azula FlowMatchingPosterior skeleton — would love your feedback

I'm applying for the GSoC Azula integration project and have my proposal ready.
Would you be willing to share early feedback on the implementation direction?

The main design question I have: should AzulaFlowMatchingPosterior be LLM-agnostic
from the start (supporting both DDPM and flow matching), or start simpler with
flow matching only?

Zakir (JiwaniZakir)
```

---

## Key Talking Points

1. **"PyTorch experience from huggingface/transformers PRs"** — establishes large-codebase credibility.
2. **"Familiar with density estimators from DSPy/graphrag work"** — shows probabilistic ML background.
3. **"Already running sbi locally with Azula installed"** — shows you're not starting from zero.
4. **"I've read the NeuralPosterior interface"** — shows architectural understanding.

---

## What NOT to Do

- Don't just say "I want to work on Azula" without mentioning specific technical details.
- Don't submit the Azula draft PR before having one merged non-GSoC PR first.
- Don't skip the benchmark comparison in the proposal — sbi is a research library and evaluation matters.
