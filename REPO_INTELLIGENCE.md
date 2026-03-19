# Repository Intelligence — 5 GSoC Target Repos
> Generated: 2026-03-19 via `gh` CLI
> Deep-dive into activity, openness to external PRs, mentor responsiveness, and entry points

---

## Table of Contents
1. [Accord Project (cicero / concerto)](#1-accord-project)
2. [dora-rs/dora](#2-dora-rsdora)
3. [honeynet/GreedyBear](#3-honeynetgreedybear)
4. [aboutcode-org/vulnerablecode](#4-aboutcode-orgvulnerablecode)
5. [openclimatefix/quartz-solar-forecast](#5-openclimatefix)
6. [Summary Comparison Table](#summary-comparison-table)

---

## 1. Accord Project

### Key Repos

| Repo | Stars | Forks | Open Issues | Language |
|------|-------|-------|-------------|----------|
| cicero | ~180 (API 404) | — | — | JavaScript |
| concerto | 176 | 196 | 26 | JavaScript |
| template-archive | 332 | 170 | 93 | JavaScript |

> Note: `gh api repos/accordproject/cicero` returned template-archive data — cicero may be archived or renamed. The active repo serving GSoC is likely **template-archive** + **concerto**.

### PR Activity (cicero)

**Open PRs (9):**
- `Divyansh2992` — 2 PRs (fix missing await, setReadme preserves logo) — active external contributor
- `yashhzd` — 2 PRs (compress .cta archives with DEFLATE, guard against circular inheritance)
- `vermarjun` — reenable template signing
- `Darshan-paul` — fix minor grammar in README
- `utkarsh636-developer` — remove deprecated 'request' dependency
- 2× `dependabot[bot]`

**Recent Merged (last 10):**
| PR | User | Merged |
|----|------|--------|
| fix: add versioned namespaces to test .cto files | yuanglili | 2026-03-19 |
| docs: update documentation link to HTTPS | Atharva7115 | 2026-03-14 |
| feat: fix windows path normalization | Rahul-R79 | 2026-03-07 |
| test: 100% coverage for LogicManager | Drita-ai | 2026-03-07 |
| chore(deps): various bumps | dependabot | 2026-03-07 |

**Merge rate**: 4 external PRs merged in 2 weeks — **moderately receptive**

### Core Team
| Contributor | Commits | Role |
|-------------|---------|------|
| jeromesimeon | 385 | Core maintainer |
| dselman | 322 | Core maintainer |
| mttrbrts | 236 | Core maintainer |
| sanketshevkar | 30 | Past GSoC contributor |

### CONTRIBUTING.md
✅ Exists (`CONTRIBUTING.md`)

### GSoC Issues
- No open issues labeled `gsoc` in cicero or concerto
- No `good first issue` labels found in cicero

### Entry Point Assessment
- **Stack**: JavaScript/Node.js (Ergo smart contract logic, CiceroMark, template parsing)
- **Appetite for external PRs**: Yes — multiple external contributors merged in March 2026
- **Mentor activity**: PRs reviewed and merged within days
- **Key risk**: Cicero repo might be winding down; check if GSoC 2026 org page lists specific repos

---

## 2. dora-rs/dora

### Repo Stats
| Metric | Value |
|--------|-------|
| Stars | 3,057 ⭐ |
| Forks | 335 |
| Open Issues | 145 |
| Language | **Rust** (Python, C++ bindings) |
| Last Updated | 2026-03-19 (today) |

### PR Activity

**Open PRs (15+):**
| User | PRs | Focus |
|------|-----|-------|
| `Bhanudahiyaa` | 9 (in 2 days!) | state KV store, CLI, coordinator persistence, lock files |
| `ashnaaseth2325-oss` | 3 | panic fixes for non-UTF-8 paths |
| `phil-opp` (core) | 1 | remove unused shared-memory control channel |
| `swar09` | 1 | overhaul rust-dataflow-url example |
| `PavelGuzenfeld` | 1 | zero-copy output API (merged!) |

**Recent Merged (last 15):**
| PR | User | Merged | Type |
|----|------|--------|------|
| fix build output draining | Monti-27 | 2026-03-18 | bug fix |
| feat(c++/node): zero-copy output API | PavelGuzenfeld | 2026-03-18 | feature |
| feat(c++/node): dynamic node initialization | PavelGuzenfeld | 2026-03-18 | feature |
| fix(operator-api): propagate OpenTelemetry context | Bhanudahiyaa | 2026-03-18 | bug fix |
| fix(core): validate URL sources during descriptor checks | Bhanudahiyaa | 2026-03-18 | bug fix |
| fix(test): handle Stop events in queue timeout test | Bhanudahiyaa | 2026-03-18 | test |
| fix(core): fix flaky check_url test | phil-opp | 2026-03-18 | test |

**Merge rate**: Very high — multiple external PRs merged daily

### Core Team
| Contributor | Commits | Role |
|-------------|---------|------|
| phil-opp | 1,940 | Core maintainer (also famous for blog.phil-opp.com) |
| haixuanTao | 1,854 | Core maintainer |
| eduidl | 138 | Regular contributor |

### CONTRIBUTING.md
✅ Exists

### Good First Issues
- "Provide progress bars for time-consuming operations" [good first issue, cli]
- "Improve Users-Getting Started on dora-rs.ai" [good first issue]
- "Use pyo3 experimental-inspect instead of generate_stubs.py" [good first issue, python]

### Entry Point Assessment
- **Stack**: Rust (primary), Python/C++ bindings
- **Merge receptiveness**: VERY HIGH — external PRs merged same day
- **Mentor responsiveness**: phil-opp reviews within hours
- **Key risk**: `Bhanudahiyaa` has submitted 9 PRs in 2 days — they are aggressively targeting this org
- **GSoC relevance**: robotics/AI middleware — strong GSoC theme
- **Best entry**: Python bindings issues (pyo3 stubs), CLI features, examples overhaul

---

## 3. honeynet/GreedyBear

### Repo Stats
| Metric | Value |
|--------|-------|
| Stars | 187 |
| Forks | 123 |
| Open Issues | 50 |
| Language | **Python** (Django) + React frontend |
| Last Updated | 2026-03-19 (today) |

### PR Activity

**Open PRs (15+):**
| User | PR | Area |
|------|-----|------|
| `Prasad8830` | Feeds filter state and duplicate DOM ids fix | Frontend |
| `Aditya30ag` | Fix training_data validation | Backend |
| `R1sh0bh-1` | Support for custom labels/descriptions in Sensor model | Backend |
| `TEMHITHORPHE` | Refactor: Rename GeneralHoneypot to Honeypot | Refactor |
| `opbot-xd` | Pre-compute ASN aggregates on AutonomousSystem model | Backend |
| `piyushzgautam99` | Add test coverage for dashboard/utils/charts.jsx | Tests |
| `IQRAZAM` | fix(cronjob): propagate exceptions in execute() | Backend |
| `swara-2006` | Added test for useAuthStore component | Tests |
| `lvb05` | feat(feeds/advanced): add country filter | Feature |
| `regulartim` | uv migration test (DRAFT) | Infra |

**Recent Merged (last 15):**
| PR | User | Merged | Type |
|----|------|--------|------|
| Feature: Heralding extraction strategy | rootp1 | 2026-03-19 | feature |
| Feature: Extract/store Cowrie file transfer metadata | cclts | 2026-03-19 | feature |
| enh: Log feature importances after RF training | drona-gyawali | 2026-03-18 | enhancement |
| feat: persist Feeds page filters in URL query params | Deepanshu1230 | 2026-03-18 | feature |
| fix: replace socket.inet_aton with ipaddress.ip_address | rahulgunwanistudy-2005 | 2026-03-17 | bug fix |
| tests: add coverage for greedybear/utils.py | manik3160 | 2026-03-17 | tests |
| fix: normalize_credential_field missing truncation | Sanchit2662 | 2026-03-17 | bug fix |
| Fix: case-insensitive honeypot membership check | Abhijeet17o | 2026-03-18 | bug fix |

**Merge rate**: HIGH — 8 external PRs merged in 3 days

### Core Team
| Contributor | Commits | Role |
|-------------|---------|------|
| mlodic | 267 | Core maintainer |
| regulartim | 88 | Core maintainer |
| opbot-xd | 27 | Regular contributor |
| drona-gyawali | 10 | Active GSoC aspirant (already merged) |

### CONTRIBUTING.md
❌ Not found — contributor guidance is informal

### Good First Issues
- No `good first issue` labels visible — browse open issues for `Closes #XXX` patterns in PR titles

### Notable Open Issues Referenced in PRs
- #1089 — Feeds filter state
- #1087 — training_data validation
- #1060 — Custom labels/descriptions in Sensor model
- #1050 — Log feature importances (already merged)
- #1043 — utilities coverage (already merged)
- #1034 — cronjob exception propagation
- #987 — useAuthStore test
- #852 — ASN aggregates pre-computation

### Entry Point Assessment
- **Stack**: Python/Django backend + React/Vite frontend
- **Merge receptiveness**: VERY HIGH — 8 merges in 3 days
- **Mentor responsiveness**: mlodic reviews quickly (same-day merges)
- **Key risk**: Over 10 external PRs open simultaneously — intense competition
- **Best entry**: Pick any open issue with `Closes #XXX` not yet claimed, focus on backend (Django) features or ML model improvements

---

## 4. aboutcode-org/vulnerablecode

### Repo Stats
| Metric | Value |
|--------|-------|
| Stars | 650 |
| Forks | 291 |
| Open Issues | **756** (!!) |
| Language | Python (Django) |
| Last Updated | 2026-03-19 (today) |

### PR Activity

**Open PRs (15+):**
| User | PR | Type |
|------|-----|------|
| `Tednoob17` | Add ZyXEL v2 security advisories importer | importer |
| `NucleiAv` | Add Check Point security advisories importer | importer |
| `NucleiAv` | Add Eclipse Foundation security advisories importer | importer |
| `Tednoob17` | Add documentation for V2 pipeline identifiers | docs |
| `Tednoob17` | Add CloudVulnDB importer | importer |
| `NucleiAv` | Add LibreOffice security advisories importer | importer |
| `ziadhany` | Add API and UI support for vulnerability rules | feature |
| `TG1999` (core) | Change API design | core |
| `NucleiAv` | Add Collabora Online security advisory importer | importer |
| `NucleiAv` | Add Alpine security advisory importer | importer |
| `NucleiAv` | Add ZDI security advisory importer | importer |
| `NucleiAv` | Add Grafana security advisory importer | importer |
| `malladinagarjuna2` | Add Gentoo improver and fix importer | importer |
| `Samk1710` | Add VMware Photon Importer | importer |
| `Dhirenderchoudhary` | Add commit collection to Apache Tomcat V2 | enhancement |

**Recent Merged:**
| PR | User | Merged |
|----|------|--------|
| Store advisory content hash | TG1999 | 2026-03-16 |
| Review all v2 pipelines | TG1999 | 2026-03-04 |
| Fix null constraint violations in v1 exploit pipelines | ziadhany | 2026-03-02 |

### Core Team
| Contributor | Commits | Role |
|-------------|---------|------|
| TG1999 | 598 | Core maintainer |
| sbs2001 | 574 | Core maintainer |
| keshav-space | 465 | Core maintainer |
| pombredanne | 458 | Core maintainer |
| ziadhany | 149 | Regular contributor (former GSoC?) |

### CONTRIBUTING.md / CONTRIBUTING.rst
- `CONTRIBUTING.md` — 404
- `CONTRIBUTING.rst` — ✅ exists

### GSoC-Labeled Issues
| Issue | Label | Created |
|-------|-------|---------|
| VulnerableCode Insights | GSoC | 2023-08-22 |
| Implement notification system for follow activity | GSoC | 2023-07-17 |

### Good First Issues (10 open)
- In UI/API, sort packages and vulnerabilities newest-to-oldest (easy, ui)
- Improve "Severities vectors" tab in Vulnerability details (easy/intermediate, ui)
- Collect data from Anchore NVD overrides (easy)
- Add Liferay advisories (easy)
- Add data in CSAF format from cisagov/CSAF (good first issue + GSoC 24)
- Add CURL advisories data source (easy)
- Ingest github ecosystems (medium)
- Use centralized function/objects for all network access (intermediate)
- Track Apache Log4j advisories (low priority)
- Add tests for Docker (dev-env)

### Entry Point Assessment
- **Stack**: Python/Django, data pipelines, REST API
- **Merge receptiveness**: MODERATE — core team (TG1999, keshav-space) are active but reviewing many PRs
- **Pattern**: "Add [X] importer" is the default entry point — very easy to clone the pattern
- **Key risk**: NucleiAv has 6+ open PRs all adding importers — this pattern is saturated
- **Better entry**: API features, UI improvements, testing, the "Use centralized function for network access" good-first-issue
- **756 open issues** = massive opportunity and also indicator of slow review velocity on some tracks

---

## 5. openclimatefix/quartz-solar-forecast

### Repo Stats
| Metric | Value |
|--------|-------|
| Stars | 125 |
| Forks | 105 |
| Open Issues | 60 |
| Language | Jupyter Notebook / Python |
| Last Updated | 2026-03-16 |

### PR Activity

**Open PRs (15):**
| User | PR | Type |
|------|-----|------|
| `Raakshass` | Add v3 LightGBM model with enhanced feature engineering | feature |
| `Raakshass` | Feature/issue 217 snow depth | feature |
| `Raakshass` | feat: Deploy React dashboard to Netlify | feature |
| `Raakshass` | fix: Add Python 3.12 compatibility | fix |
| `Sharkyii` | Add Geographic Visualization | feature |
| `Sharkyii` | Missing pv.netcdf | bug |
| `Sharkyii` | Fix inconsistent start_date/start_time around midnight | bug |
| `CodeVishal-17` | Fix timezone handling and midnight rounding | bug |
| `CodeVishal-17` | ci: migrate to reusable workflows | CI |
| `stromfee` | Add AgentMarket - Energy Data API | feature |
| `astropedrocosta` | fix: Use native xgb.Booster | bug |
| `Copilot` | Add Zimbabwe flag to README | docs |
| `yuvraajnarula` | Add DuckDB query layer | feature |
| `symbioquine` | Fix data exfil with disabled Sentry | security |
| `symbioquine` | Pin numexpr and sentry-sdk deps | fix |

**Recent Merged:**
| PR | User | Merged |
|----|------|--------|
| refactor: remove sentry logging | danishdynamic | 2026-03-16 |
| Add optional APITally monitoring | CodeVishal-17 | 2026-02-23 |
| fix: Remove trailing whitespace | Raakshass | 2026-02-16 |
| fix: improve production code safety | Raakshass | 2026-02-03 |

### Core Team
| Contributor | Commits | Role |
|-------------|---------|------|
| peterdudfield | 150 | Core maintainer (Peter Dudfield) |
| aryanbhosale | 47 | Regular contributor |
| froukje | 41 | Regular contributor |
| EdFage | 25 | Regular contributor |

### CONTRIBUTING.md
❌ Not found

### Good First Issues (6)
- CI tests take 20 mins (optimization)
- Make sure all tests work
- Evaluate live models
- Should we smooth the xgboost model
- Add python3.12
- Challenge: new model [good first issue + help wanted]

### Entry Point Assessment
- **Stack**: Python, scikit-learn, XGBoost, LightGBM, Jupyter, PyTorch (pvnet)
- **Merge receptiveness**: MODERATE — peterdudfield is the main reviewer, merges happen but slowly (last merge March 16, before that Feb 23)
- **Niche**: solar forecasting + climate tech = very relevant for GSoC (positive contribution framing)
- **Key risk**: Raakshass is squatting on ML model improvements with 4 open PRs
- **Better entry**: "Add python3.12" (simple), CI speed improvements, live model evaluation, pvnet testing

---

## Summary Comparison Table

| Repo | Stars | Language | Merge Velocity | Competition Level | GSoC Labels | Best Entry Strategy |
|------|-------|----------|---------------|-------------------|-------------|---------------------|
| accordproject/cicero | ~332 (template-archive) | JavaScript | Moderate (4/2wk) | Medium | None visible | JavaScript template engine features |
| dora-rs/dora | 3,057 ⭐⭐⭐ | Rust | **Very High** (8/day) | **Very High** | None | Python bindings, pyo3 stubs, examples |
| honeynet/GreedyBear | 187 | Python+React | **Very High** (8/3days) | **Very High** | None | Django backend features, ML improvements |
| aboutcode-org/vulnerablecode | 650 | Python | Moderate (core only) | **Extreme** | 2023 issues | API/UI features (not another importer!) |
| openclimatefix/quartz-solar-forecast | 125 | Python/Jupyter | Low-Moderate | Medium | None | Python 3.12 compat, CI speed, new model |

---

## Branch Protection & CLA Notes

- **dora-rs/dora**: No CLA mentioned in CONTRIBUTING.md; DCO (Developer Certificate of Origin) likely via commit message
- **accordproject/cicero**: Has CONTRIBUTING.md — check for CLA requirement (Apache-licensed project)
- **honeynet/GreedyBear**: No CONTRIBUTING.md found — informal process
- **aboutcode-org/vulnerablecode**: CONTRIBUTING.rst exists — Apache License, no CLA barrier observed
- **openclimatefix**: No CONTRIBUTING.md — community-friendly, peterdudfield is approachable on GitHub

---

## Red Flags

1. **dora-rs**: `Bhanudahiyaa` submitted 9 PRs in 48 hours — this is a dedicated GSoC aspirant flooding the queue. Their PRs are substantive (coordinator KV store, CLI enforcement) not trivial fixes.

2. **vulnerablecode**: `NucleiAv` has 6+ open importer PRs. The "add an importer" pattern is so saturated that it may no longer differentiate candidates. Core team PR merges are mostly from established contributors (TG1999, keshav-space).

3. **GreedyBear**: 10+ external PRs open simultaneously targeting GSoC — the most competitive per-star ratio of all 5 repos.

4. **OCF**: Low merge velocity and 15 open PRs from only a handful of contributors — mentor (peterdudfield) may be bottlenecked.
