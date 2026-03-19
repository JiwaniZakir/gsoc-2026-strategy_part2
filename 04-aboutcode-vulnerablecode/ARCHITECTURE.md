# VulnerableCode Architecture

## High-Level Overview

VulnerableCode is a **Django-based vulnerability database** that aggregates data from multiple upstream sources (NVD, Debian, vendor advisories, etc.) through a sophisticated importer/pipeline framework, then exposes standardized, queryable vulnerability data via REST API.

### Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                        DATA SOURCES                              │
│  (NVD, Debian Advisories, GitHub, CVE, Vendor Feeds, Changelogs)│
└────────────────────────────┬────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│              IMPORTERS / DATA PIPELINES                          │
│   (aboutcode.pipeline framework, individual importer classes)   │
│  Examples: NVDImporter, DebianImporter, Check Point, Grafana    │
└────────────────────────────┬────────────────────────────────────┘
                             │
                    ┌────────▼────────┐
                    │ Data Validation │
                    │ & Enrichment    │
                    └────────┬────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│                   DJANGO ORM MODELS                              │
│ (Vulnerability, Package, Advisory, VulnerableRange, etc.)       │
│                    PostgreSQL Database                          │
└────────────────────────────┬────────────────────────────────────┘
                             │
                   ┌─────────┴──────────┐
                   ▼                    ▼
        ┌─────────────────┐   ┌──────────────────┐
        │  Redis Queue    │   │  Django Cache    │
        │   (RQ jobs)     │   │                  │
        └─────────────────┘   └──────────────────┘
                   │                    │
                   └─────────┬──────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│            DJANGO REST FRAMEWORK API LAYER                       │
│         (DRF Spectacular for OpenAPI/Swagger docs)              │
│     Endpoints: /api/v1/vulnerabilities, /api/v1/packages, etc.  │
└────────────────────────────┬────────────────────────────────────┘
                             │
                   ┌─────────┴───────────┐
                   ▼                     ▼
        ┌──────────────────┐   ┌──────────────────┐
        │   Web UI         │   │  External Tools  │
        │  (Dashboard)     │   │  (CI/CD, SCA)    │
        └──────────────────┘   └──────────────────┘
```

---

## Core Components

### 1. Django Framework Layer (`/vulnerablecode`)

**Purpose:** Web framework, routing, middleware, configuration.

**Contents:**
- `settings.py` — Database, installed apps, middleware, security settings
- `urls.py` — URL routing to views and API endpoints
- `wsgi.py` — WSGI application entry point
- `/static` — Static assets (CSS, JS, images)

**Key Settings:**
- Database: PostgreSQL with ORM via Django
- Cache: Redis (for performance and job queuing)
- Installed Apps: Django REST Framework, Spectacular, core vulnerability app
- Authentication: Token-based (suitable for API-first design)

---

### 2. Vulnerability Models (`/vulnerabilities`)

**Purpose:** Define the data structure and relationships for vulnerability information.

**Key Models:**

| Model | Purpose |
|-------|---------|
| **Vulnerability** | Core entity representing a unique vulnerability (CVE-like) |
| **Package** | Standardized package reference using PURL (Package URL) |
| **Advisory** | Upstream advisory source (e.g., "Debian Security Advisory DSA-5000") |
| **VulnerableRange** | Affected version ranges for a package in a vulnerability |
| **VulnerabilityReference** | CVE IDs, CWE, CVSS scores, severity ratings |
| **PackageRelatedVulnerability** | M2M relationship: which packages affected by which vulns |

**Design Pattern — PURL-First Approach:**
- All packages referenced via PURL (e.g., `pkg:npm/lodash@4.17.21`)
- Enables ecosystem-agnostic vulnerability matching
- Supports deduplication across sources

**Example Model Relationship:**
```python
class Vulnerability(models.Model):
    vulnerability_id = CharField(unique=True)  # e.g., "CVE-2021-44228"
    description = TextField()
    data_source = ForeignKey(DataSource)

class Package(models.Model):
    purl = CharField(unique=True)  # e.g., "pkg:npm/log4j@2.14.1"
    ecosystem = CharField()

class VulnerableRange(models.Model):
    vulnerability = ForeignKey(Vulnerability)
    package = ForeignKey(Package)
    affected_version_range = CharField()
    fixed_version = CharField()
