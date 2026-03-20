# GSoC 2026 Proposal — IntelOwl LLM Chatbot

**Applicant:** Zakir Jiwani (JiwaniZakir)
**Organization:** The Honeynet Project
**Project:** IntelOwl LLM Chatbot Integration
**Size:** 175 hours | **Difficulty:** Medium
**Mentor:** Matteo Lodi (mattebit)

---

## Abstract

I will build a production-ready LLM chatbot integrated into IntelOwl that allows
analysts to query threat intelligence data in natural language, receive grounded
answers backed by real analyzer outputs, and get step-by-step explanations of
complex IOC reports. The chatbot will use LangChain for orchestration, FAISS for
retrieval-augmented generation over IntelOwl's documentation, and stream responses
to a new React widget in the IntelOwl frontend.

---

## Background & Motivation

IntelOwl aggregates data from 200+ analyzers — a powerful capability that is
also a steep learning curve. A new analyst faces hundreds of JSON fields with no
natural-language explanation of what they mean or why they matter. An LLM chatbot
can bridge this gap: "Is this IP malicious?" becomes a query that retrieves live
analyzer data, synthesizes it, and explains the reasoning in plain English.

The Honeynet Project's threat intelligence mission directly benefits from making
IntelOwl more accessible. Analysts who can ask questions in natural language will
use the platform more effectively, catch threats faster, and onboard in less time.

---

## Technical Approach

### Architecture

```
User Query
    │
    ▼
React Chatbot Widget (frontend)
    │ HTTP SSE stream
    ▼
Django Streaming Endpoint (/api/llm/chat)
    │
    ▼
LangChain Agent (LangGraph StateGraph)
    ├── RAG Tool → FAISS (IntelOwl docs + analyzer descriptions)
    ├── analyze_observable Tool → IntelOwl REST API
    ├── get_job_report Tool → IntelOwl REST API
    └── explain_analyzer Tool → Hardcoded analyzer doc store
    │
    ▼
LLM (OpenAI / Anthropic / Ollama — configurable)
    │
    ▼
Streamed Response → SSE → React widget
```

### Key Components

**1. LangChain Agent (core)**
A LangGraph `StateGraph` that decides which tools to call based on the user query.
The agent can run multiple tool calls in sequence (e.g., "submit analysis → wait →
retrieve report → explain results").

**2. RAG Pipeline**
- Ingest IntelOwl docs and analyzer descriptions into FAISS vector store at startup
- On each query, retrieve top-K relevant chunks to ground the LLM's response
- Prevents hallucinations about analyzer capabilities

**3. IntelOwl API Tools**
LangChain `@tool`-decorated functions that wrap IntelOwl's REST endpoints:
- `analyze_observable`: submit a job
- `get_job_report`: retrieve results
- `list_analyzers`: discover available analyzers
- `explain_report`: format and summarize a report

**4. Streaming Endpoint**
Django `StreamingHttpResponse` with Server-Sent Events (SSE) so users see
the chatbot response token-by-token, not waiting for the full response.

**5. React Widget**
A collapsible chatbot panel added to IntelOwl's existing React app.
Connects to the SSE endpoint, renders markdown, handles tool-call status updates.

**6. LLM-Agnostic Configuration**
Via Django settings:
```python
LLM_BACKEND = env("LLM_BACKEND", default="openai")  # openai | anthropic | ollama
LLM_MODEL = env("LLM_MODEL", default="gpt-4o-mini")
LLM_API_KEY = env("LLM_API_KEY", default="")
OLLAMA_BASE_URL = env("OLLAMA_BASE_URL", default="http://localhost:11434")
```

---

## Timeline

| Period | Deliverables |
|--------|-------------|
| **Community Bonding** (May) | Deep-dive IntelOwl codebase, discuss architecture with mentors, finalize design doc, set up FAISS locally |
| **Week 1–2** (Jun 1–14) | Core LangChain agent: tools wrapping IntelOwl API, basic single-turn QA |
| **Week 3–4** (Jun 15–28) | RAG pipeline: FAISS ingestion, document chunking, retrieval integration |
| **Week 5–6** (Jun 29–Jul 12) | Multi-turn conversation with memory (LangGraph `StateGraph`), tool chaining |
| **Week 7** (Jul 13–19) | Streaming Django endpoint (SSE), integration tests |
| **Week 8** (Jul 20–26) | React chatbot widget: UI, SSE client, markdown rendering |
| **Midterm eval** | Agent + RAG + streaming working end-to-end |
| **Week 9–10** (Jul 27–Aug 9) | LLM-agnostic backend (Anthropic + Ollama support), configuration system |
| **Week 11** (Aug 10–16) | Evaluation: automated QA tests, RAG precision measurement |
| **Week 12** (Aug 17–23) | Stretch: voice input, report export to PDF, multi-language |
| **Final week** (Aug 24–25) | Documentation, final cleanup, mentor review |

---

## Deliverables

1. `api_app/llm/` module — LangChain agent, RAG pipeline, API tools
2. `/api/llm/chat` streaming endpoint
3. React chatbot widget component
4. Configuration system for LLM backend selection
5. Test suite (≥85% coverage for LLM module)
6. Documentation: architecture doc + user guide

---

## Why I'm the Right Person

| Requirement | My Evidence |
|-------------|------------|
| LangChain expertise | 4 merged PRs in `langchain-ai/langchain` |
| LangGraph / agent orchestration | 5 merged PRs in `langchain-ai/langgraph` |
| Django + Celery | Production `aegis` platform: FastAPI/Django/Celery, 338 tests |
| Security domain | Merged PRs in `prowler-cloud/prowler` (cloud security) |
| RAG evaluation | Built `spectra` RAG eval toolkit |
| Large Python codebases | Merged PRs in `huggingface/transformers` (100k+ line repo) |

I have already:
- Set up IntelOwl locally with Docker
- Submitted [N] PRs to the repository this week (see contribution log)
- Prototyped the LangChain agent against IntelOwl's REST API

No other applicant for this project combines hands-on LangChain PRs with security
domain experience and Django production knowledge. This is the project I'm
uniquely positioned to deliver.

---

## Post-GSoC Commitment

I intend to maintain the LLM module after GSoC — fixing bugs, updating LangChain
versions, adding new LLM backends as they emerge. The chatbot will be most valuable
when it matures over time, and I'm committed to seeing that through.

---

*Last Updated: March 20, 2026*
