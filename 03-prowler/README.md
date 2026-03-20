# Project #3: prowler-cloud/prowler

**Score: 53.16 | Merge Rate: 62.5% | External PRs: 16 | Rank: #3**

## Organization Overview

**Prowler** is an open-source cloud security posture management (CSPM) tool that performs security audits across AWS, Azure, GCP, and Kubernetes. It's one of the most active security open-source projects, used by enterprises and security teams globally.

- **GitHub:** https://github.com/prowler-cloud/prowler
- **Stars:** ~11,000+
- **Language:** Python 3.9+
- **GSoC:** Confirmed (standalone org)
- **GSoC Ideas:** Check prowler-cloud GitHub org for 2026 ideas

## Why Prowler is #3

- **Zakir already has MERGED PRs here** — this is the strongest possible signal. The core team knows his name, has seen his code, and has already approved his work.
- 62.5% merge rate is lower than #1/#2 but still solid, and Zakir's existing relationship gives him an advantage over new contributors.
- 16 external PRs — competitive but manageable.
- Python/cloud security aligns perfectly with Zakir's skills.

## GSoC Project Ideas

| Idea | Difficulty | Fit |
|------|-----------|-----|
| New provider checks (GitHub, Azure CAE, GCP DNS logging) | Medium | Excellent — multiple open issues |
| Redis/ElastiCache SSL support (env var config) | Medium | Good — issue #8832 |
| Compliance framework extension | Hard | Good — adds business value |
| New cloud provider integration | Hard | Ambitious |
| Prowler API / dashboard improvements | Medium | Good for full-stack |

## Tech Stack

| Component | Technology |
|-----------|-----------|
| Core | Python 3.9+, boto3, azure-sdk, google-cloud |
| Checks | Python modules in `prowler/providers/<provider>/services/<service>/checks/` |
| Tests | pytest, moto (AWS mocking), unittest.mock |
| CI | GitHub Actions |
| Linting | Ruff, Black |
| Output formats | JSON, CSV, HTML, OCSF |
| API | FastAPI, SQLAlchemy |

## Key Modules

| Module | Purpose |
|--------|---------|
| `prowler/providers/` | Per-provider implementations (aws/, azure/, gcp/, kubernetes/) |
| `prowler/providers/<p>/services/<svc>/` | Service-level clients and checks |
| `prowler/providers/<p>/services/<svc>/checks/` | Individual security checks |
| `prowler/lib/` | Core library — scanning, outputs, compliance |
| `tests/providers/` | Tests mirroring the providers structure |

## Open Issues (Target)

| # | Title | Strategy |
|---|-------|---------|
| [#10148](https://github.com/prowler-cloud/prowler/issues/10148) | New Azure Check: Continuous Access Evaluation | Implement new Azure check |
| [#8832](https://github.com/prowler-cloud/prowler/issues/8832) | Redis connection scheme via env var | Config improvement |
| [#8660](https://github.com/prowler-cloud/prowler/issues/8660) | GitHub check: dismiss stale reviews | New GitHub provider check |
| [#7287](https://github.com/prowler-cloud/prowler/issues/7287) | GCP Check: Cloud DNS logging | New GCP check |
| [#7630](https://github.com/prowler-cloud/prowler/issues/7630) | Missing Kubernetes workload checks in docs | Docs + fix |

## Mentors

- Check prowler-cloud GitHub org for GSoC 2026 mentor list
- Core team: pumasecurity, jfuentesmontes, pawlaczyk

## Communication Channels

| Channel | Link | Purpose |
|---------|------|---------|
| GitHub Issues | https://github.com/prowler-cloud/prowler/issues | Contribution work |
| Slack | prowler-cloud.slack.com | Community, mentors |
| GitHub Discussions | https://github.com/prowler-cloud/prowler/discussions | GSoC discussion |

## Zakir's Edge

1. **Already merged PRs** — biggest possible advantage. Use this explicitly in your intro post.
2. Cloud security + Python expertise is exactly what prowler needs for new checks.
3. Can write a check for any AWS/Azure/GCP service using the existing pattern.
4. Demonstrated ability to work within prowler's strict code style (Ruff, tests, OCSF output).

---
*Priority: #3 — Merged PRs here is the single biggest differentiator in the entire field*
