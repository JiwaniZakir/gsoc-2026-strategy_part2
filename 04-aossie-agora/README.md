# Project #4: AOSSIE-Org/Agora

**Score: 53.00 | External PRs: 15 | Rank: #4**

## Organization Overview

**AOSSIE** (Australian Open Source Software Innovation and Education) is a confirmed GSoC umbrella organization based at the Australian National University. They host multiple sub-projects across security, social good, and data science.

**Agora** is AOSSIE's voting systems library — a Scala library implementing various voting algorithms (Schulze, Instant-Runoff, Borda, etc.) with a REST API and web frontend.

- **Agora GitHub:** https://github.com/AOSSIE-Org/Agora
- **AOSSIE GitHub Org:** https://github.com/AOSSIE-Org
- **GSoC:** Confirmed umbrella org
- **GSoC Ideas:** https://gitlab.com/aossie/aossie/-/wikis/GSoC-2026-Ideas (check AOSSIE wiki)

## ⚠️ Strategy Note: Look Beyond Agora

Agora uses **Scala** — a JVM language. Zakir's stack is Python/JS. **Consider targeting other AOSSIE sub-projects that use Python:**

| AOSSIE Repo | Tech | Fit |
|-------------|------|-----|
| [PictoPy](https://github.com/AOSSIE-Org/PictoPy) | Python, ML, computer vision | **Excellent** |
| [CarbonFootprint](https://github.com/AOSSIE-Org/CarbonFootprint) | Python, web | Good |
| [Scavenger](https://github.com/AOSSIE-Org/Scavenger) | Scala | Poor |
| [Agora-Web](https://github.com/AOSSIE-Org/Agora-Web) | Play/Scala + Vue | Partial |

**Primary recommendation:** Target **PictoPy** (Python ML computer vision) for PRs, while still applying under AOSSIE org.

## Agora Tech Stack

| Component | Technology |
|-----------|-----------|
| Core algorithms | Scala 2.13 |
| Build | sbt |
| Testing | ScalaTest, Scoverage |
| API | Play Framework |
| Frontend | JavaScript |
| CI | GitHub Actions |

## PictoPy Tech Stack (Better Fit)

| Component | Technology |
|-----------|-----------|
| Core | Python, Rust (via PyO3) |
| ML | OpenCV, face recognition, image classification |
| Testing | pytest |
| API | FastAPI |

## Agora Open Issues (Target for Initial PRs)

| # | Title | Strategy |
|---|-------|---------|
| [#20](https://github.com/AOSSIE-Org/Agora/issues/20) | Rename project from countvote to agora | Simple rename — good first PR |
| [#15](https://github.com/AOSSIE-Org/Agora/issues/15) | Add Scoverage code coverage report | Add sbt plugin + CI config |
| [#16](https://github.com/AOSSIE-Org/Agora/issues/16) | Publish library to Sonatype | Build/release pipeline |
| [#13](https://github.com/AOSSIE-Org/Agora/issues/13) | Add performance test using Gatling | Performance testing |

## GSoC Project Ideas

| Idea | Stack | Fit |
|------|-------|-----|
| PictoPy: AI-powered photo organization features | Python/ML | Excellent |
| Agora-Web: RESTful API modernization | Scala/Play | Moderate |
| Agora: New voting algorithm implementations | Scala | Poor (wrong language) |
| CarbonFootprint: Data visualization dashboard | Python/JS | Good |

## Communication Channels

| Channel | Link | Purpose |
|---------|------|---------|
| Gitter | https://gitter.im/AOSSIE/ | Primary community channel |
| GitHub | https://github.com/AOSSIE-Org | Issues, PRs |
| GitLab | https://gitlab.com/aossie | GSoC coordination, wiki |
| Email | gsoc@aossie.org | GSoC applications |

## Key Contacts

- **Thushan Ganegedara** — AOSSIE admin, Google Brain researcher
- Check AOSSIE wiki for 2026 mentor list

---
*Priority: #4 — Target PictoPy (Python ML) for PRs while applying under AOSSIE umbrella*
