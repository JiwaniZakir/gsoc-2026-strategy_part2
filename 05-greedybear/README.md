# Project #5: honeynet/GreedyBear

**Score: 49.72 | Rank: #5**

## Organization Overview

**GreedyBear** is a threat intelligence platform developed under the **Honeynet Project** that aggregates and analyzes data from honeypot networks (T-Pot, etc.) to produce actionable threat feeds. It operates under the **intelowlproject** GitHub org.

- **GitHub:** https://github.com/intelowlproject/GreedyBear
- **Honeynet GSoC:** https://www.honeynet.org/gsoc/ (confirmed umbrella org)
- **Stars:** ~350
- **Language:** Python, Django, REST API
- **Related project:** IntelOwl (also under Honeynet) — larger, more activity

## Why GreedyBear is #5

- Cybersecurity + Python/Django is a strong fit for Zakir's skill set
- Honeynet Project is a well-established GSoC org with experienced mentors
- Small enough that contributions are visible — not lost in noise
- Open issues are actionable (bugs, ML improvements, feed system enhancements)
- **IntelOwl** is also under Honeynet — if GreedyBear is quiet, contribute there too

## ⚠️ Key Rules for GreedyBear

1. **Ruff linting is MANDATORY** — every PR must pass `ruff check`. Zero tolerance.
2. **1-week PR review deadline** — if no review in 7 days, ping the reviewer
3. **Related to IntelOwl** — check if your contribution should be in GreedyBear OR IntelOwl
4. **Active maintainer:** mattebit (Matteo Lodi) — very responsive on GitHub

## GSoC Project Ideas (Honeynet Track)

| Idea | Difficulty | Fit |
|------|-----------|-----|
| ML model improvements (better threat classification) | Medium | Good |
| New honeypot integrations (beyond T-Pot) | Medium | Good |
| Feed system improvements (pagination, filtering) | Medium | Good |
| IntelOwl integration enhancements | Medium | Good |
| Frontend (React) improvements | Medium | Partial |

## Tech Stack

| Component | Technology |
|-----------|-----------|
| Backend | Python, Django, Django REST Framework |
| Task queue | Django-Q2 |
| Database | PostgreSQL |
| ML models | scikit-learn (Random Forest) |
| Frontend | React.js |
| Threat feeds | JSON, CSV feeds |
| CI | GitHub Actions |
| Linting | Ruff (MANDATORY) |
| Deployment | Docker, docker-compose |

## Key Modules

| Module | Purpose |
|--------|---------|
| `greedybear/cronjobs/` | Scheduled data collection from honeypots |
| `greedybear/models/` | Django models (IOC, Sensor, Feed, etc.) |
| `greedybear/api/` | DRF viewsets for feeds and threat intel |
| `greedybear/feeds/` | Feed generation logic |
| `greedybear/ml/` | ML models for threat classification |
| `frontend/src/` | React frontend |

## Open Issues (Target)

| # | Title | Strategy |
|---|-------|---------|
| [#1093](https://github.com/intelowlproject/GreedyBear/issues/1093) | Feeds sorting regression | Bug fix — priority |
| [#1092](https://github.com/intelowlproject/GreedyBear/issues/1092) | Simplify feed generation internals | Refactor |
| [#1089](https://github.com/intelowlproject/GreedyBear/issues/1089) | Feed filter state stale/shared state bug | Bug fix (React) |
| [#1087](https://github.com/intelowlproject/GreedyBear/issues/1087) | Training fails on unsafe training_data access | ML bug fix |
| [#1085](https://github.com/intelowlproject/GreedyBear/issues/1085) | Cronjob.execute() swallows exceptions | Django bug fix |

## Mentors (Honeynet GSoC)

- **Matteo Lodi** (mattebit) — primary maintainer of GreedyBear and IntelOwl
- **Eshaan Bansal** — IntelOwl maintainer
- Check https://www.honeynet.org/gsoc/ for 2026 mentor list

## Communication Channels

| Channel | Link | Purpose |
|---------|------|---------|
| Slack | honeynet.slack.com | PRIMARY — mentors are active here |
| GitHub Issues | https://github.com/intelowlproject/GreedyBear/issues | Contribution tracking |
| GitHub Discussions | https://github.com/intelowlproject/GreedyBear/discussions | Community |
| Honeynet GSoC | https://www.honeynet.org/gsoc/ | Official GSoC info |

---
*Priority: #5 — Solid Python/Django project with good mentors. Ruff compliance non-negotiable.*