```

---

### 3. Data Pipeline / Importer Framework (`/aboutcode/pipeline`)

**Purpose:** Orchestrate data import from upstream sources into Django models.

**Architecture:**
- **Base Classes:** Abstract importer class with standard interface
- **Plugin Pattern:** Each data source (NVD, Debian, vendor feeds) implements importer
- **Steps:** Fetch → Parse → Validate → Transform → Load (ETL)
- **Error Handling:** Graceful degradation, logging, retry logic
- **Idempotency:** Safe to re-run without duplication

**Importer Examples (in repo):**

1. **NVDImporter** — Pulls from NVD JSON feeds
   - Parses CVE records, extracts affected CPE ranges
   - Maps to PURL for cross-ecosystem consistency

2. **DebianImporter** — Debian Security Advisories
   - Parses Debian JSON feeds
   - Merges with existing CVE data

3. **Check Point Importer** — Vendor-specific
   - Reference implementation for custom vendor data

4. **Grafana Importer** — Product-specific advisories
   - Shows how to handle proprietary vulnerability formats

**Pipeline Execution:**
```python
# Typical importer workflow
class VendorImporter:
    def fetch_data(self):
        """Retrieve from upstream source"""

    def parse_advisory(self, raw_data):
        """Extract structured fields (CVE, affected packages, etc.)"""

    def validate(self, parsed_data):
        """Ensure data quality, check for required fields"""

    def transform_to_purl(self, package_info):
        """Convert vendor package format to PURL"""

    def load_to_db(self, validated_data):
        """Create/update Django models atomically"""
```

---

### 4. Vulnerability Aggregation (`/vulntotal`)

**Purpose:** Calculate aggregate statistics and relationships.

**Responsibilities:**
- Total vulnerabilities by ecosystem
- Vulnerability severity distribution
- Package vulnerability rollups
- Trend analysis

**Integration with Job Queue (RQ):**
```
Scheduled Job (RQ) → Trigger Aggregation → Update Totals Cache
```

---

### 5. Django REST API (`/vulnerablecode/api`)

**Framework:** Django REST Framework 3.15.2 with DRF Spectacular

**Documentation:** Auto-generated OpenAPI/Swagger specs

**Endpoints:**

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/api/v1/vulnerabilities` | GET | List vulnerabilities with filters |
| `/api/v1/vulnerabilities/<id>` | GET | Retrieve single vulnerability |
| `/api/v1/packages` | GET | Query packages by PURL |
| `/api/v1/packages/<purl>/vulnerabilities` | GET | Get vulns for specific package |
| `/api/v1/advisories` | GET | List advisories by source |

**Query Examples:**
```bash
# Get all vulnerabilities for a specific package
GET /api/v1/packages/pkg:npm/lodash/vulnerabilities?version=4.17.20

# Search vulnerabilities by severity
GET /api/v1/vulnerabilities?severity=critical

# Filter by data source
GET /api/v1/advisories?source=debian&limit=50
```

**Serializers (DRF):** Convert models to JSON with related data nesting

**Permissions:** Token authentication for programmatic access; optional rate limiting

---

## Technology Stack Details

### Database: PostgreSQL

**Why PostgreSQL:**
- JSONB support for flexible advisory metadata
- Full-text search for CVE descriptions
- Reliably handles large datasets (3,000+ commits of historical data)
- ACID compliance for data integrity

**Key Indexes:**
- Vulnerability ID (CVE), PURL, Data source
- Version range queries optimized for affected version lookups

### Job Queue: Redis + RQ

**Why Redis + RQ:**
- Asynchronous importer execution (NVD feeds are large)
- Scheduled jobs for periodic data refreshes
- Simple task monitoring without external infrastructure

**Jobs:**
```
fetch_nvd_data() → parse_nvd() → load_nvd_vulnerabilities()
fetch_debian_advisories() → update_debian_data()
```

### Testing: pytest + pytest-django

**Coverage Areas:**
- Model creation and relationships
- Importer logic (fetch, parse, transform)
- API endpoint responses and filtering
- Data validation rules

**Test Organization:**
```
tests/
├── test_models.py
├── test_importers/
│   ├── test_nvd_importer.py
│   ├── test_debian_importer.py
│   └── test_custom_importer.py
├── test_api/
│   ├── test_vulnerability_endpoints.py
│   └── test_package_endpoints.py
└── test_pipelines.py
```

