# Open Climate Fix: 5-Day Blitz Contribution Plan

**Project:** Quartz Solar — TabPFN Error Adjustment
**Organization:** Open Climate Fix
**Proposal deadline:** March 24, 2026
**Stack:** Python, scikit-learn, TabPFN, pytest, React (optional)

---

## CRITICAL RULES

1. **Comment on issue first** before starting any work — OCF explicitly requires this
2. **pytest must pass** before any PR
3. **Follow existing code style** — check existing files before writing new ones
4. **Type annotations** are expected in Python code
5. **Draft PRs are acceptable** and encouraged for complex changes

---

## Day 1 — March 19: Setup + First Contribution

### Hour-by-Hour

**08:00–09:30 — Environment Setup**
```bash
git clone https://github.com/openclimatefix/open-source-quartz-solar-forecast.git
cd open-source-quartz-solar-forecast
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
pip install -e ".[dev]"  # Development install

# Verify tests pass
pytest
pytest --cov=quartz_solar_forecast --cov-report=term-missing
```

**09:30–11:00 — Codebase Study**
- Read the main prediction pipeline
- Understand the current model architecture (Gradient Boosting, XGBoost)
- Understand the data flow: input features → prediction → output
- Find the error/residual calculation code (if it exists)
- Note: Where would a TabPFN adjuster plug in?

**11:00–12:30 — First Issue**

Browse: `https://github.com/openclimatefix/open-source-quartz-solar-forecast/issues`

Best first targets:
- Missing type annotations on existing functions
- Missing tests for existing functions
- Documentation improvements
- Small bug fixes

Post claim comment:
```
I'd like to work on this as a GSoC 2026 applicant (Quartz Solar adjuster project).

I've reviewed the codebase and understand the scope. My approach:
1. [Step 1]
2. [Step 2]

Starting now.
```

**12:30–14:00 — PR #1**
```bash
git checkout -b fix/issue-NNN-description
# Make the change
pytest  # Must pass
# If adding types: mypy quartz_solar_forecast/
git add [specific files]
git commit -m "fix: [description]"
git push origin fix/issue-NNN-description
```

**14:00–15:00 — Community Intro**

Post in OCF Slack (if accessible) or GitHub Discussions:
```
Hi Open Climate Fix! I'm Zakir — ML/AI developer applying for GSoC 2026
on the Quartz Solar error adjustment project (TabPFN adjuster).

Background: I've worked with tabular ML models, error correction
pipelines, and uncertainty quantification in my projects (spectra
RAG evaluation toolkit, aegis intelligence platform). The TabPFN
approach to forecast error adjustment is technically interesting —
learning systematic residuals is a cleaner framing than trying to
build a better base model.

I've set up the local environment and run the test suite. Just
submitted PR #NNN on [issue].

GitHub: JiwaniZakir
```

**15:00–17:00 — TabPFN Study**

Read:
- TabPFN paper: https://arxiv.org/abs/2207.01848
- Understand what makes TabPFN different from other tabular models
- Note: How does TabPFN's prior-data fitting translate to error adjustment?
- Think about: What features would a TabPFN adjuster use? (time-of-day, season, weather features, current forecast value)

**17:00–19:00 — Proposal Skeleton**
Write synopsis + 4 key deliverables + preliminary approach in PROPOSAL_DRAFT.md.

---

## Day 2 — March 20: Second PR + Technical Engagement

**Target:** Second PR submitted. Specific question posted about adjuster integration.

### Tasks

**08:00–09:00** — Address Day 1 PR feedback immediately.

**09:00–12:00** — **PR #2: More Substantial**

Good targets:
- Add a test for an existing model evaluation function
- Add type annotations to a specific module
- Fix an existing bug in error handling or data processing

**12:00–14:00** — Post a technical question as a GitHub issue or Discussion:
```
[Discussion] TabPFN Adjuster Integration Design

I'm designing my GSoC proposal for the error adjustment project
and want to think through the integration point.

Current flow:
forecast = run_forecast(site, start_time, end_time)
# Returns predicted power output

Proposed adjuster flow:
raw_forecast = run_forecast(site, start_time, end_time)
adjustment = tabpfn_adjuster.predict(raw_forecast, features)
adjusted_forecast = raw_forecast + adjustment

Questions:
1. Should the adjuster use only the raw forecast as input, or also
   the original weather/site features used to generate it?
2. For the training set: how many historical (forecast, actual) pairs
   are needed before TabPFN can generalize? Is 30 days enough?
3. For the API endpoint: should adjustment be opt-in (run_forecast
   returns raw, separate endpoint for adjusted) or default-on?

My preference: opt-in (run_forecast(apply_adjuster=True)) for backward
compatibility. But I want to understand the team's thinking.
```

**14:00–17:00** — Study error patterns:
- How do existing models fail? (time-of-day bias, seasonal effects?)
- What features correlate with larger errors?
- Document findings — this becomes the "Problem Statement" in your proposal

**17:00–21:00** — Write full Technical Approach in proposal.

---

## Day 3 — March 21: Substance

**Target:** Third PR. Proposal 80% complete.

### Tasks

**09:00–12:00** — **PR #3: Meaningful code contribution**

Best targets:
- Improve existing test coverage on a model function
- Fix an error handling gap in the prediction pipeline
- Add utility function that would be useful for the adjuster (e.g., residual calculation helper)

**12:00–14:00** — Community: comment on 2 open issues or PRs.

**14:00–16:00** — Run a quick TabPFN experiment locally on dummy data to understand the API:
```python
from tabpfn import TabPFNClassifier  # or regressor
# Test how it handles small tabular data
# This informs your proposal's confidence about implementation
```

**16:00–21:00** — Complete Timeline + Deliverables + About Me in proposal.

---

## Day 4 — March 22: Polish

**Target:** Proposal review-ready.

### Tasks

**09:00–11:00** — Address all PR feedback.

**11:00–13:00** — Post proposal outline to OCF community for feedback.

**13:00–21:00** — Final proposal polish.

---

## Day 5 — March 23: Submit

**Target:** Proposal submitted.

---

## March 24: Submit Day

Final check on all 5 proposals. Submit.

---

## PR Checklist

- [ ] `pytest` passes
- [ ] Type annotations present on new functions
- [ ] No unrelated changes
- [ ] Issue commented before starting work
- [ ] PR description explains what + why
- [ ] CI green before requesting review

---

## Key Resources

| Resource | URL |
|----------|-----|
| Repository | https://github.com/openclimatefix/open-source-quartz-solar-forecast |
| TabPFN paper | https://arxiv.org/abs/2207.01848 |
| TabPFN package | https://github.com/automl/TabPFN |
| OCF Slack | Check project README for invite link |

---

**Last Updated:** March 19, 2026
**Mode:** 5-day blitz
