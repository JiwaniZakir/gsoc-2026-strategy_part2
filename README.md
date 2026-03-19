# GSoC 2026 — 5-Day Contribution Blitz

**Zakir Jiwani** | [GitHub: JiwaniZakir](https://github.com/JiwaniZakir) | jiwzakir@gmail.com

**Status:** EXECUTING — Blitz started March 19. Proposals submit March 24.

---

## Rejected Candidates: Why We Cut Mesa-LLM, OWASP FinBot, C2SI

Before the blitz began, three additional orgs were evaluated and cut:

| Candidate | Reason Rejected |
|-----------|----------------|
| **Mesa-LLM** | 15–30 applicants for 2 slots — top applicants have existing maintainer relationships. Competitive landscape is brutal relative to our other 5. |
| **OWASP FinBot** | Massive brand recognition drives flood applicants. 15 total slots with hundreds applying. Ruff/Django overlap means our edge isn't differentiated enough. |
| **C2SI** | Poor skill match — their open projects skew toward web scraping and Sri Lanka–specific data pipelines. Our Rust/ML/AI profile doesn't translate cleanly. |

**Decision: Keep the original top 5. No changes to target list.**

---

## The 5 Targets (Unchanged)

| Priority | Organization | Project | Stack | Difficulty |
|----------|--------------|---------|-------|-----------|
| 1 | **Accord Project** | MCP Server Hardening | TypeScript, MCP | Medium |
| 2 | **dora-rs** | Testing Infrastructure | Rust, Python | Medium |
| 3 | **Honeynet/GreedyBear** | Event Collector API | Python, Django, DRF | Medium |
| 4 | **AboutCode/VulnerableCode** | NLP/ML Detection | Python, NLP, ML | Medium |
| 5 | **Open Climate Fix** | Quartz Solar API | Python, React, ML | Medium |

---

## 5-Day Blitz: March 19–23

**Proposals submit: March 24 (hard deadline)**

---

### Day 1 — March 19: Land & Setup

**Goal:** First PR submitted to Accord + dora-rs. All 5 environments running. All 5 Discord intros posted.

| Time | Action |
|------|--------|
| 08:00–09:00 | Clone all 5 repos if not done. Verify builds pass locally. |
| 09:00–10:00 | Scan Accord Project techdocs issues — identify first PR target. Write the fix. |
| 10:00–11:00 | Submit PR #1 to Accord (techdocs fix or template-playground bug). |
| 11:00–12:00 | Post intro in Accord Discord `#technology-cicero`. Reference your PR immediately. |
| 12:00–13:00 | Scan dora-rs `label:good-first-issue` / `label:documentation`. Claim one. |
| 13:00–14:30 | Submit PR #1 to dora-rs (docs clarification or example improvement). |
| 14:30–15:00 | Post intro in dora-rs Discord `#gsoc-2026`. |
| 15:00–16:00 | GreedyBear: Run `./gbctl init --dev --elastic-local`. Find issue #1083 or #1089. Claim. |
| 16:00–17:00 | VulnerableCode: Sign DCO. Find first `good-first-issue`. Post claim comment. |
| 17:00–18:00 | Open Climate Fix: Set up env. Find first issue. Comment claim. |
| 18:00–19:00 | Post intro messages to all 3 remaining community channels. |
| 19:00–21:00 | Write draft skeleton for all 5 proposals (title, synopsis, 3 bullet deliverables). |

**Day 1 exit criteria:** 2 PRs submitted, 5 community intros posted, all envs running.

---

### Day 2 — March 20: PRs Everywhere

**Goal:** PR submitted to all 5 projects. Start engaging in code review discussions.

| Time | Action |
|------|--------|
| 08:00–09:00 | Check Accord + dora-rs PR status. Respond to any feedback within the hour. |
| 09:00–11:00 | Submit PR #2 to Accord (template-playground bug fix or template-engine test). |
| 11:00–12:00 | Submit PR #1 to GreedyBear (session_id fix or feeds filter). Draft PR immediately. |
| 12:00–13:30 | Submit PR #1 to VulnerableCode (test improvement or documentation fix). |
| 13:30–15:00 | Submit PR #1 to Open Climate Fix (test fix, type annotation, or docs). |
| 15:00–16:00 | Post technical question to each mentor in relevant channels. Make it specific — reference a file and line number. |
| 16:00–18:00 | Review and leave comments on 2–3 open PRs in any of the 5 repos (show community presence). |
| 18:00–21:00 | Write full Problem Statement + Technical Approach sections for top 2 proposals (Accord, dora-rs). |

**Day 2 exit criteria:** PR in all 5 repos, technical engagement started, 2 proposals 50% drafted.

---

### Day 3 — March 21: Substance

**Goal:** More complex PRs. Mentors start knowing your name. Proposals 80% complete.

| Time | Action |
|------|--------|
| 08:00–09:00 | Address all PR feedback received. Respond to every comment within minutes. |
| 09:00–11:30 | Submit PR #3 to Accord (MCP server: add a system test or error handling improvement). |
| 11:30–13:00 | Submit PR #2 to dora-rs (code contribution — improve existing test or add one). |
| 13:00–14:30 | Submit PR #2 to GreedyBear (larger: cronjob exception handling or training data export). |
| 14:30–15:00 | Post week progress summary in each Discord channel. |
| 15:00–17:00 | Ask at least one mentor per project for specific proposal feedback — share your draft outline. |
| 17:00–21:00 | Complete all 5 proposals to 80% — Timeline + Deliverables + About Me sections done. |

**Day 3 exit criteria:** 3 PRs merged or in review across multiple repos, mentors engaged, proposals 80% done.

---

### Day 4 — March 22: Polish & Write

**Goal:** Contribution record polished. Proposals near-final. Mentor feedback incorporated.

| Time | Action |
|------|--------|
| 08:00–09:00 | Address outstanding PR feedback. Bump any PRs open >48h with polite message. |
| 09:00–10:00 | Submit PR #2 to VulnerableCode (more substantial NLP/test improvement). |
| 10:00–11:00 | Submit PR #2 to Open Climate Fix (actual code — error handling, test, or docs). |
| 11:00–13:00 | Do final polish pass on all PRs — update descriptions, link issues, verify CI green. |
| 13:00–15:00 | Post proposal drafts (even as GitHub Gists) to relevant Discord channels. Ask for explicit feedback. |
| 15:00–18:00 | Write/refine the "Why This Project" and "About the Applicant" sections for all 5 proposals. Make them personal and specific. |
| 18:00–21:00 | Finalize proposals 1–3 (Accord, dora-rs, GreedyBear). Submit-ready quality. |

**Day 4 exit criteria:** Proposals 1–3 submit-ready. 8+ total PRs across all repos.

---

### Day 5 — March 23: Finish Line

**Goal:** All 5 proposals submit-ready. Community feedback incorporated. Submission queued.

| Time | Action |
|------|--------|
| 08:00–10:00 | Finalize proposals 4–5 (VulnerableCode, Open Climate Fix). |
| 10:00–11:00 | Final pass on all 5 proposals: Check deliverables, timeline specifics, formatting. |
| 11:00–12:00 | Incorporate any overnight Discord/GitHub feedback into proposals. |
| 12:00–14:00 | Read each proposal cold. Trim anything vague. Make deliverables crisp. |
| 14:00–16:00 | Submit all 5 proposals to GSoC platform (or stage for March 24 submission). |
| 16:00–18:00 | Post final contribution summary in each community channel. Thank mentors. |
| 18:00+ | Keep watching PRs. Merge feedback = engagement signal for evaluators. |

**Day 5 exit criteria:** All proposals submitted. Every community channel has seen your name ≥3 times.

---

### March 24: Submit Day

- Cross-check all 5 proposals on GSoC portal for completeness.
- Verify all contribution links are live and visible in each proposal.
- Submit by EOD if not done March 23.
- Continue engaging with any open PRs.

---

## Profile Summary

**Zakir Jiwani — GitHub: JiwaniZakir**

- **AI/ML:** Transformers, LangChain, LangGraph, DSPy, GraphRAG, Ray
- **Python:** FastAPI, Celery, Django, pytest, debugging expert
- **Full-stack:** React, Vite, Node.js, TypeScript
- **DevOps:** Prowler, Helm, Argo CD, GitHub Actions, Docker
- **Rust:** Systems programming, hyperfine benchmarking
- **Open Source:** 6 active repos — aegis, sentinel, lattice, spectra, evictionchatbot, Partnerships_OS

---

## Project Directories

- [01 — Accord Project](./01-accord-project/)
- [02 — dora-rs](./02-dora-rs/)
- [03 — Honeynet/GreedyBear](./03-honeynet-greedybear/)
- [04 — AboutCode/VulnerableCode](./04-aboutcode-vulnerablecode/)
- [05 — Open Climate Fix](./05-open-climate-fix/)

See `CONTRIBUTION_PLAYBOOK.md` for speed-PR tactics and blitz-mode execution strategies.

---

**Last Updated:** March 19, 2026
**Status:** Day 1 of 5-day blitz
