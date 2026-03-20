# Project #1: IntelOwl LLM Chatbot

**Rank: #1 | Org: Honeynet Project | Size: 90–175h | Confirmed GSoC 2026**

## Organization Overview

**IntelOwl** is an open-source threat intelligence platform that aggregates OSINT and
threat intel from 200+ analyzers. It lives under the **Honeynet Project** umbrella, a
confirmed GSoC 2026 organization.

- **GitHub:** https://github.com/intelowlproject/IntelOwl
- **Honeynet GSoC:** https://www.honeynet.org/gsoc/ (confirmed 2026)
- **Stars:** ~4,000
- **Language:** Python, Django, Celery, React

## GSoC Project Idea: LLM Chatbot for IntelOwl

**Goal:** Build an LLM-powered chatbot that can answer questions about IntelOwl's threat
intelligence data, explain analyzer outputs, and guide users through the platform.

**Size:** 90–175h | **Difficulty:** Medium

### What Gets Built
- LangChain-based conversational agent that queries IntelOwl's REST API
- Retrieval-augmented generation (RAG) over analyzer documentation and IOC reports
- LLM-agnostic design (OpenAI, Anthropic, local models via Ollama)
- Integration with IntelOwl's frontend (React)
- Streaming responses for real-time UX

## Zakir's Edge

| Proof Point | Relevance |
|-------------|-----------|
| LangChain — 4 PRs | Direct tech match — the chatbot uses LangChain |
| LangGraph — 5 PRs | Agent architecture expertise |
| IntelOwl security domain | Prowler (cloud security) merged PRs |
| aegis (intelligence platform, Django) | Production Django + Celery knowledge |
| spectra (RAG eval toolkit) | RAG design and evaluation experience |

This is the highest-fit project in the entire GSoC 2026 field for Zakir's profile.
No other applicant combines LangChain PRs + LangGraph PRs + security domain + Django production experience.

## Tech Stack

| Component | Technology |
|-----------|-----------|
| Backend | Python 3.11+, Django, Django REST Framework, Celery |
| LLM layer | LangChain, LangGraph, OpenAI / Anthropic APIs |
| RAG | FAISS or ChromaDB for vector store |
| Database | PostgreSQL |
| Frontend | React.js |
| CI | GitHub Actions |
| Linting | Ruff (MANDATORY — Honeynet standard) |
| Deployment | Docker, docker-compose |

## Key Modules to Understand

| Module | Purpose |
|--------|---------|
| `api/` | DRF viewsets for jobs, analyzers, connectors |
| `analyzers_manager/` | 200+ analyzers — this is the data the chatbot queries |
| `playbooks_manager/` | Playbook orchestration |
| `intel_owl/settings.py` | Configuration, secrets management |
| `frontend/src/` | React app — where chatbot UI goes |

## Mentors (Honeynet GSoC 2026)

- **Matteo Lodi** (mattebit) — primary IntelOwl maintainer, very responsive
- **Eshaan Bansal** — IntelOwl maintainer
- **Shubham Pandey** — IntelOwl contributor

## Communication Channels

| Channel | Link | Purpose |
|---------|------|---------|
| Slack | honeynet.slack.com | PRIMARY — ping mentors here |
| GitHub Issues | https://github.com/intelowlproject/IntelOwl/issues | Contributions |
| GitHub Discussions | https://github.com/intelowlproject/IntelOwl/discussions | Proposals |
| Honeynet GSoC | https://www.honeynet.org/gsoc/ | Official GSoC info |

---
*Priority: #1 — Perfect tech stack match. Lead with LangChain PRs in every message.*
