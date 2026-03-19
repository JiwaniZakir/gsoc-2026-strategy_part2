# Open Climate Fix: AI-Augmented Contribution Plan

**Priority:** #2 — Moderate competition, pvnet nearly untouched
**Project:** Quartz Solar — TabPFN Error Adjustment
**Organization:** Open Climate Fix
**Proposal deadline:** March 24, 2026
**Stack:** Python, scikit-learn, TabPFN, XGBoost, LightGBM, pytest, pvlib

---

## Why OCF is #2

- **pvnet repo** (49 stars, 14 open issues) is vastly less contested than quartz-solar-forecast
- Raakshass has 4 PRs in quartz-solar but pvnet is open territory
- Climate tech framing = compelling GSoC narrative
- Python/ML stack is Zakir's strongest domain
- peterdudfield is approachable (community-friendly per intelligence)

---

## CRITICAL RULES

1. **Comment on issue first** before starting any work — OCF explicitly requires this
2. **pytest must pass** before any PR
3. **Type annotations** are expected in Python code
4. **Target pvnet** (openclimatefix/pvnet) for first contributions — less competition
5. **Avoid Raakshass territory** in quartz-solar: ML models (LightGBM v3), Python 3.12 compat, React dashboard

---

## Competition Map

| Competitor | Their PRs | Claim | Counter-Move |
|-----------|----------|-------|-------------|
| Raakshass | 4 PRs (2 merged): LightGBM, Python 3.12, Netlify, snow depth | Owns ML models + Python compat | pvnet repo + CI speed + live model evaluation |
| Sharkyii | 3 PRs: geographic viz, netcdf fix, midnight bug | Mid-level fixes | These are unmerged — check if improvable |
| CodeVishal-17 | 2 PRs (1 merged): CI rewrite, APITally monitoring | CI work | pvnet CI issues |

---

## Target Issues

### pvnet Repo (Primary Target)
Browse: https://github.com/openclimatefix/pvnet/issues

pvnet has 14 open issues and minimal PR traffic. Any contribution there is less contested.

### quartz-solar Repo (Secondary Target)
| Issue | Status | Action |
|-------|--------|--------|
| CI tests take 20 mins | Open, unclaimed | Fix it — concrete, measurable |
| Make sure all tests work | Open | Investigate and fix |
| Evaluate live models | Open | Substantive ML work |
| Should we smooth xgboost model | Open | Analysis + implementation |
| New model [help wanted] | Open | Only if pvnet work is done |

**DO NOT claim:**
- "Add python3.12" — Raakshass already has an open PR
- "Add v3 LightGBM model" — Raakshass owns this

---

## Day 1 — March 19: Setup + PR #1 (pvnet)

### Setup (07:00–08:00)
```bash
# Clone both repos
git clone https://github.com/openclimatefix/open-source-quartz-solar-forecast.git
git clone https://github.com/openclimatefix/pvnet.git

# quartz-solar setup
cd open-source-quartz-solar-forecast
python3 -m venv venv && source venv/bin/activate
pip install -r requirements.txt
pip install -e ".[dev]"
pytest  # Verify pass

# pvnet setup
cd ../pvnet
pip install -r requirements.txt
pytest  # Verify pass
```

### PR #1 — pvnet: Pick any open issue (15:00–16:30)

Browse pvnet issues and claim the most accessible one:
- Documentation improvement
- Missing type annotations
- Test for existing function

**Issue claim comment:**
```
I'd like to work on this as a GSoC 2026 applicant (Quartz Solar
TabPFN error adjustment project).

My approach:
1. [Step 1]
2. [Step 2]

Starting now.
```

```bash
cd pvnet
git checkout -b fix/issue-NNN-description
# Make change
pytest
git add [specific files]
git commit -m "fix: [description]"
git push origin fix/issue-NNN-description
```

---

## Day 2 — March 20: PR #2 (quartz-solar CI Speed)

### PR #2 — CI Speed Issue (13:30–15:00)

The "CI tests take 20 minutes" issue is unclaimed and concrete.

**Approach:**
1. Run the CI locally and time each test group
2. Identify what's slow (likely: downloading model weights, network calls)
3. Mock the slow parts or add caching
4. Result: tests run faster, clearly measurable improvement

```bash
cd open-source-quartz-solar-forecast
git checkout -b fix/ci-speed-optimization
# Profile tests: pytest --durations=20
# Identify bottleneck
# Fix it
pytest  # Verify still passes
git commit -m "fix: reduce CI test time by mocking slow network calls"
```

---

## Day 3 — March 21: PR #3 (pvnet second)

Return to pvnet for a second contribution — either a more substantive code fix or a test coverage improvement.

Browse the 14 open issues again for something you can complete in 1.5 hours.

---

## Day 4 — March 22: PR #4 (Live Model Evaluation)

The "Evaluate live models" issue is open and unclaimed. This is substantive ML work:
- Pull live model predictions
- Compare against actual solar output
- Report metrics (MAE, RMSE, bias)
- Add a benchmark script to CI

This is proposal-relevant work — live model evaluation is what the TabPFN adjuster will be evaluated against.

---

## PR Checklist

- [ ] `pytest` passes locally
- [ ] Type annotations on all new functions
- [ ] Issue commented before starting work
- [ ] CI green before requesting review
- [ ] PR description: what + why + how tested
- [ ] Issue linked (`Closes #NNN`)
- [ ] No unrelated changes

---

## TabPFN Proposal Positioning

The strongest proposal angle is not "I'll add a new model" — it's:

> "I'll build the error adjustment layer that makes all existing models better. TabPFN learns the systematic residuals between forecast and actual, regardless of which base model is used. This improves quartz-solar, pvnet, and any future model without changing them."

This framing:
1. Doesn't compete with Raakshass's model additions
2. Is a genuine architectural contribution
3. Has clear measurable deliverables (before/after MAE comparison)
4. Is more ambitious than a single model PR

---

## Key Resources

| Resource | URL |
|----------|-----|
| quartz-solar | https://github.com/openclimatefix/open-source-quartz-solar-forecast |
| pvnet | https://github.com/openclimatefix/pvnet |
| TabPFN paper | https://arxiv.org/abs/2207.01848 |
| OCF Slack | Check README for invite |

---

**Last Updated:** March 19, 2026 (post-intelligence rewrite)
**Priority:** #2 of 5
