# GSoC 2026 Competitor Intelligence Sweep
**Sweep Date:** 2026-03-19
**Window:** Last 30 days (2026-02-17 → 2026-03-19)
**Methodology:** Live gh CLI checks — recent PRs by non-maintainers, GSoC-labeled issues, merge velocity, maintainer response rates

---

## TL;DR — What Changed

> Several "hidden gems" have been **overrun by GSoC applicants**, a few are **not even in GSoC 2026**, and a small cluster remain genuinely quiet. Here's the real picture.

**Eliminated from consideration:**
- ❌ **Internet Health Report** — Explicitly states "IHR won't be taking part in GSoC 2026"
- ❌ **DBpedia** — No GSoC activity since 2020; their GSoC repo only goes to 2020
- ❌ **Conversations.im** — Repo at `iNPUTmice/Conversations` returns 404 (moved to Codeberg/F-Droid infra)
- ❌ **Software Heritage** — Uses Phabricator/Gitea, not GitHub; no actionable PR signal

**Surprise RED flags** (repos we thought were quiet but aren't):
- 🔴 **APIdash** — 13+ literal GSoC proposal PRs submitted as docs ("Proposal: [GSOC 2026]...")
- 🔴 **Mesa-LLM** — 30 PRs from 16 unique users in 30 days, completely overrun
- 🔴 **gprMax** — 28 PRs from 15 users in 30 days, but **ZERO merged** — maintainers appear unresponsive

**Quiet repos that remain genuinely low-competition:**
- ✅ **OpenClimatefix (pvnet + quartz)** — 1–3 PRs, active maintainers
- ✅ **Flux.jl** — 0 external PRs; only 1 person mentioned GSoC interest
- ✅ **LPython** — 4 PRs from 1–2 users (caution: maintainer slow to merge since Dec 2025)

---

## Full Ranked Table — All Projects (Lowest Competition First)

| Rank | Repo | Recent External PRs | Unique External Users | Likely GSoC Applicants | Maintainer Response | GSoC Label/Signals | Verdict |
|------|------|--------------------|-----------------------|------------------------|---------------------|--------------------|---------|
| 1 | **FluxML/Flux.jl** | 0 external (5 total, all maintainer) | 0 | 1 (GSoC interest issue only) | Active daily | None; 1 GSoC interest issue | 🟢 GREEN |
| 2 | **openclimatefix/pvnet** | 1 | 1 | 0 confirmed | Active | None | 🟢 GREEN |
| 3 | **openclimatefix/quartz-solar-forecast** | 3 | 2 | 0–1 | Active, merging | None | 🟢 GREEN |
| 4 | **lcompilers/lpython** | 4 | 2 (ekMartian dominant) | 1 | ⚠️ Slow — last merge Dec 2025 | None | 🟡 YELLOW |
| 5 | **AOSSIE-Org** | 0 | 0 | 0 | Unknown | Historically participates | 🟡 YELLOW |
| 6 | **CircuitVerse/CircuitVerse** | 23 | 12 | 3–5 | Moderate | None | 🟡 YELLOW |
| 7 | **keploy/keploy** | ~10 external | 5 ext. + core team | 2–3 | Very active (core team fast) | GSoC-labeled issues open | 🟡 YELLOW |
| 8 | **gprMax/gprMax** | 28 | 15 | 8–10 | 🚫 ZERO merges in 30 days | None | 🔴 RED / ⚠️ DEAD |
| 9 | **dora-rs/dora** | 30 | 7 | 2–3 power users | Active (phil-opp merging) | None | 🔴 RED |
| 10 | **aboutcode-org/vulnerablecode** | 30 | 9 | 5–7 | Active | gsoc-labeled issues | 🔴 RED |
| 11 | **accordproject/cicero** | 14 | 15 | 6–8 | Active | None | 🔴 RED |
| 12 | **accordproject/concerto** | 12 | 7 | 4–6 | Active | None | 🔴 RED |
| 13 | **accordproject/template-playground** | 17+ open | 10+ | 6–9 | Active | None | 🔴 RED |
| 14 | **laurent22/joplin** | 24 | 16 | 4–6 | Active (personalizedrefrigerator) | None (no labels) | 🔴 RED |
| 15 | **honeynet/GreedyBear** | 22+ | 19 | 10–13 | Very active, fast merges | None (but Honeynet is GSoC org) | 🔴 RED |
| 16 | **projectmesa/mesa** | 30 | 20 | 6–8 | Active | 1 PR titled "(GSoC 2026)" | 🔴 RED |
| 17 | **projectmesa/Mesa-LLM** | 30 | 16 | 12–15 | Slow (1 merge in 30 days) | Implicit via mesa org | 🔴 RED |
| 18 | **RocketChat/Rocket.Chat** | 30 | 15+ | 5–8 | Active, enterprise cadence | None | 🔴 RED |
| 19 | **foss42/apidash** | 30 | 22 | **13+ explicit proposals** | Active | 13 PRs titled "[GSOC 2026]" | 🔴🔴 EXTREME |
| — | **InternetHealthReport** | 0 | 0 | 0 | N/A | **NOT in GSoC 2026** | ❌ ELIMINATED |
| — | **dbpedia/gsoc** | 0 | 0 | 0 | N/A | Last GSoC: 2020 | ❌ ELIMINATED |
| — | **iNPUTmice/Conversations** | N/A | N/A | N/A | N/A | Repo 404 (moved to Codeberg) | ❌ ELIMINATED |
| — | **SoftwareHeritage** | 0 | 0 | 0 | N/A | Uses Phabricator, not GitHub | ❌ ELIMINATED |

---

## Detailed Per-Repo Breakdown

### 🟢 FluxML/Flux.jl — LOWEST COMPETITION
- **30-day PRs:** 5 total, all by `CarloLucibello` (core maintainer)
- **External contributors:** 0 external PRs
- **GSoC signal:** 1 open issue titled "GSoC 2026 Interest: RL Environments Project" by `ram-cs7` (Mar 17)
- **Maintainer response:** Merges happen same-day
- **Risk:** Julia is niche; need to verify Flux.jl is listed in NumFOCUS/JuliaLang's GSoC orgs for 2026
- **Verdict:** Ghost town right now. One person has staked a claim on RL Environments — avoid that specific project. Everything else is open.

---

### 🟢 openclimatefix/pvnet — NEAR-ZERO COMPETITION
- **30-day PRs:** 1 PR (spelling correction by `albedo-c`)
- **External contributors:** 1 user, 1 trivial PR
- **GSoC signal:** None
- **Maintainer response:** Active org (quartz-solar-forecast had recent merges)
- **Verdict:** Genuinely untouched. OpenClimatefix is a solid GSoC org. Strong opportunity for a focused contributor.

---

### 🟢 openclimatefix/quartz-solar-forecast — LOW COMPETITION
- **30-day PRs:** 3 PRs (2 users: `danishdynamic`, `CodeVishal-17`)
- **External contributors:** 2 users
- **GSoC signal:** None
- **Maintainer response:** Both PRs were merged — maintainers responsive
- **Note:** `Open-Source-Quartz-Solar-Forecast` is the same project as `quartz-solar-forecast`; same 3 PRs appear in both
- **Verdict:** Very quiet. 2 contributors with simple refactors/additions. No GSoC-style feature campaigns.

---

### 🟡 lcompilers/lpython — LOW BUT RISKY
- **30-day PRs:** 4 PRs from 2 users (`ekMartian`: 3 PRs, `amritamishra01`: 1 PR)
- **External contributors:** 2 users, modest overlap
- **GSoC signal:** None
- **Maintainer response:** ⚠️ Last merge was **December 11, 2025** — 3+ months of silence
- **Risk factors:** `ekMartian` has 3 open PRs still unreviewed. Maintainer `swamishiju` last active Dec 2025. Could be dormant period or pre-release freeze.
- **Verdict:** Competition is minimal but maintainer inactivity is a red flag. Verify LPython's GSoC 2026 participation before investing time.

---

### 🟡 CircuitVerse/CircuitVerse — MODERATE, MANAGEABLE
- **30-day PRs:** 23 PRs from 12 unique users
- **External contributors:** Key repeat contributors: `palakvishwakarma44` (5 PRs), `naman79820` (2 PRs — building Avo admin features)
- **GSoC signal:** No labels, but CircuitVerse is a historical GSoC org
- **Maintainer response:** Moderate — some PRs merging (`Omkar-Wagholikar` merging)
- **Verdict:** Higher than ideal, but not the insanity of APIdash or Mesa-LLM. If targeting CircuitVerse, go for technically complex features (subgroup support, FSM editor) rather than UI tweaks.

---

### 🟡 keploy/keploy — ACTIVE CORE TEAM, SOME EXTERNAL
- **30-day PRs:** ~30 total, ~10 external
- **External contributors:** `furkankoykiran` (4 PRs), `AuraReaper` (1 PR), `officialasishkumar` (appears to be core team)
- **GSoC signal:** 20 open gsoc-labeled issues — **Keploy runs an organized GSoC program**
- **Maintainer response:** Very fast — `ayush3160`, `kapishupadhyay22`, `AkashKumar7902` merging same-day
- **Verdict:** Organized GSoC program means they know what they want. Competition exists but PRs getting merged. If you engage, target the labeled GSoC issues directly and communicate with mentors.

---

### 🔴 ⚠️ gprMax/gprMax — CROWDED + MAINTAINER DEAD
- **30-day PRs:** 28 PRs from 15 unique users
- **External contributors:** `SouravVerma-art` (6 GPU perf PRs), `subhamkumarr` (4 CI/infra PRs), `ellatso`, `kallal79`, `SIRILEKKALA`, `has9sayed`, `mohanakatari119-bit`, etc.
- **Merges in 30 days:** **ZERO external PRs merged**
- **Maintainer response:** 🚨 No merges in 30 days despite 28 open PRs. Comments field returning null. Maintainers appear completely unresponsive.
- **Verdict:** Trap. High competition + unresponsive maintainers = wasted effort. All these contributors are submitting PRs into a void. **Avoid until maintainers re-engage.**

---

### 🔴 dora-rs/dora — POWER USER DOMINATING
- **30-day PRs:** 30 PRs from 7 unique users
- **External contributors:** `Bhanudahiyaa` — **12 PRs in 30 days**, all substantial features (coordinator KV store, CLI registry, file-backed state persistence, OpenTelemetry, build validation). This person is attempting to single-handedly claim the GSoC slot.
- **Other notable:** `PavelGuzenfeld` (c++ zero-copy + dynamic init — appears semi-core), `ashnaaseth2325-oss` (3 panic fixes), `Monti-27` (1 merge)
- **Maintainer response:** Active — `phil-opp` merging regularly
- **Verdict:** `Bhanudahiyaa` is running a coordinated campaign. Unless you can outwork 12 PRs in 30 days, this slot is being claimed. **Avoid unless you have a very specific angle they haven't covered.**

---

### 🔴 aboutcode-org/vulnerablecode — ORGANIZED ATTACK
- **30-day PRs:** 30 PRs from 9 users
- **External contributors:** `NucleiAv` (7 PRs — systematic importer additions: CheckPoint, Eclipse, LibreOffice, Collabora, Alpine, ZDI, Grafana), `Tednoob17` (4 PRs), `Dhirenderchoudhary` (3 PRs), `ziadhany` (2 PRs), `malladinagarjuna2` (1 PR), `Samk1710` (1 PR)
- **GSoC signal:** Has gsoc-labeled issues including "VulnerableCode Insights" and "notification system"
- **Maintainer response:** Active, `keshav-space` and `TG1999` merging regularly
- **Verdict:** `NucleiAv` alone has 7 PRs in 30 days and appears to be systematically building a portfolio. High-volume, organized competition.

---

### 🔴 Accord Project (cicero + concerto + template-playground) — OVERRUN
- **cicero 30-day PRs:** 14 PRs, 15 unique users
- **concerto 30-day PRs:** 12 PRs, multiple users
- **template-playground 30-day PRs:** 17+ open PRs, 10+ users
- **Notable contributors:** `yashhzd` (active in both cicero AND Mesa-LLM), `Satvik77777` (5 PRs in template-playground), `hemantch01` (multiple repos)
- **Maintainer response:** Active, merging regularly
- **Verdict:** The entire Accord ecosystem is saturated with GSoC applicants. Not "hidden gems" anymore.

---

### 🔴 honeynet/GreedyBear — MOST USERS
- **30-day PRs:** 22+ PRs from **19 unique users** — highest user count of any repo checked
- **External contributors:** Every single PR is from a different person; no single user dominates
- **Maintainer response:** Very fast — multiple merges per day, consistent engagement
- **Verdict:** The breadth (19 distinct users) is worse than dora-rs's depth. Even if no single competitor is dominant, the signal-to-noise ratio for your PR getting noticed is poor.

---

### 🔴🔴 foss42/apidash — EXTREME: GSoC PROPOSALS AS PRs
- **30-day PRs:** 30 from 22 unique users
- **GSoC proposals as PRs (literally):**
  - `AshutoshSharma-pixel`: "docs: GSoC 2026 idea doc — CLI & MCP Support"
  - `alaotach`: "docs(idea): WebSocket, MQTT & gRPC [GSoC 2026]"
  - `souvikDevloper`: "Proposal: [GSOC 2026] MCP Testing Suite"
  - `adityasuhane-06`: "docs(gsoc): add initial idea submission - Agentic API Testing"
  - `Bhavesh-More`: "docs(gsoc): initial idea submission for CLI & MCP Support"
  - `MustafaEnes123`: "Create GSoC application for MCP Testing and Security"
  - `ShashwatXD`: "Update idea doc."
  - `DeepBuha06`: "GSoC-2026 proposal: VS code extension for APIDASH"
  - `TheAnshulPrakash`: "[doc] Updated Idea Proposal for Agentic API Testing"
  - `mohamedahmedsalah002`: "docs: add GSoC microservices idea documentation"
  - `Manar-Elhabbal7`: "[Proposal] GSoC'26 CLI & MCP support proposal"
  - `avinavverma`: "docs: Add GSoC 2026 Initial Idea Submission - API Automation"
  - `MariamKhoKh`: "Add GSoC application for multimodal eval framework"
- **Verdict:** 🚨 This is not a competition — it's a war. **Do not apply here.**

---

## Competitor Profiles — Active Threats

### 🎯 Bhanudahiyaa (dora-rs/dora)
- **12 PRs in 30 days** — all substantive features
- **Strategy:** Building the entire coordinator state management layer (KV store, TTL, file persistence, OpenTelemetry, CLI registry)
- **Threat level:** Very high — clearly targeting a specific GSoC slot with a coherent feature arc
- **Counter-strategy:** Only viable if you identify a *different* project within dora-rs that this person hasn't touched

### 🎯 NucleiAv (aboutcode-org/vulnerablecode)
- **7 PRs in 30 days** — systematic security advisory importer additions
- **Strategy:** "Importer collector" approach — one PR per advisory source (CheckPoint, Eclipse, LibreOffice, Collabora, Alpine, ZDI, Grafana)
- **Threat level:** High — fast execution, each PR is meaningful but formulaic
- **Counter-strategy:** Target the API/UI improvement side of vulnerablecode (the `ziadhany` space) rather than importers

### 🎯 SouravVerma-art (gprMax/gprMax)
- **6 PRs in 30 days** — GPU/CUDA performance focus
- **Strategy:** Systematic GPU kernel optimization (update_e/update_h splitting, memory coalescing, source info SoA)
- **Threat level:** Medium — but none of his PRs are being merged (maintainer dead)
- **Counter-strategy:** N/A — the entire gprMax effort is currently futile

### 🎯 yashhzd (cicero + Mesa-LLM)
- **Cross-org contributor** — 2+ PRs in cicero (DEFLATE, circular inheritance), 2+ PRs in Mesa-LLM
- **Strategy:** Spread contributions across multiple projects to maximize chance of one GSoC acceptance
- **Threat level:** Medium — no single project dominance but broad coverage
- **Counter-strategy:** Beat them on depth in whichever project you choose

### 🎯 Satvik77777 (accordproject/template-playground)
- **5 PRs in 30 days** in template-playground — AGENTS.md, TypeScript types, theme fixes, Zustand selectors
- **Strategy:** Systematic code quality + docs improvement campaign
- **Threat level:** High within template-playground specifically

### 🎯 adarshkumar23 (projectmesa/Mesa-LLM)
- **5 PRs in 30 days** — Stock Market model, Fake News model, async fixes, speak_to fix
- **Strategy:** Adding example models + fixing async bugs in Mesa-LLM
- **Threat level:** High — active, varied contributions

### 🎯 oindridebmallick (projectmesa/mesa)
- **1 PR** but titled "Refactor discrete space cell agents to use AgentSet **(GSoC 2026)**"
- **Threat level:** Direct — explicitly marking their work for GSoC review

---

## REVISED TOP 5 — Based on Real Data

| Rank | Project | Why It Wins Now |
|------|---------|-----------------|
| 🥇 1 | **openclimatefix/pvnet** | 1 external PR (spelling fix), active org, legitimate GSoC participant, clear ML/solar forecasting domain |
| 🥈 2 | **openclimatefix/quartz-solar-forecast** | 3 PRs from 2 users, both merged (responsive maintainers), same strong org |
| 🥉 3 | **FluxML/Flux.jl** | 0 external competition; 1 GSoC interest issue (RL Environments) means 1 person to beat on all other projects |
| 4 | **AOSSIE-Org** | 0 PRs on GitHub in 30 days; historically active GSoC org — verify 2026 participation first |
| 5 | **CircuitVerse/CircuitVerse** | 23 PRs but manageable; avoid UI tweaks, target complex backend features (subgroups, FSM editor) |

**Honorable mention:** `lcompilers/lpython` — near-zero competition but maintainer has been silent since Dec 2025. Viable if you can confirm they're in GSoC 2026 and maintainers are still responsive to proposals.

---

## Action Items

1. **OpenClimatefix** — Start contributing to `pvnet` immediately. Read the codebase, find an open issue, submit a meaningful PR this week. Target ML model improvements or dataset pipeline work, not typos.

2. **Flux.jl** — Confirm JuliaLang/NumFOCUS is a 2026 GSoC org. If yes, stake a claim on a project *other than* RL Environments (already claimed by `ram-cs7`). Timing-sensitive.

3. **Avoid gprMax** — 28 PRs, 0 merges. This is a contributor graveyard right now. Do not invest time until maintainers show signs of life.

4. **Avoid APIdash entirely** — 13 literal GSoC proposal PRs. You'd need to outcompete a dozen people who are already deep in the proposal process.

5. **Dora-rs** — Only worth it if you can find a project area `Bhanudahiyaa` hasn't touched. Check their GSoC ideas page for slots that person isn't covering.

---

*Generated via live `gh` CLI sweep. All PR counts reflect the 30-day window 2026-02-17 to 2026-03-19.*
