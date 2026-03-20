# Project #2: learningequality/kolibri

**Score: 59.58 | Merge Rate: 82.6% | External PRs: 23 | Rank: #2**

## Organization Overview

**Kolibri** is an open-source ed-tech platform by **Learning Equality** that delivers educational content to students in low-resource environments — offline-capable, deployable on cheap hardware, used in refugee camps, rural schools, and developing countries worldwide.

- **GitHub:** https://github.com/learningequality/kolibri
- **Stars:** ~1,100
- **Language:** Python (Django), Vue.js, SQLite
- **GSoC:** Confirmed. Learning Equality participates as a standalone GSoC org.
- **GSoC Ideas:** https://learningequality.org/gsoc (check for 2026 page)

## Why Kolibri is #2

- **82.6% merge rate** and 23 external PRs — very active, contributions get merged
- Mission-driven org — GSoC mentors are invested in contributors who understand the mission
- Active "good first issue" and "help wanted" backlog with real, achievable tasks
- Python/Django backend + Vue.js frontend aligns with Zakir's full-stack skills
- Strong documentation and contributing guidelines

## GSoC Project Ideas (Learning Equality)

| Idea | Difficulty | Fit |
|------|-----------|-----|
| Vue Testing Library migration (systematic) | Medium | Excellent — 10+ open issues, clear scope |
| Accessibility improvements (QTI Viewer, ARIA) | Medium | Good — issue #14347 |
| Offline sync improvements | Hard | Good for backend focus |
| Content recommendation system | Hard | AI/ML fit |
| Performance improvements / bundle size | Medium | Good |

## Tech Stack

| Component | Technology |
|-----------|-----------|
| Backend | Python 3.9+, Django, Django REST Framework |
| Frontend | Vue.js 2/3, JavaScript, Webpack |
| Database | SQLite (offline-first), PostgreSQL (optional) |
| Testing | pytest (backend), Jest + Vue Testing Library (frontend) |
| CI | GitHub Actions |
| Localization | Crowdin, ICU message format |
| Content delivery | Kolibri channel format, EPUB, H5P |

## Key Modules

| Module | Purpose |
|--------|---------|
| `kolibri/core/` | Django apps — auth, content, tasks, notifications |
| `kolibri/plugins/` | Plugin system for optional features |
| `packages/kolibri-tools/` | Build tooling |
| `kolibri/core/assets/src/` | Vue.js frontend components |
| `packages/kolibri-design-system/` | Shared UI component library |

## Open Issues (Target)

| # | Title | Strategy |
|---|-------|---------|
| [#14347](https://github.com/learningequality/kolibri/issues/14347) | QTI Viewer accessibility and spec fixes | Accessibility / Vue fix |
| [#14265](https://github.com/learningequality/kolibri/issues/14265) | Migrate Device auth tests to Vue Testing Library | Test migration |
| [#14264](https://github.com/learningequality/kolibri/issues/14264) | Migrate Device settings tests to Vue Testing Library | Test migration |
| [#14263](https://github.com/learningequality/kolibri/issues/14263) | Migrate Device transfer modal tests | Test migration |
| [#14262](https://github.com/learningequality/kolibri/issues/14262) | Migrate Device content tree tests | Test migration |

## Mentors (GSoC)

- Check https://learningequality.org/gsoc for 2026 mentor list
- Core team: rtibbles (Richard Tibbles), benjaoming, marcellamaki

## Communication Channels

| Channel | Link | Purpose |
|---------|------|---------|
| GitHub Issues | https://github.com/learningequality/kolibri/issues | Bug reports, contributions |
| GitHub Discussions | https://github.com/learningequality/kolibri/discussions | Community |
| Community Forums | https://community.learningequality.org | Mission-focused discussions |
| GSoC Channel | Via Learning Equality application | GSoC coordination |

## Zakir's Angle

- Full-stack Python/Django + Vue.js experience maps directly
- The Vue Testing Library migration is a systematic, well-scoped project perfect for GSoC
- Learning Equality cares deeply about contributors who understand the mission — spend a sentence in intro posts on why offline education in developing countries matters to you

---
*Priority: #2 — High merge rate, active issue backlog, strong Python/Django alignment*
