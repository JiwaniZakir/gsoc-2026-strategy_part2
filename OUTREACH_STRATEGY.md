# Outreach Strategy — GSoC 2026 (v3)

> Updated March 20, 2026 — Verified top 5. Removed numpyro, kolibri, prowler.
> New projects: IntelOwl LLM Chatbot, sbi Azula, sbi DataLoader, GreedyBear, PictoPy.

---

## Master Outreach Calendar

| Day | IntelOwl (#1) | sbi (#2/#3) | GreedyBear (#4) | PictoPy (#5) |
|-----|--------------|------------|----------------|-------------|
| Mar 20 | Slack intro + PR #1 | GitHub Discussions intro + PR #1 | Slack intro + PR #1 | Gitter intro + PR #1 |
| Mar 21 | Claim issue, PR #2 | Comment on draft Azula PR | Claim #1087 | Comment on PictoPy issue |
| Mar 22 | Proposal outline in Discussions | Proposal preview post | Proposal outline on Slack | Proposal outline in Gitter |
| Mar 23 | DM Matteo Lodi | DM primary reviewer | Review open PR | DM AOSSIE admin |
| Mar 24 | Final summary post | Final summary | Final summary | Final summary |

---

## 1. IntelOwl LLM Chatbot (intelowlproject/IntelOwl) — Priority #1

**Org:** Honeynet Project | **Size:** 90–175h | **Confirmed GSoC 2026**

### Channels
| Channel | URL | Priority |
|---------|-----|---------|
| Slack | honeynet.slack.com (#gsoc, #intelowl) | **PRIMARY** |
| GitHub Discussions | https://github.com/intelowlproject/IntelOwl/discussions | Secondary |
| GitHub Issues | https://github.com/intelowlproject/IntelOwl/issues | Contributions |

### Day 1 — Slack Introduction

```
Hi Honeynet team,

I'm Zakir Jiwani (GitHub: JiwaniZakir), applying for GSoC 2026 — specifically
the IntelOwl LLM Chatbot project.

Why I'm a strong fit:
- 4 merged PRs in langchain-ai/langchain (the exact library for this project)
- 5 merged PRs in langchain-ai/langgraph (agent orchestration)
- Production Django + Celery (aegis intelligence platform, 338 tests)
- Merged PRs in prowler-cloud/prowler (security domain experience)
- RAG evaluation toolkit (spectra) — directly relevant to chatbot's RAG pipeline

I've set up IntelOwl locally and submitted my first PR: [link] — [brief description]

For GSoC, I'm planning a LangChain-based chatbot that:
- Queries IntelOwl's REST API for live threat intel data
- Uses RAG over analyzer documentation for grounded answers
- Streams responses to a React frontend widget

Who should I connect with about the GSoC mentorship for this project?

Zakir
```

**WHY THIS WORKS:** No other applicant has merged LangChain + LangGraph + security + Django PRs.
Open with the proof, not the ask.

### Key Issues to Reference (IntelOwl)
Search: https://github.com/intelowlproject/IntelOwl/issues?q=is%3Aopen+label%3A%22good+first+issue%22

### Mentor Targets
- **Matteo Lodi** (@mattebit) — PRIMARY, very responsive on Slack
- **Eshaan Bansal** (@eshaan7) — IntelOwl maintainer
- **Shubham Pandey** (@sp35) — IntelOwl contributor

---

## 2. sbi: Azula Diffusion Sampling (sbi-dev/sbi) — Priority #2

**Org:** NumFOCUS | **Size:** 175h | **Confirmed GSoC 2026**

### Channels
| Channel | URL | Priority |
|---------|-----|---------|
| GitHub Discussions | https://github.com/sbi-dev/sbi/discussions | **PRIMARY** |
| GitHub Issues | https://github.com/sbi-dev/sbi/issues | Contributions |

### Day 1 — GitHub Discussions Post

```
Subject: GSoC 2026 — Azula diffusion sampling integration — introduction

Hi sbi team,

I'm Zakir Jiwani (GitHub: JiwaniZakir), applying for GSoC 2026 — Azula integration.

Background: PyTorch experience from merged PRs in huggingface/transformers (100k+ line
Python codebase). Familiar with density estimators and probabilistic ML (DSPy, graphrag).

I've installed sbi and Azula locally, read through the NeuralPosterior interface,
and have a skeleton of AzulaFlowMatchingPosterior drafted.

Questions:
1. Should I start with DDPM sampling or flow matching, or both simultaneously?
2. Is FAISS the preferred approach for any ANN search needed, or do you use annoy?
3. Which benchmarks should I target first for the evaluation comparison?

First PR submitted: [link] — [description]

Zakir
```

### Key Issues to Reference
- GSoC idea issue (search sbi repo for "azula" or "gsoc")
- `good first issue` labeled issues

### Mentor Targets
- **Jan-Matthis Lueckmann** — sbi maintainer
- **Michael Deistler** — sbi contributor
- Check recent PR reviewers on sbi GitHub

---

## 3. sbi: DataLoader Support (sbi-dev/sbi) — Priority #3

**Org:** NumFOCUS | **Size:** 175h | **Same repo as #2**

### Outreach
**Same GitHub Discussions post as #2.** Mention both proposals in one thread, ask which
has more priority from the maintainer's perspective. Let their answer guide your primary application.

```
Note: I'm also exploring the DataLoader proposal (large-scale training support). Both
look valuable — is there one the team is more excited about for GSoC 2026?
```

**Apply to only ONE as your official GSoC submission.** Contributions to sbi count for both.

---

## 4. GreedyBear Event Collector API (intelowlproject/GreedyBear) — Priority #4

**Org:** Honeynet Project | **Size:** 175–350h | **Confirmed GSoC 2026**
**SAME ORG AS #1 — Honeynet Slack appearance counts for both**

### Channels
Same as IntelOwl: honeynet.slack.com (#greedybear or #gsoc)

### Day 1 — Slack Introduction (same Slack, different channel)

```
Hi Honeynet team,

Following up on my IntelOwl message — I'm also interested in the GreedyBear
Event Collector API project.

Background: Same as above (Python/Django, security). GreedyBear's Django/DRF stack
is exactly what I've been working in (aegis: 338 tests, production Django).

Submitted first PR to GreedyBear today: [link] — [description]
(Also have an open PR on IntelOwl: [link])

Is the Event Collector API the primary GSoC idea for GreedyBear this year?

Zakir
```

### ⚠️ GreedyBear Rules (Non-Negotiable)
1. **Ruff linting MANDATORY** — `ruff check .` must pass before every PR
2. **1 PR per issue** — never combine unrelated changes
3. **1-week ping rule** — if no review in 7 days, ping reviewer

### Key Issues to Reference
- #1085 — Cronjob exception propagation (easy first PR)
- #1087 — ML training data validation
- #1093 — Feeds sorting regression
- #1092 — Feed generation refactor

### Mentor Targets
- **Matteo Lodi** (@mattebit) — same as IntelOwl
- **Eshaan Bansal** — IntelOwl/GreedyBear maintainer

---

## 5. AOSSIE PictoPy — Priority #5

**Org:** AOSSIE | **Size:** ~175h (TBC) | **Confirmed GSoC 2026**

### Channels
| Channel | URL | Priority |
|---------|-----|---------|
| Gitter | https://gitter.im/AOSSIE/ | **PRIMARY** |
| GitHub Issues | https://github.com/AOSSIE-Org/PictoPy/issues | Contributions |
| GitLab Wiki | https://gitlab.com/aossie/aossie/-/wikis/ | GSoC ideas |
| Email | gsoc@aossie.org | Formal inquiry |

### Day 1 — Gitter Introduction

```
Hi AOSSIE team,

I'm Zakir Jiwani (GitHub: JiwaniZakir), applying for GSoC 2026 with PictoPy.

Background: Python/ML developer — merged PRs in huggingface/transformers (CLIP is
transformer-based), 3 PRs in graphrag (FAISS-style retrieval), FastAPI production
experience (aegis intelligence platform).

PictoPy's CLIP + FAISS + FastAPI stack aligns directly with things I've built and
contributed to.

First PR submitted: [link] — [description]

Questions:
1. Is PictoPy an active GSoC sub-project for 2026? (I see it in the ideas wiki)
2. What improvements are highest priority this year?
3. Is there a PictoPy mentor I should reach out to?

Zakir
```

### ⚠️ Action Required First
Check https://gitlab.com/aossie/aossie/-/wikis/GSoC-2026-Ideas to confirm PictoPy
has a 175h slot. If only Agora (Scala) ideas appear, this pick drops off.

### Key Issues to Reference
Search: https://github.com/AOSSIE-Org/PictoPy/issues?q=is%3Aopen

### Mentor Targets
- **Thushan Ganegedara** — AOSSIE admin, Google Brain
- Check GitLab wiki for PictoPy-specific mentors

---

## Universal Message Templates

### Issue Comment (Before Starting Work)
```
I'm planning to work on this issue. My approach:
1. [Technical diagnosis — show you've read the code]
2. [Proposed fix]
3. [Test plan: which tests I'll add/run]

Expected PR by [date]. Let me know if this approach works or if it's already
being handled by someone.
```

### PR Description Template
```
## Summary
[1–2 sentences: what the PR does and why]

## Changes
- [Specific change 1]
- [Specific change 2]

## Testing
- Ran [test command] — all tests pass
- Added [N] new tests for [specific behavior]

## Related Issues
Closes #[issue number]
```

### Mentor Outreach (After 2+ PRs)
```
Hi @[mentor],

I've submitted [N] PRs to [project] this week:
- [PR link 1]: [brief description] — [status]
- [PR link 2]: [brief description] — [status]

I'm applying for GSoC 2026 ([project name]) and have a proposal draft ready.
Would you be willing to give early feedback on the direction?

Happy to share the draft or discuss async.

Zakir (JiwaniZakir)
```

---

## What NOT to Do

❌ **Don't ask "What can I work on?"** — Come with specific issues already identified.

❌ **Don't skip Ruff for GreedyBear/IntelOwl** — Guaranteed rejection without review.

❌ **Don't submit trivial PRs only** — One substantive fix + tests carries more weight than five typo fixes.

❌ **Don't ghost after submitting** — Respond to review feedback within 24 hours.

❌ **Don't combine unrelated changes in one PR** — One PR per issue, always.

❌ **Don't apply to both sbi projects in GSoC** — Pick one as primary, contribute to both repos.

❌ **Don't invest in PictoPy before confirming the GSoC slot** — Check AOSSIE wiki first.

---

**Last Updated:** March 20, 2026
