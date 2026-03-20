# IntelOwl — Codebase Architecture

**GitHub:** https://github.com/intelowlproject/IntelOwl
**Stack:** Python 3.11, Django 4.x, Celery, PostgreSQL, React

---

## Repository Structure

```
IntelOwl/
├── api_app/                    # Core Django app
│   ├── analyzers_manager/      # 200+ analyzer definitions
│   │   ├── observable_analyzers/   # IP, domain, URL, hash analyzers
│   │   └── file_analyzers/         # File/binary analyzers
│   ├── connectors_manager/     # External platform integrations
│   ├── playbooks_manager/      # Playbook orchestration
│   ├── pivots_manager/         # Pivot between IOC types
│   ├── models.py               # Core data models (Job, Report, etc.)
│   ├── serializers.py          # DRF serializers
│   └── views.py                # DRF viewsets
├── intel_owl/
│   ├── settings.py             # Django settings
│   ├── celery.py               # Celery configuration
│   └── urls.py                 # URL routing
├── frontend/                   # React app
│   └── src/
│       ├── components/         # Reusable UI components
│       └── views/              # Page views
├── docker/                     # Docker configuration
├── tests/                      # pytest test suite
└── docs/                       # Sphinx documentation
```

---

## Key Data Models

```python
# api_app/models.py (simplified)

class Job(models.Model):
    """A threat intelligence analysis job."""
    status = models.CharField(choices=Status.choices)
    observable_name = models.CharField(max_length=512)
    observable_classification = models.CharField(choices=ObservableClassification.choices)
    md5 = models.CharField(max_length=32)
    analyzers_requested = models.ManyToManyField("AnalyzerConfig")
    received_request_time = models.DateTimeField(auto_now_add=True)

class Report(models.Model):
    """Output of a single analyzer run."""
    job = models.ForeignKey(Job, on_delete=models.CASCADE)
    report = models.JSONField(default=dict)
    status = models.CharField(choices=Status.choices)
    name = models.CharField(max_length=128)  # Analyzer name
    start_time = models.DateTimeField(auto_now_add=True)
    end_time = models.DateTimeField(null=True)
```

---

## Analyzer Architecture

Each analyzer extends `BaseAnalyzer`:

```python
# api_app/analyzers_manager/classes.py

class BaseAnalyzer(ABC):
    def run(self) -> dict:
        """Execute the analyzer, return JSON-serializable results."""
        raise NotImplementedError

    def _run(self):
        self.report.report = self.run()
        self.report.save()
```

Analyzers are registered via Django's database (not hardcoded):
```python
# Adding a new analyzer: create a migration + AnalyzerConfig entry
AnalyzerConfig.objects.create(
    name="MyAnalyzer",
    python_module="my_module.MyAnalyzerClass",
    type=AnalyzerConfig.Type.OBSERVABLE,
    observable_supported=[ObservableClassification.IP],
)
```

---

## LLM Chatbot Integration Points

**Where the new chatbot module fits:**

```
IntelOwl/
├── api_app/
│   └── llm/                    # NEW — LLM chatbot module
│       ├── __init__.py
│       ├── chatbot.py          # LangChain agent
│       ├── rag.py              # RAG pipeline (FAISS + docs)
│       ├── tools.py            # LangChain tools wrapping IntelOwl API
│       └── views.py            # Streaming endpoint
├── frontend/src/
│   └── components/
│       └── Chatbot/            # NEW — React chatbot widget
│           ├── Chatbot.jsx
│           └── ChatMessage.jsx
```

**LangChain tools for IntelOwl API:**
```python
# api_app/llm/tools.py

from langchain_core.tools import tool

@tool
def analyze_observable(observable: str, analyzers: list[str]) -> dict:
    """Run IntelOwl analyzers on an observable (IP, domain, hash, URL)."""
    # Call IntelOwl's REST API
    response = requests.post(
        f"{settings.INTELOWL_URL}/api/analyze_observable",
        json={"observable_name": observable, "analyzers_requested": analyzers},
        headers={"Authorization": f"Token {settings.INTELOWL_API_KEY}"},
    )
    return response.json()

@tool
def get_job_report(job_id: int) -> dict:
    """Retrieve the full report for a completed analysis job."""
    response = requests.get(
        f"{settings.INTELOWL_URL}/api/jobs/{job_id}",
        headers={"Authorization": f"Token {settings.INTELOWL_API_KEY}"},
    )
    return response.json()
```

---

## Build & Test Commands

```bash
# Start all services
docker compose -f docker/docker-compose.yml up -d

# Run full test suite
pytest tests/ -v --tb=short

# Run specific test file
pytest tests/analyzers/test_ip_analyzers.py -v

# Ruff (MANDATORY before every PR)
ruff check .
ruff format .

# Django management
python manage.py migrate
python manage.py shell
python manage.py test

# Celery worker (for async analyzer tasks)
celery -A intel_owl worker -l INFO
```

---

## CI Pipeline

GitHub Actions runs on every PR:
1. `ruff check` — linting (MUST PASS)
2. `pytest` — full test suite
3. `docker compose` build test
4. CodeQL security scan

**A PR with failing CI will not be reviewed.**

---

## Key Maintainers & Reviewer Patterns

| Person | GitHub | Review focus |
|--------|--------|-------------|
| Matteo Lodi | @mattebit | All components, architectural decisions |
| Eshaan Bansal | @eshaan7 | Backend, analyzers |
| Shubham Pandey | @sp35 | Backend, integrations |

**Typical review timeline:** 2–5 days for small PRs. Ping on Slack if no response in 7 days.
