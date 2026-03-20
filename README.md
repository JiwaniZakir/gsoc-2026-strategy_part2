# GSoC 2026 — Verified Top 5 Strategy (v3)

**Zakir Jiwani** | [GitHub: JiwaniZakir](https://github.com/JiwaniZakir) | jiwzakir@gmail.com

**Status:** EXECUTING — Blitz started March 20. Proposals submit March 24.
**Mode:** AI-augmented output — 2–3 PRs per day per active project, Claude writes code/tests/docs simultaneously.

---

## The Verified Top 5 — All Confirmed GSoC 2026, All 175h

All five picks have been verified as confirmed GSoC 2026 projects. Previous picks
(numpyro, prowler, kolibri) were removed after verification showed they are NOT in
GSoC 2026 under their respective orgs.

| Rank | Project | Org | Size | Zakir's Edge |
|------|---------|-----|------|-------------|
| 🥇 1 | **IntelOwl LLM Chatbot** | Honeynet Project | 90–175h | LangChain x4 PRs, LangGraph x5 PRs, Django production, security domain |
| 🥈 2 | **sbi: Azula Diffusion Sampling** | NumFOCUS | 175h | PyTorch (transformers PRs), probabilistic ML |
| 🥉 3 | **sbi: DataLoader Support** | NumFOCUS | 175h | PyTorch DataLoader patterns, data pipeline experience |
| 4 | **GreedyBear Event Collector API** | Honeynet Project | 175–350h | Python/Django, security, same org as #1 |
| 5 | **AOSSIE PictoPy** | AOSSIE | ~175h | CLIP/FAISS, FastAPI, transformers background |

**GitHub repos:**
- IntelOwl: https://github.com/intelowlproject/IntelOwl
- sbi: https://github.com/sbi-dev/sbi
- GreedyBear: https://github.com/intelowlproject/GreedyBear
- PictoPy: https://github.com/AOSSIE-Org/PictoPy

---

## Why the Previous Top 5 Was Wrong

| Old Pick | Problem |
|----------|---------|
| numpyro (#1) | NOT in NumFOCUS GSoC 2026 — verified |
| kolibri (#2) | Removed from consideration |
| prowler (#3) | NOT in GSoC 2026 — verified |
| AOSSIE Agora (#4) | Agora = Scala. Wrong language. Replaced with PictoPy (Python AI) |
| GreedyBear (#5) | Still in — promoted to #4, updated idea to Event Collector API |

**New #1 is IntelOwl LLM Chatbot** — the single highest-fit project in the field for Zakir.
No other applicant has LangChain PRs + LangGraph PRs + security + Django production together.

---

## Priority Rationale

### IntelOwl LLM Chatbot (#1) — perfect tech stack match
Zakir has 4 merged LangChain PRs and 5 merged LangGraph PRs. The GSoC project is literally
"build a LangChain chatbot." The overlap is complete. Lead every message with this.

### sbi Azula (#2) — clean scope, PyTorch-native
Integrate Azula diffusion models into sbi's inference pipeline. Zakir's transformers
experience establishes PyTorch credibility. Well-defined 175h scope.

### sbi DataLoader (#3) — same org as #2, orthogonal work
Adds DataLoader/HDF5/zarr support for large-scale training in sbi. Backend engineering
problem. Proven pattern from Zakir's transformers work. Same contributions to sbi help both proposals.

### GreedyBear (#4) — same org as #1
Honeynet Project contributions to GreedyBear and IntelOwl strengthen both proposals.
Same community (honeynet.slack.com), same maintainer (Matteo Lodi), same CI rules (Ruff).

### PictoPy (#5) — Python AI, confirmed org
AOSSIE is confirmed GSoC 2026. PictoPy uses CLIP, FAISS, FastAPI — all in Zakir's wheelhouse.
**Verify PictoPy has a slot on the AOSSIE wiki before investing heavily.**

---

## Org Overlap Strategy

Two projects share the same Honeynet org:
- **IntelOwl (#1)** and **GreedyBear (#4)** — same Slack, same maintainers
- Every contribution to either project helps both proposals
- Join honeynet.slack.com once, establish presence with maintainers, reference both repos

Two projects share the same NumFOCUS/sbi repo:
- **sbi Azula (#2)** and **sbi DataLoader (#3)** — same GitHub repo, same reviewers
- First good-first-issue PR is shared between both
- Apply to only ONE as primary GSoC proposal (Azula recommended unless mentor signals otherwise)

---

## Daily PR Targets (Mar 20–24)

| Day | IntelOwl | sbi (both) | GreedyBear | PictoPy | Daily Total |
|-----|----------|-----------|-----------|---------|------------|
| Mar 20 | 1 PR | 1 PR | 1 PR | 1 PR | 4 |
| Mar 21 | 2 PRs | 2 PRs | 1 PR | 2 PRs | 7 |
| Mar 22 | 2 PRs | 2 PRs | 2 PRs | 2 PRs | 8 |
| Mar 23 | 1 PR | 1 PR | 1 PR | 1 PR | 4 |
| Mar 24 | 1 PR | 1 PR | 1 PR | 1 PR | 4 |
| **TOTAL** | **7** | **7** | **6** | **7** | **27** |

**Target: 27 PRs across 5 projects, 5 proposals submitted by March 24.**

---

## Zakir's Proof Points (Use in Every Proposal)

| Proof Point | Relevance |
|------------|-----------|
| LangChain — 4 merged PRs | IntelOwl chatbot direct match |
| LangGraph — 5 merged PRs | IntelOwl chatbot agent architecture |
| huggingface/transformers (merged) | PyTorch + large codebase credibility |
| prowler-cloud/prowler (merged) | Security domain + Python |
| aegis (intelligence platform, 338 tests) | Production Django + Celery + FastAPI |
| sentinel (Slack bot, 209 tests) | Node.js production code |
| spectra (RAG eval toolkit) | RAG design, embedding evaluation |
| lattice (multi-agent framework) | Python system design, agent frameworks |
| graphrag — 3 PRs | Graph-based retrieval (FAISS overlap for PictoPy) |
| DSPy — experience | Probabilistic ML, structured prediction |

---

## What Was Removed and Why

| Removed | Reason |
|---------|--------|
| `01-numpyro/` | NOT in NumFOCUS GSoC 2026 — verified |
| `02-kolibri/` | Not in verified top 5 |
| `03-prowler/` | NOT in GSoC 2026 — verified |
| AOSSIE Agora focus | Agora = Scala (wrong language). Replaced with PictoPy. |

---

## Files in This Repo

| File / Directory | Purpose |
|-----------------|---------|
| `README.md` | This file — master strategy (v3, updated March 20) |
| `OUTREACH_STRATEGY.md` | Per-project outreach with channels, mentors, message templates |
| `AI_CONTRIBUTION_ENGINE.md` | How to use Claude for 2–3 PRs/day |
| `COMPETITOR_ANALYSIS.md` | Intelligence on active competitors |
| `REPO_INTELLIGENCE.md` | Deep-dive: merge rates, open issues |
| `GITHUB_ANALYSIS.md` | Zakir's contribution profile analysis |
| `CONTRIBUTION_PLAYBOOK.md` | General speed-PR tactics |
| **`01-intelowl-chatbot/`** | IntelOwl LLM Chatbot — **#1 pick** — Honeynet |
| **`02-sbi-azula/`** | sbi Azula Diffusion Sampling — **#2 pick** — NumFOCUS |
| **`03-sbi-dataloader/`** | sbi DataLoader Support — **#3 pick** — NumFOCUS |
| **`04-greedybear/`** | GreedyBear Event Collector API — **#4 pick** — Honeynet |
| **`05-aossie-pictopy/`** | AOSSIE PictoPy — **#5 pick** — AOSSIE |

Each project directory contains:
- `README.md` — Org overview, GSoC ideas, mentors, tech stack, community channels
- `CONTRIBUTION_PLAN.md` — Aggressive 5-day PR plan with exact commands
- `ENGAGEMENT_GUIDE.md` — Day-by-day outreach with exact message templates
- `PROPOSAL_DRAFT.md` — Near-final GSoC proposal tailored to Zakir's profile
- `ARCHITECTURE.md` — Codebase structure, key modules, build/test commands

---

**Last Updated:** March 20, 2026
**Previous strategy:** git history — old top 5 was numpyro, kolibri, prowler, AOSSIE Agora, GreedyBear
**Verification source:** Direct GSoC 2026 organization pages + project idea lists
