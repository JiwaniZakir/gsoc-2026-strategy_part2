# GreedyBear — Codebase Architecture

**Repo:** https://github.com/intelowlproject/GreedyBear
**Language:** Python 3.10+, Django, React.js
**DB:** PostgreSQL
**Deployment:** Docker + docker-compose

---

## Directory Structure

```
GreedyBear/
├── greedybear/
│   ├── __init__.py
│   ├── settings/               # Django settings
│   │   ├── base.py
│   │   ├── development.py
│   │   └── production.py
│   ├── urls.py                 # Top-level URL routing
│   ├── models/                 # Django ORM models
│   │   ├── __init__.py
│   │   ├── feed.py             # IOC, Feed models
│   │   ├── sensor.py           # Honeypot sensor models
│   │   └── stats.py            # Statistics models
│   ├── api/                    # Django REST Framework
│   │   ├── viewsets/           # DRF viewsets
│   │   │   ├── feed.py         # Feed API
│   │   │   └── stats.py        # Stats API
│   │   ├── serializers/        # DRF serializers
│   │   └── urls.py
│   ├── cronjobs/               # Scheduled tasks (Django-Q2)
│   │   ├── base.py             # Base cronjob class
│   │   ├── feed_generation.py  # Generate threat feeds
│   │   ├── data_collection.py  # Collect from honeypots
│   │   └── ml_training.py      # Train ML models
│   ├── feeds/                  # Feed generation logic
│   │   ├── builders.py         # Feed response builders
│   │   └── formats.py          # JSON, CSV, etc.
│   ├── ml/                     # Machine learning
│   │   ├── training.py         # Model training
│   │   ├── prediction.py       # Model inference
│   │   ├── features.py         # Feature extraction
│   │   └── models/             # Saved model files (.pkl)
│   └── management/
│       └── commands/           # Django management commands
├── frontend/                   # React.js frontend
│   ├── src/
│   │   ├── components/
│   │   │   ├── Feeds/          # Feed display components
│   │   │   └── Stats/          # Statistics display
│   │   ├── pages/
│   │   └── App.js
│   └── package.json
├── tests/                      # pytest tests
│   ├── test_feeds.py
│   ├── test_cronjobs.py
│   ├── test_ml.py
│   └── test_api.py
├── docker/
│   ├── Dockerfile
│   └── docker-compose.yml
├── requirements/
│   ├── base.txt
│   ├── development.txt
│   └── production.txt
├── ruff.toml                   # MANDATORY linting config
├── pyproject.toml
└── .github/
    └── workflows/
        ├── test.yml
        └── lint.yml            # ruff check — fails PR if violated
```

---

## Key Django Models

```python
# greedybear/models/feed.py (approximate structure)

class IOC(models.Model):
    """Indicator of Compromise — an IP address seen in honeypot traffic."""
    ip = models.GenericIPAddressField(unique=True)
    attack_count = models.IntegerField(default=0)
    first_seen = models.DateTimeField()
    last_seen = models.DateTimeField()
    is_malicious = models.BooleanField(null=True)  # ML prediction
    malicious_confidence = models.FloatField(null=True)  # Prediction confidence

    class Meta:
        ordering = ['-last_seen']

class Feed(models.Model):
    """A generated threat feed snapshot."""
    feed_type = models.CharField(max_length=50)  # e.g., "log4j", "cowrie"
    created_at = models.DateTimeField(auto_now_add=True)
    ioc_count = models.IntegerField()
```

---

## ML Pipeline

```python
# greedybear/ml/training.py (approximate)

from sklearn.ensemble import RandomForestClassifier
import joblib
import logging

logger = logging.getLogger(__name__)

def train_classifier(training_data: list[dict]) -> RandomForestClassifier:
    """Train the IOC maliciousness classifier."""
    features, labels = [], []
    for record in training_data:
        features.append([
            record["attack_count"],
            record["unique_ports"],
            record["days_active"],
            # ... other numeric features
        ])
        labels.append(1 if record["confirmed_malicious"] else 0)

    model = RandomForestClassifier(n_estimators=100, random_state=42)
    model.fit(features, labels)
    return model

def save_model(model, path="greedybear/ml/models/classifier.pkl"):
    joblib.dump(model, path)

def load_model(path="greedybear/ml/models/classifier.pkl"):
    return joblib.load(path)

def predict_malicious(ioc_data: dict) -> tuple[bool, float]:
    model = load_model()
    features = [[
        ioc_data["attack_count"],
        ioc_data["unique_ports"],
        ioc_data["days_active"],
    ]]
    prediction = model.predict(features)[0]
    confidence = model.predict_proba(features)[0][1]
    return bool(prediction), float(confidence)
```

---

## Django REST Framework API

```python
# greedybear/api/viewsets/feed.py

from rest_framework import viewsets, filters
from rest_framework.pagination import PageNumberPagination
from greedybear.models.feed import IOC

class IOCViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = IOC.objects.all()
    serializer_class = IOCSerializer
    filter_backends = [filters.OrderingFilter]
    ordering_fields = ['last_seen', 'attack_count', 'ip']
    ordering = ['-last_seen']
    pagination_class = FeedPagination  # currently missing — needs adding
```

---

## Build and Test Commands

```bash
# Docker setup (recommended)
cp .env.example .env
docker compose up -d
docker compose exec django python manage.py migrate
docker compose exec django python manage.py createsuperuser

# Run tests in Docker
docker compose exec django pytest tests/ -v

# Local development
pip install -r requirements/development.txt
python manage.py migrate
python manage.py runserver 0.0.0.0:8000

# Run tests locally
pytest tests/ -v -q

# MANDATORY linting (runs in CI — must pass)
ruff check .
ruff format .

# Check specific file
ruff check greedybear/ml/training.py

# Frontend
cd frontend
npm install
npm run dev
npm run build
```

---

## Ruff Configuration

GreedyBear uses a strict Ruff config. Key rules:
- No unused imports
- No unused variables
- f-strings required (no % or .format())
- Line length: 120 chars
- No bare `except` clauses

Check `ruff.toml` in the root for the full config.

---

## Django-Q2 (Task Queue)

Scheduled tasks (cronjobs) are managed with Django-Q2:

```python
# Cronjob registration in settings/base.py:
Q_CLUSTER = {
    'name': 'GreedyBear',
    'workers': 4,
    'recycle': 500,
    'timeout': 300,
    'compress': True,
    'save_limit': 250,
    'queue_limit': 500,
    'cpu_affinity': 1,
    'label': 'Django Q',
    'redis': {...},
}
```

Run the cluster: `python manage.py qcluster`

---

## Where to Start Contributing

| Goal | File to Read First |
|------|--------------------|
| Fix ML training bug | `greedybear/ml/training.py` |
| Fix feed sorting | `greedybear/api/viewsets/feed.py` |
| Fix cronjob exceptions | `greedybear/cronjobs/base.py` |
| Add new honeypot source | `greedybear/cronjobs/data_collection.py` |
| Frontend feed filter | `frontend/src/components/Feeds/` |
| New DRF endpoint | `greedybear/api/viewsets/` + `greedybear/api/urls.py` |
