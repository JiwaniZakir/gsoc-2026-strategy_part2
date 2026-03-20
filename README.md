# GSoC 2026 — Data-Driven Hyper-Aggressive Blitz (v2)

**Zakir Jiwani** | [GitHub: JiwaniZakir](https://github.com/JiwaniZakir) | jiwzakir@gmail.com

**Status:** EXECUTING — Blitz started March 19. Proposals submit March 24.
**Mode:** AI-augmented output — 2–3 PRs per day per active project, Claude writes code/tests/docs simultaneously.

---

## The New Top 5 — Data-Driven Selection (Updated March 19)

**Methodology:** Ranked by composite score (merge rate × external PR volume × GSoC confirmation × Zakir's existing relationship). Numbers, not gut feel.

| Rank | Project | Score | Merge Rate | Ext PRs | Zakir's Edge |
|------|---------|-------|-----------|---------|-------------|
| 🥇 1 | [pyro-ppl/numpyro](https://github.com/pyro-ppl/numpyro) | **69.26** | **92.9%** | 14 | Existing PR + JAX/ML background |
| 🥈 2 | [learningequality/kolibri](https://github.com/learningequality/kolibri) | **59.58** | **82.6%** | 23 | Python/Django + Vue.js skills |
| 🥉 3 | [prowler-cloud/prowler](https://github.com/prowler-cloud/prowler) | **53.16** | **62.5%** | 16 | **MERGED PRs already** |
| 4 | [AOSSIE-Org/Agora](https://github.com/AOSSIE-Org/Agora) | **53.00** | — | 15 | Python ML fit via PictoPy |
| 5 | [honeynet/GreedyBear](https://github.com/intelowlproject/GreedyBear) | **49.72** | — | — | Security + Django background |

### Honorable Mentions (Backup Targets)
| Project | Why |
|---------|-----|
| mozilla/pontoon | Solid Django org, active GSoC |
| aboutcode-org/vulnerablecode | High issue volume but competitor-saturated importers |
| accordproject/cicero | Moderate competition, concerto has 26 open issues |
| wagtail/wagtail | Large Django org, consistent GSoC participant |

---

## Why the Old Top 5 Was Wrong

| Old Pick | Problem | Replaced By |
|----------|---------|------------|
| accord-project | Moderate opportunity, not data-validated | numpyro (#1) — 92.9% merge rate |
| dora-rs | Bhanudahiyaa has 9 PRs in 48h dominating Rust/CLI | kolibri (#2) — clean 82.6% rate |
| 04-aboutcode-vulnerablecode | Competitors saturating wrong area (importers) | prowler (#3) — Zakir has merges |
| 05-open-climate-fix | Lower composite score | AOSSIE (#4) — Python ML umbrella |

**The single most important data point:** Zakir has MERGED PRs in prowler-cloud/prowler.
That's worth more than any score advantage. It stays at #3.

---

## Priority Rationale

### numpyro is #1 because 92.9% merge rate
If you submit a quality PR here, it merges. That's the highest expected value of any project in the analysis. Combine that with an existing PR (warm relationship with maintainers) and JAX/ML alignment, and this is the clear #1.

### kolibri is #2 because of the PR machine
The Vue Testing Library migration has 10+ individual issues, each a standalone PR. An AI-augmented contributor can submit 2 PRs/day here without repeating. 82.6% merge rate means they actually get merged. Mission-driven org = strong mentors.

### prowler is #3 because Zakir is not a cold start
Lower merge rate (62.5%) than #1/#2, but Zakir has already cleared the "who is this person" hurdle. Returning contributors get more trust from reviewers. The merge rate disadvantage is offset by the relationship advantage.

### AOSSIE is #4 with a caveat
Agora uses Scala — wrong language. The real target is **PictoPy** (Python ML, computer vision), a sub-project under the AOSSIE umbrella. If PictoPy doesn't have GSoC slots in 2026, this pick drops off the list. Check the AOSSIE GitLab wiki immediately.

### GreedyBear is #5 for the security angle
Solid Python/Django project under an established GSoC org (Honeynet Project). Active maintainer (Matteo Lodi) is responsive. Cybersecurity domain fits Zakir's background. Lower score but actionable open issues.

---

## Aggregate Output Targets (Mar 19–23)

| Day | numpyro | kolibri | prowler | AOSSIE | GreedyBear | Daily Total |
|-----|---------|---------|---------|--------|-----------|------------|
| Mar 19 | 1 PR | 1 PR | 1 PR | 1 PR | 1 PR | 5 |
| Mar 20 | 1 PR | 2 PRs | 1 PR | 1 PR | 2 PRs | 7 |
| Mar 21 | 1 PR | 1 PR | 1 PR | 1 PR | 1 PR | 5 |
| Mar 22 | 1 PR | 2 PRs | 1 PR | 2 PRs | 1 PR | 7 |
| Mar 23 | 1 PR | 1 PR | 1 PR | 1 PR | 1 PR | 5 |
| **TOTAL** | **5** | **7** | **5** | **6** | **6** | **29** |

**Target: 29 PRs across 5 projects, 5 proposals submitted by March 24.**

---

## Zakir's Proof Points (Use in Every Proposal)

| Proof Point | Relevance |
|------------|-----------|
| huggingface/transformers (merged) | ML credibility — 100k+ line Python codebase |
| prowler-cloud/prowler (merged) | Security + Python credibility |
| 132 total PRs, 84 unique repos in one week | Ability to ramp on unfamiliar codebases fast |
| lattice (multi-agent framework) | Python system design, agent frameworks |
| spectra (RAG eval toolkit) | ML evaluation, Python packaging |
| aegis (intelligence platform, 338 tests) | Production Django + FastAPI |
| sentinel (Slack bot, 209 tests) | Node.js production code |
| Existing numpyro PR | Direct numpyro experience |

---

## Files in This Repo

| File / Directory | Purpose |
|-----------------|---------|
| `README.md` | This file — master strategy (v2, updated March 19) |
| `OUTREACH_STRATEGY.md` | Per-project outreach with channels, mentors, message templates |
| `AI_CONTRIBUTION_ENGINE.md` | How to use Claude for 2–3 PRs/day |
| `COMPETITOR_ANALYSIS.md` | Intelligence on active competitors |
| `REPO_INTELLIGENCE.md` | Deep-dive: merge rates, open issues |
| `GITHUB_ANALYSIS.md` | Zakir's contribution profile analysis |
| `CONTRIBUTION_PLAYBOOK.md` | General speed-PR tactics |
| **`01-numpyro/`** | pyro-ppl/numpyro — Score 69.26, **#1 pick** |
| **`02-kolibri/`** | learningequality/kolibri — Score 59.58, **#2 pick** |
| **`03-prowler/`** | prowler-cloud/prowler — Score 53.16, **#3 pick** |
| **`04-aossie-agora/`** | AOSSIE-Org (PictoPy focus) — Score 53.00, **#4 pick** |
| **`05-greedybear/`** | honeynet/GreedyBear — Score 49.72, **#5 pick** |

Each project directory contains:
- `README.md` — Org overview, GSoC ideas, mentors, tech stack, community channels
- `CONTRIBUTION_PLAN.md` — Aggressive 5-day PR plan with exact commands
- `ENGAGEMENT_GUIDE.md` — Day-by-day outreach with exact message templates
- `PROPOSAL_DRAFT.md` — Near-final GSoC proposal tailored to Zakir's profile
- `ARCHITECTURE.md` — Codebase structure, key modules, build/test commands

---

**Last Updated:** March 19, 2026
**Intelligence Source:** GitHub API sweep (March 19, 2026) — scores, merge rates, issue analysis
**Previous strategy:** See git history for old top 5 (accord-project, dora-rs, honeynet, vulnerablecode, open-climate-fix)
