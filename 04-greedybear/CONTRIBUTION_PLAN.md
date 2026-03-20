# GreedyBear — Aggressive 5-Day Contribution Plan (Mar 19–23)

**Target: 6–8 PRs in 5 days**
**Rule #1: Every PR must pass `ruff check` before submitting — no exceptions**

## Day 1 — March 19: Setup + First PR

### Environment Setup (07:00–10:00)
```bash
git clone https://github.com/intelowlproject/GreedyBear
cd GreedyBear

# Docker setup (recommended)
cp .env.example .env
docker compose up -d

# Local Python setup (alternative)
pip install -r requirements/development.txt
python manage.py migrate
python manage.py runserver

# Run tests
python manage.py test
# or:
pytest tests/ -v

# MANDATORY: Run ruff before every PR
ruff check .
ruff format .
```

### PR #1 (10:00–14:00): Issue #1085 — Cronjob Exception Swallowing

**Problem:** `Cronjob.execute()` catches all exceptions silently. Django-Q2 reports success, but the actual operation failed. Operators miss persistent failures.

**Fix approach:**
```python
# greedybear/cronjobs/base.py (or wherever execute() is defined)

# Before:
def execute(self):
    try:
        self._execute()
    except Exception:
        pass  # BUG: swallows exception

# After:
import logging
logger = logging.getLogger(__name__)

def execute(self):
    try:
        self._execute()
    except Exception as e:
        logger.exception(f"Cronjob {self.__class__.__name__} failed: {e}")
        raise  # Re-raise so Django-Q2 records the failure correctly
```

**Test:**
```python
def test_cronjob_execute_propagates_exceptions():
    cronjob = SomeCronjob()
    with patch.object(cronjob, '_execute', side_effect=RuntimeError("test error")):
        with pytest.raises(RuntimeError):
            cronjob.execute()
```

```bash
git checkout -b fix/cronjob-exception-propagation
ruff check .  # MUST PASS
pytest tests/ -v  # MUST PASS
gh pr create --title "fix: propagate exceptions in Cronjob.execute() to prevent silent failures" \
  --body "Closes #1085 — Cronjob.execute() was swallowing all exceptions, causing Django-Q2 to report success even when operations failed. Fix re-raises after logging so operators see actual failures."
```

---

## Day 2 — March 20: ML Bug Fix + Feeds Bug

### PR #2: Issue #1087 — Training data unsafe access
**Problem:** ML training fails when `training_data` elements are accessed without validation.

**Fix:**
```python
# greedybear/ml/training.py (or similar)

# Before:
for record in training_data:
    features.append(record["ip_reputation"])  # KeyError if key missing

# After:
for record in training_data:
    ip_rep = record.get("ip_reputation")
    if ip_rep is None:
        logger.warning(f"Record {record.get('id', 'unknown')} missing ip_reputation, skipping")
        continue
    features.append(ip_rep)
```

**Test:** Mock training_data with missing keys, assert training doesn't raise KeyError.

### PR #3: Issue #1093 — Feeds sorting regression
**Problem:** Ordering in feeds endpoint broke after DoS hardening.

**Investigation:** Read the feeds API viewset, find where ordering is applied, trace the DoS hardening commit to see what changed.

```python
# Check feeds/views.py or api/viewsets.py
# Look for queryset.order_by() being dropped or overridden

# Likely fix:
class FeedViewSet(viewsets.ModelViewSet):
    def get_queryset(self):
        qs = super().get_queryset()
        ordering = self.request.query_params.get('ordering', '-created_at')
        # DoS hardening may have removed this line:
        return qs.order_by(ordering)
```

---

## Day 3 — March 21: Issue #1092 — Feed Generation Refactor

### PR #4: Simplify feed generation internals
**Target:** Split response building and shared feed flow as requested in issue #1092.

**Approach:**
1. Read `greedybear/feeds/` — understand current flow
2. Identify the mixed concerns (response building + data fetching + serialization)
3. Extract `build_feed_response()` as a pure function separate from the shared feed flow
4. Ensure all existing tests still pass
5. Add test for the new function

This is a refactor — takes more time but shows architectural understanding.

### Also Day 3: Community + Proposal Draft
- Post in Honeynet Slack (#gsoc or #greedybear)
- Begin proposal draft

---

## Day 4 — March 22: ML Improvement PR

### PR #5: ML model enhancement
Pick one of:
- Add XGBoost or gradient boosting alternative to the Random Forest classifier
- Add feature importance logging to the ML training pipeline
- Add model evaluation metrics (precision, recall, F1) to training output

**XGBoost addition example:**
```python
# greedybear/ml/models.py

from sklearn.ensemble import RandomForestClassifier, GradientBoostingClassifier
import xgboost as xgb

AVAILABLE_MODELS = {
    "random_forest": RandomForestClassifier(n_estimators=100, random_state=42),
    "gradient_boosting": GradientBoostingClassifier(n_estimators=100, random_state=42),
    "xgboost": xgb.XGBClassifier(n_estimators=100, random_state=42, use_label_encoder=False),
}

def train_model(training_data, model_type="random_forest"):
    model = AVAILABLE_MODELS[model_type]
    # ... training logic
```

---

## Day 5 — March 23: Polish + Final PR

### PR #6: Documentation or test coverage improvement
- Add docstrings to key ML/cronjob functions
- Improve test coverage for feed generation
- Fix any remaining open bug

### Final checklist:
- [ ] All PRs pass `ruff check .` — non-negotiable
- [ ] All PRs have tests
- [ ] Responded to all PR review feedback
- [ ] Proposal submitted

---

## PR Summary Table

| Day | PR | Issue | Type |
|-----|-----|-------|------|
| Mar 19 | #1 | #1085 | Bug: cronjob exception propagation |
| Mar 20 | #2 | #1087 | Bug: ML training data validation |
| Mar 20 | #3 | #1093 | Bug: feeds sorting regression |
| Mar 21 | #4 | #1092 | Refactor: feed generation |
| Mar 22 | #5 | — | Feature: ML model alternatives |
| Mar 23 | #6 | — | Docs / tests |

---

## Ruff Compliance Checklist

Before every PR:
```bash
# Check (must show 0 violations)
ruff check .

# Auto-fix what can be fixed
ruff check --fix .

# Format
ruff format .

# Then verify once more
ruff check .
```

**GreedyBear's ruff config is strict.** If you see violations you can't auto-fix,
fix them manually before submitting. A PR with ruff violations will be rejected
immediately without review.
