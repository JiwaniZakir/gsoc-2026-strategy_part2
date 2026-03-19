# AboutCode VulnerableCode - GSoC 2026 Project

## Organization Overview

**AboutCode** (nexB Inc / AboutCode ASBL) maintains a free, open-source vulnerability database that powers security research, compliance, and risk management globally. The project is built on a PURL-first (Package URL) approach, ensuring standardized package identification across ecosystems.

### Key Stats
- **Repository:** github.com/aboutcode-org/vulnerablecode
- **Stars:** 650 | **Forks:** 291 | **Commits:** 3,068
- **License:** Apache 2.0
- **Current Version:** v37.0.0
- **Open Issues:** 664 (24 tagged GSoC)
- **Funders:** NLnet, European Commission, Google, Mercedes-Benz, Microsoft

---

## GSoC 2026 Project: NLP/ML for Vulnerability Detection

### Project Vision
Extract actionable vulnerability information from unstructured data sources (mailing lists, changelogs, bug tracker comments, CVE descriptions, GitHub issues) using Natural Language Processing and Machine Learning.

### Why This Matters
Current vulnerability data collection relies heavily on structured feeds (NVD, Debian advisories, vendor advisories). Unstructured sources contain critical information that goes unprocessed:
- Security mailing list discussions
- Package changelog entries
- Bug tracker comments mentioning vulnerabilities
- CVE description text requiring intelligent parsing
- GitHub issues with security implications

### Project Scope
Design and implement an NLP/ML pipeline that:
1. Ingests unstructured text from multiple sources
2. Identifies vulnerability-related content
3. Extracts structured data (CVE ID, affected packages, severity, fix version)
4. Integrates seamlessly with existing importer framework
5. Reduces manual data entry overhead

---

## Technology Stack

| Component | Technology | Version |
|-----------|-----------|---------|
| **Framework** | Django | 5.2.11 |
| **API** | Django REST Framework | 3.15.2 |
| **Database** | PostgreSQL | (latest supported) |
| **Job Queue** | Redis + RQ | (latest) |
| **Testing** | pytest + pytest-django | (latest) |
| **Code Quality** | black, isort, mypy | 22.3.0, 5.10.1, (latest) |
| **API Docs** | DRF Spectacular | (OpenAPI/Swagger) |
| **Language** | Python | 3.8+ |

### Key Dependencies
- **PackageURL (purl)** — standardized package identification
- **FetchCode** — intelligent data fetching
- **BeautifulSoup4** — HTML parsing
- **GitPython** — repository interaction
- **lxml** — XML processing
- **PyYAML** — configuration
- **CWE2** — Common Weakness Enumeration mappings

---

## Development Setup

### Prerequisites
- Python 3.8+
- PostgreSQL (9.6+)
- Docker & Docker Compose (optional, recommended)

### Local Installation
```bash
git clone https://github.com/aboutcode-org/vulnerablecode.git
cd vulnerablecode
pip install -r requirements.txt
python manage.py migrate
python manage.py runserver
```

### Docker Setup
```bash
docker-compose up
```

### Testing & Code Quality
```bash
pytest                          # Run tests
black . --check                 # Check formatting
isort . --check-only           # Check import ordering
mypy vulnerablecode/           # Type checking
```

---

## Codebase Structure

```
vulnerablecode/
├── vulnerablecode/           # Main Django app (settings, urls, wsgi, static)
├── vulnerabilities/          # Vulnerability models and logic
├── vulntotal/               # Vulnerability aggregation/totals
├── aboutcode/               # Shared utilities
├── docs/                    # Sphinx documentation
├── etc/                     # Configuration files
├── requirements.txt         # Python dependencies
├── setup.py                 # Package setup
├── pyproject.toml          # Build configuration
├── docker-compose.yml      # Docker orchestration
├── Dockerfile              # Container definition
├── Makefile                # Build automation
└── README.rst              # Official README
```

### Critical Directories

**`/vulnerablecode`** — Django app containing settings, URL routing, WSGI configuration, and static assets. This is the core framework layer.

**`/vulnerabilities`** — Contains the vulnerability data models (Vulnerability, Package, Advisory, etc.) and business logic for vulnerability management.

**`/aboutcode`** — Utility functions and importers. The `pipeline` framework for data import orchestration lives here.

---

## Communication & Community

### Primary Channels
- **Gitter Chat:** gitter.im/aboutcode-org/vulnerablecode (real-time discussion)
- **Slack:** (team-specific, ask for invite)
- **GitHub Issues:** Feature requests, bug reports, GSoC discussions
- **Weekly Meetings:** Community standups (details upon joining)

### Documentation
- **Official Docs:** vulnerablecode.readthedocs.org
- **Contributing Guide:** CONTRIBUTING.rst in repo
- **API Docs:** Auto-generated via DRF Spectacular (Swagger/OpenAPI)

---

## Project Mentors

### Primary Mentors
- **Pombredanne** — Founder, extremely active maintainer. Deep expertise in vulnerability data models and open-source governance.
- **Keshav-space** — Active contributor with importer experience.

### Expectations
- Weekly async communication via Gitter or GitHub
- Bi-weekly video syncs with mentors
- Active engagement with GSoC-tagged issues
- Open to design discussions and architecture feedback

---

## Contributing

### Process Overview
1. **Sign DCO** (Developer Certificate of Origin) — required for all commits
2. **Read README & CONTRIBUTING.rst** — understand project values
3. **Review existing issues** — avoid duplicate work
4. **Start with documentation or simple fixes** — build familiarity
5. **Code style:** Follow black, isort, mypy requirements
6. **Testing:** All PRs must pass pytest suite

### Multiple Contribution Paths
- **Code** — Bug fixes, new features, refactoring
- **Data** — New vulnerability importers
- **Documentation** — Docs improvements, tutorials, examples

---

## Key Resources

- **Issue #251 (NLP/ML Epic):** "Process unstructured data sources, such as issues" — core GSoC challenge
- **Recent Importers:** Check Point, CloudVulnDB, Eclipse, Grafana — reference implementations
- **API v1 Endpoints:** Comprehensive REST API for vulnerability queries and package lookups
- **Scanner Integration:** Rules-based scanning capabilities for integration with CI/CD pipelines

---

## Next Steps for GSoC Applicants

1. **Join Gitter** and introduce yourself
2. **Review the 24 GSoC-tagged issues** to understand project scope
3. **Set up local development environment** using Docker
4. **Read vulnerablecode.readthedocs.org** to understand data models
5. **Start with a small documentation PR** to get familiar with DCO and CI/CD
6. **Engage with mentors** early on architecture and approach
7. **Propose your NLP/ML approach** — be specific about technical choices

---

## License & Values

**Apache 2.0** — Permissive open-source license allowing wide adoption and commercial use.

**Core Values:**
- Transparency in vulnerability data
- Community-driven development
- Rigorous data quality standards
- Integration-friendly design
- Accessible to security professionals globally
