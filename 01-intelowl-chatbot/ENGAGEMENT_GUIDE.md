# IntelOwl — Day-by-Day Outreach & Engagement Guide

**Rule:** Lead every message with LangChain PRs. No other GSoC applicant has
LangChain + LangGraph + security + Django in one profile.

---

## Day 1 — March 20: Honeynet Slack Introduction

**Channel:** honeynet.slack.com → #gsoc (or #intelowl)

```
Hi Honeynet team,

I'm Zakir Jiwani (GitHub: JiwaniZakir), applying for GSoC 2026 with IntelOwl.

Background:
- 4 merged PRs in LangChain (direct tech match for the LLM chatbot project)
- 5 merged PRs in LangGraph (agent orchestration)
- Merged PRs in prowler-cloud/prowler (security domain)
- Production Django + Celery (aegis intelligence platform, 338 tests)
- RAG evaluation experience (spectra toolkit)

I'm proposing the IntelOwl LLM Chatbot — a LangChain-based agent that queries
IntelOwl's REST API, explains analyzer outputs, and uses RAG over your documentation.

First PR submitted today: [link] — [brief description]

Who should I connect with about the GSoC mentorship for this project?

Zakir
```

---

## Day 2 — March 21: Issue Comment + GitHub Presence

**On your first PR/issue:**
```
I'm working on this issue. My approach:
1. [Technical diagnosis — be specific, show you've read the code]
2. [Proposed fix]
3. [Test plan: which tests I'll add/run]

Expected PR by [date]. Let me know if there's a preferred implementation approach
or if this is already in progress.
```

**On an existing open PR (code review):**
```
Reviewed this PR — a few thoughts:

[Substantive comment on the code, not a nitpick]

The approach looks solid. One alternative worth considering: [idea].
Happy to test this locally if helpful.
```

---

## Day 3 — March 22: Proposal Preview in Discussions

Post a high-level proposal outline in GitHub Discussions:

```
Subject: GSoC 2026 — IntelOwl LLM Chatbot — proposal preview & feedback request

Hi IntelOwl team,

I'm Zakir Jiwani, applying for the LLM Chatbot GSoC project. I've already
submitted [N] PRs this week: [list with links].

Sharing a proposal outline for early feedback:

## Goal
Build a LangChain-based chatbot that:
- Queries IntelOwl's REST API for live threat intel data
- Uses RAG over analyzer documentation for grounded answers
- Streams responses to the React frontend
- Supports multiple LLM backends (OpenAI, Anthropic, Ollama)

## Week-by-week breakdown (condensed)
- Weeks 1–3: Core LangChain agent + IntelOwl API integration
- Weeks 4–6: RAG pipeline (FAISS + documentation ingestion)
- Weeks 7–9: Streaming API + React frontend widget
- Weeks 10–12: Testing, evaluation, docs, stretch goals

## My relevant experience
- 4 LangChain PRs (direct match)
- 5 LangGraph PRs (agent orchestration)
- Django production (aegis, 338 tests)
- RAG eval toolkit (spectra)

Questions for mentors:
1. Should the chatbot be LLM-agnostic from day one, or start with a single provider?
2. Is FAISS the preferred vector store, or do you have a preference?
3. Are there existing IntelOwl API clients I should build on?

Happy to share the full draft. Thanks, Zakir
```

---

## Day 4 — March 23: Direct Mentor Outreach

After 3+ PRs submitted, DM Matteo Lodi on Slack:

```
Hi Matteo,

I've submitted [N] PRs to IntelOwl this week:
- [PR link 1]: [brief description] — [status]
- [PR link 2]: [brief description] — [status]
- [PR link 3]: [brief description] — [status]

I'm applying for the LLM Chatbot GSoC project and have a proposal draft ready.
Would you be willing to give feedback on the direction before I submit?

My background on the tech stack: 4 merged PRs in LangChain, 5 in LangGraph,
and production Django experience. I think I'm a strong fit for this specific project.

Happy to share the draft or discuss async via GitHub or Slack.

Zakir (JiwaniZakir)
```

---

## Day 5 — March 24: Final Wrap-Up

Post a summary in the channel or in your initial Discussions thread:

```
Week 1 wrap-up — IntelOwl GSoC contribution sprint:

PRs submitted:
- [PR #1 link]: [title] — [status]
- [PR #2 link]: [title] — [status]
- [PR #3 link]: [title] — [status]

Proposal submitted to GSoC portal.

Thank you to [maintainer names] for reviewing and for your feedback in [thread].
I'm committed to this project through the summer — the combination of security
threat intel and LLM tooling is exactly where I want to focus.

Zakir
```

---

## Key Talking Points (Use Repeatedly)

1. **"4 merged PRs in LangChain, 5 in LangGraph"** — say this in every first contact.
2. **"Production Django + Celery in aegis (338 tests)"** — matches IntelOwl's exact stack.
3. **"RAG evaluation experience with spectra"** — directly relevant to the chatbot's RAG pipeline.
4. **"Merged PRs in prowler-cloud/prowler"** — demonstrates security domain understanding.

---

## What NOT to Do

- Don't ask "What can I work on?" — come with specific issues already identified.
- Don't submit a chatbot PR without first having merged a "boring" bug fix or test PR.
- Don't forget `ruff check .` before every submission.
- Don't DM mentors before you have 2+ PRs to reference.
