# GSoC 2026 — Intelligence-Driven Hyper-Aggressive Blitz

**Zakir Jiwani** | [GitHub: JiwaniZakir](https://github.com/JiwaniZakir) | jiwzakir@gmail.com

**Status:** EXECUTING — Blitz started March 19. Proposals submit March 24.
**Mode:** AI-augmented output — 2–3 PRs per day per active project, Claude writes code/tests/docs simultaneously.

---

## Intelligence Summary (as of 2026-03-19)

From `GITHUB_ANALYSIS.md`, `REPO_INTELLIGENCE.md`, and `COMPETITOR_ANALYSIS.md`:

### Zakir's Current Profile
- **132 total PRs** across 84 repos, **13 merged** (9.8% rate)
- Flagship merges: `huggingface/transformers`, `prowler-cloud/prowler` — two serious Python/security repos
- Burst window: 80+ PRs in 3 days March 16–18 — demonstrates AI-assisted volume capability
- **0 contributions to any of the 5 target GSoC repos** — starting cold but with demonstrated merge capability

### Priority Ranking — Revised Based on Intelligence

| Priority | Org / Project | Why |
|----------|--------------|-----|
| 🥇 1 | **aboutcode-org/vulnerablecode** | 756 open issues, competitors doing the WRONG thing (importer spam), actual merged work is API/UI — wide open |
| 🥈 2 | **openclimatefix** | Moderate competition, pvnet repo nearly untouched, Python/ML stack perfect match |
| 🥉 3 | **accordproject/cicero** | Moderate competition, concerto has 26 open issues with no one touching them |
| 4 | **honeynet/GreedyBear** | Crowded but feasible — must find unclaimed issues, ML model work is an opening |
| 5 | **dora-rs/dora** | Bhanudahiyaa has 9 PRs in 48h dominating CLI/state/coordinator — only entry is Python bindings |

---

## Why the Old Priority Was Wrong

| Old Priority | Old Order | Reality Check |
|-------------|-----------|---------------|
| 1 → Accord Project | Had it 1st | Actually 3rd — moderate competition, smaller org |
| 2 → dora-rs | Had it 2nd | Should be 5th — Bhanudahiyaa makes this extremely hard |
| 4 → VulnerableCode | Had it 4th | Should be 1st — biggest opportunity in the entire analysis |

---

## Competitor Map — Know Your Enemies

### dora-rs: EXTREME THREAT
**Bhanudahiyaa** submitted 9 PRs in 48 hours — all substantive:
- coordinator KV store, state persistence, CLI enforcement, OpenTelemetry propagation
- 3 of 9 already merged
- Counter: Python bindings only (pyo3 stubs, Python operator API bugs) — Bhanudahiyaa hasn't touched these

### vulnerablecode: THREAT FROM WRONG DIRECTION
**NucleiAv** has 6 open importer PRs — NONE merged yet.
**Tednoob17** has 3 more importers — NONE merged yet.
- Core team (TG1999, keshav-space) is NOT merging importers
- They ARE merging: API changes (ziadhany), architecture work
- Counter: Do what competitors aren't doing — API/UI features, network centralization

### GreedyBear: CROWDED
10+ external PRs open simultaneously. Key merged PRs: Heralding extraction, Cowrie metadata, ML feature importances.
- Counter: Find issues NOT yet claimed, target ML model improvements (less saturated than frontend/backend fixes)

### OCF: MANAGEABLE
**Raakshass** has 4 PRs (2 merged) but focused on ML models. **pvnet** repo (49 stars, 14 issues) is nearly untouched.
- Counter: Focus on pvnet, CI speed (20 min issue), Python 3.12 compat

### Accord Project: MANAGEABLE
**Divyansh2992** and **yashhzd** have moderate PRs. Recent merges: Windows path fix (Rahul-R79), test coverage (Drita-ai).
- Counter: Target concerto (26 open issues, less contested than cicero)

---

## AI-Augmented Output Strategy

> **This is NOT a realistic human timeline.** This is Claude-assisted output where:
> - Claude analyzes the codebase to identify the exact fix
> - Claude writes the code, tests, and PR description simultaneously
> - Human reviews for correctness and naturalness, then submits
> - While one PR is in review, Claude is already starting the next

### Daily Output Targets

| Day | vulnerablecode | OCF/pvnet | Accord | GreedyBear | dora-rs |
|-----|---------------|-----------|--------|-----------|---------|
| March 19 | 2 PRs | 1 PR | 1 PR | 1 PR | 0 (setup) |
| March 20 | 2 PRs | 1 PR | 1 PR | 1 PR | 1 PR (Python only) |
| March 21 | 1 PR | 1 PR | 1 PR | 1 PR | 0 (proposal focus) |
| March 22 | 1 PR | 1 PR | 0 | 0 | 0 (proposal focus) |
| March 23 | 0 | 0 | 0 | 0 | 0 (submission day) |
| **TOTAL** | **6** | **4** | **3** | **3** | **1** |

**Target: 17 total PRs across 5 repos in 5 days, parallel to writing 5 proposals.**

---

## Day-by-Day Master Schedule

**Override principle:** vulnerablecode gets 40% of coding time every day. It's the biggest opportunity.

### Day 1 — March 19: Deploy All Fronts

| Time | Action |
|------|--------|
| 07:00–08:00 | Set up all 5 environments. Clone + test suite pass. |
| 08:00–09:30 | **vulnerablecode PR #1:** "Sort packages/vulnerabilities newest-to-oldest" (good first issue, UI/API, easy) |
| 09:30–10:30 | Post intro to all 5 communities — Discord, Gitter, Slack simultaneously |
| 10:30–12:00 | **vulnerablecode PR #2:** "Use centralized function/objects for all network access" (claim + start) |
| 12:00–13:30 | **Accord PR #1:** concerto issue (not cicero — find unclaimed) |
| 13:30–15:00 | **GreedyBear PR #1:** find unclaimed issue (not #1089 which Prasad8830 has) |
| 15:00–16:30 | **OCF/pvnet PR #1:** Python 3.12 compat or CI speed issue |
| 16:30–18:00 | Check all PR statuses, respond to any feedback within the hour |
| 18:00–21:00 | Write proposal skeletons for all 5 — titles + 3 deliverables each |

**Day 1 exit criteria:** 5 PRs submitted across 4 repos, 5 community intros posted, all envs running.

---

### Day 2 — March 20: Second Wave + Depth

| Time | Action |
|------|--------|
| 08:00–08:30 | Respond to all overnight PR feedback |
| 08:30–10:30 | **vulnerablecode PR #3:** "Improve Severities vectors tab" (good first issue, UI) |
| 10:30–12:00 | **vulnerablecode PR #4:** Start "Add tests for Docker" or API endpoint test coverage |
| 12:00–13:30 | **OCF PR #2:** pvnet repo — pick any of 14 open issues |
| 13:30–15:00 | **dora-rs PR #1:** pyo3 experimental-inspect stubs (Python only, zero Rust conflict with Bhanudahiyaa) |
| 15:00–16:00 | Post smart technical question in each community channel (one per project) |
| 16:00–18:00 | Review 2–3 open PRs in any target repos — leave substantive comments |
| 18:00–21:00 | Write full Problem Statement + Technical Approach for top 2 proposals (vulnerablecode, OCF) |

**Day 2 exit criteria:** 9 total PRs, technical questions posted, 2 proposals 60% done.

---

### Day 3 — March 21: Substance + Mentors

| Time | Action |
|------|--------|
| 08:00–08:30 | Respond to all PR feedback immediately |
| 08:30–10:30 | **vulnerablecode PR #5:** "Collect data from Anchore NVD overrides" or "Add CURL advisories" (easy, different from importer spam pattern) |
| 10:30–12:00 | **Accord PR #2:** Second concerto contribution (test coverage or bug fix) |
| 12:00–13:00 | Share proposal outlines with mentors — all 5 communities |
| 13:00–15:00 | **GreedyBear PR #2:** ML model improvement (Random Forest feature importance or new model variant) |
| 15:00–17:00 | **OCF PR #3:** pvnet second contribution |
| 17:00–21:00 | Complete 3 proposals to 80% — vulnerablecode, OCF, Accord |

**Day 3 exit criteria:** 12 total PRs, mentors engaged, 3 proposals 80% done.

---

### Day 4 — March 22: Polish

| Time | Action |
|------|--------|
| 08:00–09:00 | Address all outstanding PR feedback |
| 09:00–11:00 | **vulnerablecode PR #6:** final high-value PR (API endpoint or UI feature) |
| 11:00–13:00 | **OCF PR #4:** pvnet or quartz-solar model evaluation |
| 13:00–15:00 | Incorporate mentor feedback into proposals |
| 15:00–21:00 | Finalize proposals 1–3 to submit-ready quality |

**Day 4 exit criteria:** 14 PRs total, proposals 1–3 submit-ready.

---

### Day 5 — March 23: Finish Line

| Time | Action |
|------|--------|
| 08:00–11:00 | Finalize proposals 4–5 (GreedyBear, dora-rs) |
| 11:00–13:00 | Final polish all 5 proposals |
| 13:00–14:00 | Incorporate any overnight community feedback |
| 14:00–16:00 | Submit all 5 proposals to GSoC platform |
| 16:00–18:00 | Post final contribution summaries in all channels. Thank mentors by name. |
| 18:00+ | Watch open PRs. More merges = more signal for evaluators. |

---

## Unclaimed Territory Map

### vulnerablecode — High-Value Unclaimed Issues
- "Sort packages and vulnerabilities newest-to-oldest" — API/UI change, nobody has touched this
- "Use centralized function/objects for all network access" — architecture improvement, no PR exists
- "Improve Severities vectors tab" — UI feature, unclaimed
- "Collect data from Anchore NVD overrides" — data source, not the importer pattern
- "Add CURL advisories data source" — different from competitor importers (they're doing vendor advisories)
- "Add tests for Docker" — dev-env testing, unclaimed

### dora-rs — Bhanudahiyaa-Free Zones
- `pyo3 experimental-inspect` stubs — Python, not Rust CLI
- "Improve Users-Getting Started" docs — nobody doing this
- "Provide progress bars for time-consuming operations" — CLI UX, Bhanudahiyaa focused on architecture not UX
- Python operator API bug fixes (non-Rust path)

### GreedyBear — After Scanning for Unclaimed
- ML model improvements beyond Random Forest (XGBoost, gradient boosting)
- uv migration (regulartim has DRAFT — could contribute to it or claim adjacent pieces)
- Any open issue without a linked PR in the 50 open issues list

### OCF — pvnet is the Key
- pvnet repo: 49 stars, 14 open issues, much lower competition than quartz-solar-forecast
- CI speed (20 min issue) — nobody has fixed it
- Live model evaluation — nobody touching this

---

## Narrative for Every Proposal

### The "Why I'll Succeed" Section (Adapt Per Org)

> In the past week I contributed to 13 repositories including huggingface/transformers (merged) and prowler-cloud/prowler (merged), demonstrating I can navigate large, unfamiliar codebases and deliver working fixes under time pressure. I am now focused on [org] specifically because [specific technical reason]. I've already contributed PRs #X, #Y, #Z in the past [N] days, including [most relevant one].

### Strengths to Emphasize
- **huggingface/transformers merge** — flagship Python ML library, directly relevant to any ML-track GSoC
- **prowler-cloud/prowler merge** — security-focused, directly relevant to GreedyBear and VulnerableCode security tracks
- **84 unique repos** in one week — demonstrates ability to ramp fast on unfamiliar codebases
- **lattice** (multi-agent framework), **spectra** (RAG eval), **aegis** (intelligence platform) — all directly relevant to AI/ML GSoC tracks

---

## Files in This Repo

| File | Purpose |
|------|---------|
| `README.md` | This file — master strategy |
| `OUTREACH_STRATEGY.md` | Per-project outreach: channels, mentors, message templates, timing |
| `AI_CONTRIBUTION_ENGINE.md` | How to use Claude to generate 2–3 PRs/day without sacrificing quality |
| `COMPETITOR_ANALYSIS.md` | Intelligence on all active competitors |
| `REPO_INTELLIGENCE.md` | Deep-dive: merge rates, open issues, core team |
| `GITHUB_ANALYSIS.md` | Zakir's contribution profile analysis |
| `CONTRIBUTION_PLAYBOOK.md` | General speed-PR tactics |
| `01-accord-project/` | Accord Project files |
| `02-dora-rs/` | dora-rs files |
| `03-honeynet-greedybear/` | GreedyBear files |
| `04-aboutcode-vulnerablecode/` | VulnerableCode files |
| `05-open-climate-fix/` | OCF files |

---

**Last Updated:** March 19, 2026
**Intelligence Source:** GITHUB_ANALYSIS.md, REPO_INTELLIGENCE.md, COMPETITOR_ANALYSIS.md (all generated March 19)
