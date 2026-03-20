# GSoC 2026 Proposal — Honeynet Project / GreedyBear

**Applicant:** Zakir Jiwani | GitHub: JiwaniZakir | jiwzakir@gmail.com
**Organization:** The Honeynet Project (GreedyBear)
**Project Title:** GreedyBear ML Enhancement: Multi-Model Threat Classification and Feed System Improvements
**Duration:** 350 hours (large project)
**Mentors:** TBD — targeting Matteo Lodi (mattebit)

---

## Synopsis

GreedyBear's threat classification relies on a single Random Forest model trained on honeypot data. This project expands the ML pipeline to support multiple model architectures with an evaluation framework, fixes known reliability issues in the training pipeline and feed system, adds feed pagination and advanced filtering, and improves test coverage. The result is a more reliable, extensible, and performant threat intelligence platform.

---

## Background and Motivation

### Current Limitations

**ML Pipeline:**
- Single model (Random Forest) with no alternative or comparison baseline
- Silent failures during training when records have missing fields (issue #1087)
- No model evaluation metrics tracked post-training (precision, recall, F1)
- No A/B testing mechanism to validate model improvements before deployment

**Feed System:**
- Sorting regression after DoS hardening (issue #1093) — feeds return data in wrong order
- Feed generation mixes response building with data fetching — hard to test and maintain (issue #1092)
- No pagination on feed endpoints — large datasets are returned in full, causing memory and performance issues

**Reliability:**
- `Cronjob.execute()` swallows all exceptions, causing silent failures (issue #1085)
- Difficult to monitor which honeypot collection jobs are succeeding or failing

---

## Deliverables

### Deliverable 1: ML Multi-Model Framework (Weeks 1–6)

Replace the single-model approach with a pluggable model registry:

```python
# greedybear/ml/registry.py

from sklearn.ensemble import RandomForestClassifier, GradientBoostingClassifier
from sklearn.linear_model import LogisticRegression

MODEL_REGISTRY = {
    "random_forest": RandomForestClassifier(
        n_estimators=100, random_state=42, n_jobs=-1
    ),
    "gradient_boosting": GradientBoostingClassifier(
        n_estimators=100, learning_rate=0.1, random_state=42
    ),
    "logistic_regression": LogisticRegression(
        max_iter=1000, random_state=42
    ),
}

try:
    import xgboost as xgb
    MODEL_REGISTRY["xgboost"] = xgb.XGBClassifier(
        n_estimators=100, random_state=42, eval_metric="logloss"
    )
except ImportError:
    pass  # xgboost is optional
```

**Model evaluation framework:**
```python
# greedybear/ml/evaluation.py

from sklearn.metrics import classification_report, roc_auc_score
from sklearn.model_selection import cross_val_score

def evaluate_model(model, X_test, y_test, model_name: str) -> dict:
    """Evaluate a trained model and return metrics."""
    y_pred = model.predict(X_test)
    y_prob = model.predict_proba(X_test)[:, 1]

    return {
        "model": model_name,
        "accuracy": (y_pred == y_test).mean(),
        "auc_roc": roc_auc_score(y_test, y_prob),
        "classification_report": classification_report(y_test, y_pred, output_dict=True),
    }

def compare_models(training_data, test_data) -> dict[str, dict]:
    """Train all models and return comparative metrics."""
    results = {}
    for name, model in MODEL_REGISTRY.items():
        model.fit(training_data["X"], training_data["y"])
        results[name] = evaluate_model(model, test_data["X"], test_data["y"], name)
    return results
```

### Deliverable 2: Training Pipeline Fixes (Weeks 7–8)

Fix issue #1087 — training_data validation:
```python
def validate_and_prepare_training_data(records: list[dict]) -> tuple[list, list]:
    """Validate training records and extract features/labels safely."""
    features, labels = [], []
    skipped = 0

    for record in records:
        try:
            feature_vector = extract_features(record)  # raises KeyError if missing fields
            label = record["label"]
            features.append(feature_vector)
            labels.append(label)
        except KeyError as e:
            logger.warning(f"Skipping record {record.get('id')}: missing field {e}")
            skipped += 1

    if skipped > 0:
        logger.info(f"Training: skipped {skipped}/{len(records)} records due to missing fields")

    return features, labels
```

### Deliverable 3: Feed System Improvements (Weeks 9–11)

Fix issue #1093 (sorting regression), implement issue #1092 (refactor):

```python
# greedybear/feeds/builders.py — new file, extracted from monolithic feed code

def build_feed_response(queryset, feed_type: str, format: str) -> dict:
    """
    Pure function: takes a queryset, returns a serialized feed response.
    Separated from feed flow logic for testability.
    """
    serialized = FeedSerializer(queryset, many=True).data
    return {
        "feed_type": feed_type,
        "format": format,
        "count": len(serialized),
        "results": serialized,
    }
```

**Pagination:**
```python
# greedybear/api/viewsets.py

from rest_framework.pagination import PageNumberPagination

class FeedPagination(PageNumberPagination):
    page_size = 100
    page_size_query_param = 'page_size'
    max_page_size = 1000

class FeedViewSet(viewsets.ModelViewSet):
    pagination_class = FeedPagination
    ordering_fields = ['created_at', 'ip', 'attack_count']
    ordering = ['-created_at']  # Restored ordering (fixes #1093)
```

### Deliverable 4: Cronjob Reliability (Week 12)

Fix issue #1085 and add monitoring:
```python
# greedybear/cronjobs/base.py

class BaseCronjob:
    def execute(self):
        start_time = time.time()
        try:
            self._execute()
            duration = time.time() - start_time
            logger.info(f"Cronjob {self.__class__.__name__} completed in {duration:.2f}s")
        except Exception as e:
            logger.exception(f"Cronjob {self.__class__.__name__} failed: {e}")
            raise  # Let Django-Q2 see the failure
```

### Deliverable 5: Test Coverage Improvement (Weeks 13–14)

- Add tests for all ML pipeline functions (target: 70%+ coverage on `greedybear/ml/`)
- Add tests for feed pagination and ordering
- Add tests for cronjob failure propagation
- Integration tests for the end-to-end feed generation pipeline

---

## Timeline

| Week | Milestone |
|------|-----------|
| 1–2 | Community bonding: audit existing tests, profile ML pipeline, align with mentors |
| 3–4 | Model registry implementation, XGBoost/GradientBoosting integration |
| 5–6 | Evaluation framework, model comparison tooling |
| 7–8 | Training pipeline validation (#1087), training data quality improvements |
| 9–10 | Feed system refactor (#1092), fix sorting regression (#1093) |
| 11 | Feed pagination, advanced filtering API parameters |
| 12 | Cronjob reliability (#1085), monitoring improvements |
| 13 | Test coverage expansion |
| 14 | Documentation, final PRs, cleanup |

---

## About Me

I'm a Python/Django developer with a background in security tools and ML systems.

**Relevant experience:**
- Merged PRs in prowler-cloud/prowler — cloud security Python, production Django patterns
- Merged PR in huggingface/transformers — large ML Python codebase
- scikit-learn, XGBoost, model evaluation: used extensively in personal projects (spectra — RAG evaluation toolkit)
- Django REST Framework: production-level experience (aegis — intelligence platform with 338 tests)
- Honeypot/threat intel domain: studying IoC formats, threat feed structures, and MISP integration for personal research

**Why GreedyBear:**
Threat intelligence is where open source matters most — defenders share data to counter attackers who share tools. GreedyBear's approach (aggregate honeypot data → actionable feeds) is the right architecture. I want to make the ML pipeline more reliable and extensible so the feeds improve over time.

---

## References

- [XGBoost documentation](https://xgboost.readthedocs.io/)
- [scikit-learn model evaluation](https://scikit-learn.org/stable/modules/model_evaluation.html)
- [GreedyBear issue #1085](https://github.com/intelowlproject/GreedyBear/issues/1085)
- [GreedyBear issue #1087](https://github.com/intelowlproject/GreedyBear/issues/1087)
- [GreedyBear issue #1092](https://github.com/intelowlproject/GreedyBear/issues/1092)
- [GreedyBear issue #1093](https://github.com/intelowlproject/GreedyBear/issues/1093)
