# GreedyBear: AI-Augmented Contribution Plan

**Priority:** #4 — Crowded but viable if you find unclaimed territory
**Project:** Event Collector API
**Mentors:** Matteo Lodi (@mlodic), Tim Leonhard (@regulartim)
**Proposal deadline:** March 24, 2026
**Stack:** Python, Django, DRF, PostgreSQL, Elasticsearch, Django Q2, React

---

## Why GreedyBear is #4 (Not Higher)

From COMPETITOR_ANALYSIS.md:
- 10+ external PRs open simultaneously — most competitive per-star ratio of all 5 repos
- 8 external PRs merged in 3 days (March 17–19)
- drona-gyawali, rootp1, cclts already have high-quality merges
- BUT: ML model improvements are less contested
- BUT: mlodic reviews and merges same day — fast feedback loop

**The path in:** Find unclaimed issues, or work in the ML model layer which competitors have ignored in favor of frontend/backend fixes.

---

## CRITICAL RULES

1. **Scan for unclaimed issues BEFORE claiming anything** — check no linked PR exists
2. **Branch from `develop`**, never `main`
3. **Ruff must pass**: `ruff check . --fix && ruff format .`
4. **Fill PR template completely** — blank sections = rejection
5. **Draft PR within 1 week** of assignment — auto-unassign otherwise
6. **No raw AI paste** — GreedyBear's informal rules include this

---

## How to Find Unclaimed Issues

```bash
# Get all open issues
gh api "repos/intelowlproject/GreedyBear/issues?state=open&per_page=50" \
  | jq '.[] | {number: .number, title: .title}'

# Get all open PRs and extract which issues they close
gh api "repos/intelowlproject/GreedyBear/pulls?state=open&per_page=50" \
  | jq '.[] | .body' | grep -oE 'Closes #[0-9]+|Fixes #[0-9]+'

# Issues WITH open PRs (skip these):
# From REPO_INTELLIGENCE.md: #1089, #1087, #1060, #1034, #987, #852, #525
```

**Issues already claimed (per March 19 intelligence):**
- #1089 — Feeds filter state (Prasad8830)
- #1087 — training_data validation (Aditya30ag)
- #1060 — Custom labels/descriptions in Sensor model (R1sh0bh-1)
- #1034 — cronjob exception propagation (IQRAZAM)
- #987 — useAuthStore test (swara-2006)
- #852 — ASN aggregates (opbot-xd)

**Strategy:** Browse issues < #852 and > #1089 for unclaimed work.

---

## ML Model Improvement — The Differentiator

The competitors are all doing frontend/backend fixes. The Random Forest ML model layer is underserved.

**What's available:**
- `drona-gyawali` just merged "Log feature importances after RF training" — but the API doesn't expose importances
- Adding a `/api/ml/feature-importances/` endpoint would be natural follow-on work
- XGBoost or other model alternatives vs. Random Forest — analysis + implementation
- Hyperparameter tuning pipeline
- Model evaluation metrics endpoint

**This differentiates from all current competitors and is directly relevant to the GSoC project.**

---

## Day 1 — March 19: Setup + PR #1

### Setup (07:00–08:00)
```bash
git clone https://github.com/intelowlproject/GreedyBear.git
cd GreedyBear
./gbctl init --dev --elastic-local
docker ps | grep greedybear  # Verify running
pip install pre-commit
pre-commit install -c .github/.pre-commit-config.yaml
docker exec greedybear_uwsgi python3 manage.py test  # Verify all pass
```

### PR #1 — First Unclaimed Issue (13:00–15:00)

After running the unclaimed issue scan above, pick the most accessible open issue.

**Claim comment template:**
```
I'd like to work on this for GSoC 2026 (applying for Event Collector API).

I've reviewed the codebase and understand the scope.
My approach:
1. [Step 1 — specific to the issue]
2. [Step 2]
3. Test: [specific test behavior]

Starting now — draft PR within 2 hours.
```

```bash
git checkout develop && git pull origin develop
git checkout -b fix/issue-NNN-description develop

# Make the fix
ruff check . --fix && ruff format .
pre-commit run --all-files
docker exec greedybear_uwsgi python3 manage.py test

git add [specific files]
git commit -m "fix: [description]"
git push origin fix/issue-NNN-description
```

---

## Day 2 — March 20: PR #2

**Target:** Second PR in a different area. Options:
- The ML feature importances API endpoint (if you can implement it)
- Another unclaimed backend issue
- A test coverage improvement for an existing view

```bash
git checkout develop && git pull origin develop
git checkout -b [fix|feat|test]/issue-NNN-description develop
```

---

## Day 3 — March 21: PR #3 (ML Differentiator)

This is the day to submit the ML model improvement PR if you can.

**ML Feature Importances API Endpoint:**
```python
# What this looks like:
# GET /api/ml/feature-importances/
# Returns: {"features": [{"name": "...", "importance": 0.34}, ...]}

# Implementation:
# 1. Load the trained RF model from wherever it's stored
# 2. Extract .feature_importances_ from the model
# 3. Return as DRF response
# 4. Add a test
```

This PR is worth 3x a simple bug fix in terms of proposal differentiation.

---

## Day 4 — March 22: Final Polish

Address all PR feedback. If 3 PRs are in a clean state, stop adding more and focus on the proposal.

---

## PR Template (Always Use This)

```markdown
## What changed
[One sentence]

## Why
[Why this change is needed]
Fixes #[issue number]

## How I tested it
- Ran `ruff check . --fix && ruff format .` — clean
- Ran `pre-commit run --all-files` — all hooks pass
- Ran `docker exec greedybear_uwsgi python3 manage.py test` — [X] tests pass
- Manual test: [describe if applicable]

## Breaking changes
None / [describe if any]

## Related issues
Fixes #NNN
```

---

## Competitor Awareness

| Competitor | Merged/Open | Their Style | Threat Level |
|-----------|------------|-------------|-------------|
| drona-gyawali | 1 merged (ML feature importances) | ML improvements | High — but you can build on their work |
| rootp1 | 1 merged (Heralding extraction) | New extraction strategies | High quality |
| cclts | 1 merged (Cowrie file transfer) | New extraction strategies | High quality |
| opbot-xd | 1 open (ASN aggregates) | Database architecture | High |
| Prasad8830 | 1 open (feeds filter) | Frontend | Medium |

**The most dangerous competitors have already merged high-quality work.** You're competing for the next batch of issues. The ML layer is where they haven't gone yet.

---

## Key Resources

| Resource | URL |
|----------|-----|
| Repository | https://github.com/intelowlproject/GreedyBear |
| Issues | https://github.com/intelowlproject/GreedyBear/issues |
| Open PRs | https://github.com/intelowlproject/GreedyBear/pulls |
| Honeynet Discord | Check honeynet.org for invite link |

---

**Last Updated:** March 19, 2026 (post-intelligence rewrite)
**Priority:** #4 of 5
