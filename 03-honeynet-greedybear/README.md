# GreedyBear GSoC 2026 Strategy

## Organization: The Honeynet Project

**Website:** https://www.honeynet.org
**GSoC Page:** https://www.honeynet.org/gsoc/gsoc-2026/
**Communication:** Discord (preferred), email: project@honeynet.org, GitHub Issues

### About The Honeynet Project

The Honeynet Project is an international cybersecurity organization dedicated to advancing honeypot technology and malware research. The project serves as a trusted resource for security researchers, forensics professionals, and incident responders by collecting, analyzing, and sharing intelligence on cyber threats and attacks.

---

## Project: GreedyBear (IntelOWL Project)

**Repository:** github.com/intelowlproject/GreedyBear
**License:** AGPL-3.0
**Latest Release:** 3.2.0 (Feb 26, 2026)
**Contributors:** 29 active contributors
**Merged PRs:** 432
**Closed Issues:** 766

### Project Overview

GreedyBear is the intelligence extraction and aggregation platform for the IntelOWL ecosystem. It processes event data from honeypots (particularly T-Pot infrastructure), extracts actionable intelligence, and exposes it through a comprehensive REST API and React-based frontend dashboard.

**Mission:** Enable security teams to consume honeypot intelligence programmatically and visually, accelerating threat detection and response.

**Key Capabilities:**
- Ingest data from distributed honeypots via T-Pot integration
- Extract and normalize intelligence (IPs, domains, hashes, attack patterns)
- Store and search via PostgreSQL and Elasticsearch
- Serve intelligence via REST API (DRF)
- Dashboard visualization (React frontend)
- Support for external data injection (GSoC focus)

---

## GSoC 2026 Project: Injection/Event Collector API

**Difficulty:** 175-350 hours (medium-large project)
**Project Type:** Backend feature development with API design

### Project Goal

Build a secure, scalable **Event Collector API** that allows authenticated external applications (other honeypot managers, security tools, threat intel platforms) to programmatically inject standardized event data into GreedyBear. This enables GreedyBear to become a central intelligence hub for heterogeneous threat sources.

**Key Requirements:**
- Design and implement REST endpoint(s) for event ingestion
- Implement token-based authentication and rate limiting
- Validate event schema using Django REST Framework serializers
- Write comprehensive test coverage
- Document API (OpenAPI/Swagger)
- Ensure backward compatibility with existing APIs

---

## Mentors

- **Tim Leonhard** - Frontend lead, UI/UX expertise. Contact on Discord.
- **Matteo Lodi** - Project creator, backend architecture, Django expert. Contact on Discord.

**Contact:** Discord (preferred), GitHub Issues, project@honeynet.org

---

## Technology Stack

**Language Distribution:**
- Python: 72.6% (backend, Django)
- JavaScript: 20.2% (React frontend)
- Shell: 6% (Docker, DevOps)

### Backend Stack
- **Framework:** Django 5.x, Django REST Framework (DRF)
- **Task Queue:** Django Q2 (recently migrated from Celery)
- **Database:** PostgreSQL (primary data store)
- **Search Engine:** Elasticsearch (full-text search, analytics)
- **Server:** uWSGI, Nginx (reverse proxy)
- **Containerization:** Docker, Docker Compose