### Code Quality: black, isort, mypy

**black (22.3.0)** — Opinionated code formatter
- Line length: 88 characters
- Consistent formatting across codebase

**isort (5.10.1)** — Import sorting
- Groups: standard library, third-party, local
- Prevents merge conflicts from import changes

**mypy** — Static type checking
- Catches None errors, type mismatches early
- Type hints required for public APIs

### Development Server

**Local:**
```bash
python manage.py runserver  # http://localhost:8000
```

**Docker (Recommended):**
```bash
docker-compose up
```

---

## Data Flow: Example (NVD Import)

```
1. TRIGGER: Daily scheduled job (RQ)
   └─> Call NVDImporter.run()

2. FETCH: Download NVD JSON feed (40MB+)
   └─> Store in tmp file, calculate hash

3. PARSE: Iterate CVE records
   └─> Extract: CVE ID, description, affected CPE, CVSS score

4. VALIDATE: Check data quality
   └─> Verify CVE format, reject incomplete records

5. TRANSFORM: Convert CPE to PURL
   └─> Example: "cpe:2.3:a:vendor:product:1.0:*:*:*:*:*:*:*"
              → "pkg:generic/vendor/product@1.0"

6. LOAD: Bulk create/update Django models (transactional)
   └─> Create Vulnerability record
   └─> Create/link Package records
   └─> Create VulnerableRange entries
   └─> Create VulnerabilityReference (CVE, CVSS, CWE)

7. AGGREGATE: Trigger vulntotal update
   └─> Update ecosystem vulnerability counts
   └─> Update cache (Redis)

8. DONE: Log completion, report stats
```

---

## Build & Deployment

### Local Build
```bash
pip install -r requirements.txt
python manage.py migrate                    # Apply DB migrations
python manage.py createsuperuser           # Create admin user
python manage.py runserver                 # Start dev server
```

### Docker Build
```bash
# Automatic via docker-compose
docker-compose up

# Includes:
# - PostgreSQL container
# - Redis container
# - Django app container
# - All migrations applied automatically
```

### Makefile Targets
```bash
make install                # Install dependencies
make migrate                # Apply migrations
make test                   # Run pytest
make format                 # Black + isort formatting
make lint                   # mypy type checking
make docs                   # Build Sphinx docs
make docker-build          # Build Docker images
```

---

## Extension Points (for GSoC NLP/ML Project)

### 1. New Importer Pattern
```python
# /aboutcode/importers/nlp_unstructured_importer.py
class UnstructuredDataImporter(BaseImporter):
    """Pipeline for mailing lists, changelogs, bug trackers"""

    def fetch_data(self):
        # Retrieve unstructured text from sources

    def nlp_extract(self, text):
        # Use NLP to identify vulnerability mentions
        # Return: [(package_name, version, severity, source_url)]

    def load_to_db(self, extracted_data):
        # Standard pipeline to create models
```

### 2. New Data Source
```python
# Add to /vulnerabilities/models.py
class DataSource(models.Model):
    identifier = CharField()  # "nlp-mailing-lists"
    label = CharField()       # "Extracted from Mailing Lists"
    importer_class = CharField()  # Reference NLP importer
```

### 3. New API Endpoint
```python
# /vulnerablecode/api/views.py
class ConfidenceScoreViewSet(viewsets.ViewSet):
    """Return confidence score for NLP-extracted vulnerabilities"""
    # Surfaces ML model predictions alongside traditional data
```

---

## Key Design Principles

1. **PURL-First** — All packages normalized to PURL format
2. **Importer Pattern** — Extensible, pluggable data sources
3. **Idempotent** — Safe to re-run imports without data corruption
4. **API-Centric** — REST API is primary interface
5. **Quality Over Quantity** — Data validation before storage
6. **Open Source** — Transparent, community-driven improvements

---

## Summary

VulnerableCode's architecture balances **data ingestion** (complex, multi-source importers) with **data exposure** (clean REST API) through a robust Django-based foundation. The importer framework is specifically designed for extension, making it ideal for adding NLP/ML capabilities to extract vulnerability information from unstructured sources like changelogs, mailing lists, and bug trackers.