### Frontend Stack
- **Framework:** React 18.x+
- **Build Tool:** Vite 7.3.1+
- **UI Library:** Certego-UI (Honeynet's custom component library)
- **State Management:** React Hooks / Context API
- **Styling:** CSS-in-JS or Tailwind (check codebase)

### Infrastructure
- **Container Orchestration:** Docker Compose
- **Web Server:** Nginx (reverse proxy, static files)
- **Application Server:** uWSGI (Django)
- **Search Infrastructure:** Elasticsearch (distributed search/analytics)
- **Local Development:** Docker with `gbctl` CLI tool

---

## Code Quality & Development Practices

### Code Style
- **Linter & Formatter:** Ruff (all-in-one tool replacing black, isort, flake8)
- **Command:** `ruff check . --fix && ruff format .`
- **Rules:** 100+ linting rules, strict formatting

### Pre-Commit Hooks
- **Installation:** `pre-commit install -c .github/.pre-commit-config.yaml`
- **Purpose:** Enforce code quality before commits
- **Mandatory:** Part of onboarding workflow

### Git Workflow
- **Base Branch:** Always branch from `develop` (NOT main)
- **Commit Strategy:** Squash commits into single logical commit before PR
- **PR Target:** Always to `develop` branch
- **Updates:** Pull latest develop changes before submitting

### Testing Requirements
- **Backend:** `docker exec greedybear_uwsgi python3 manage.py test`
- **Frontend:** `npm test` from `frontend/` directory
- **Coverage:** Aim for >80% on new code
- **PR Expectation:** All tests must pass in CI/CD

---

## Repository Structure

```
/greedybear/                 # Main Django app
  /api/                      # REST endpoints (core for GSoC)
    /views.py               # DRF ViewSets
    /serializers.py         # Data validation & serialization
    /urls.py                # URL routing
  /authentication/           # Auth models, tokens, permissions
  /configuration/            # Settings, feature flags
  /cronjobs/                 # Scheduled tasks (Django Q2)
  /management/               # Management commands
  /tests/                    # Comprehensive test suite
  /migrations/               # Database migrations
/frontend/                    # React + Vite application
  /src/                      # React components, pages, hooks
  /public/                   # Static assets
  /package.json
/docker/                      # Docker configuration
/requirements/                # Python dependencies
.pre-commit-config.yaml      # Pre-commit hook configuration
gbctl                        # Dev CLI tool
docker-compose.yml
Dockerfile
manage.py
```

---

## Open Issues (Priority Order for GSoC)

| Issue | Title | Difficulty | Relevance |
|-------|-------|-----------|-----------|
| #1070 | GeneralHoneypot refactor | Medium | Core infrastructure |
| #1089 | Feeds filter enhancement | Low | API feature |
| #1087 | Training data export | Medium | Data handling |
| #1085 | Cronjob exception handling | Medium | Reliability |
| #1083 | None session_id handling | Low | Bug fix |
| #1073 | N+1 query optimization | High | Performance |
| #1072 | Zombie sessions cleanup | Medium | Infrastructure |
| #1071 | Trending attackers feature | Medium | Analytics |

---

## Recent Development Activity

**Recent PRs (merged):**
- #882: Dependency upgrades (latest libraries)
- #856: Health endpoint (monitoring)
- #846: Password change endpoint (auth)
- #789: Django Q2 migration (from Celery)

**Development Focus:** Infrastructure improvements, migration work, API robustness

---

## Communication Channels

1. **Discord** (PREFERRED)
   - Real-time communication
   - Immediate feedback from mentors
   - Community support
   - Channel: See GSoC 2026 section

2. **GitHub**
   - Issue discussion
   - PR reviews
   - Code-based communication
   - Formal documentation

3. **Email**
   - project@honeynet.org
   - For formal inquiries
   - Less immediate than Discord

---

## Key Dates & Important Notes

- **Latest Release:** 3.2.0 (Feb 26, 2026) — current stable version
- **Active Development:** ongoing on `develop` branch
- **GSoC Timeline:** Typically May-August (check official GSoC dates)
- **Critical Rule:** Get assignment from maintainers BEFORE starting work (auto-unassigned after 1 week if no PR draft)

---

## Next Steps for GSoC Applicants

1. **Join Discord** - Introduce yourself to mentors
2. **Clone & Install** - Run `./gbctl init --dev --elastic-local`
3. **Explore Codebase** - Understand project structure and architecture
4. **Read Docs** - Study CONTRIBUTING.md, ARCHITECTURE.md thoroughly
5. **Start Small** - Get assigned to a beginner-friendly issue first
6. **Propose Project** - Draft Event Collector API proposal
7. **Build Proposal** - Technical approach, timeline, deliverables
8. **Submit Application** - Via Google Summer of Code platform

---

## Resources

- **GitHub:** https://github.com/intelowlproject/GreedyBear
- **Documentation:** In-repo `/docs` directory
- **Issues:** https://github.com/intelowlproject/GreedyBear/issues
- **Discussions:** GitHub Discussions + Discord
- **Honeynet Wiki:** https://www.honeynet.org/

---

**Document Created:** March 18, 2026
**Strategy Version:** 1.0
