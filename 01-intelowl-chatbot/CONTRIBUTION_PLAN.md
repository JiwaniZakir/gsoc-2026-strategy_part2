# IntelOwl — Aggressive 5-Day Contribution Plan (Mar 20–24)

**Target: 8–10 PRs in 5 days**
**Rule #1: Every PR must pass `ruff check` — Honeynet enforces this strictly**
**Rule #2: One issue = one PR. Never combine unrelated changes.**

## Environment Setup (Day 1 Morning)

```bash
git clone https://github.com/intelowlproject/IntelOwl
cd IntelOwl

# Docker (strongly recommended for IntelOwl's complex stack)
cp .env.example .env.dev
# Edit .env.dev: set DJANGO_SECRET_KEY, DB credentials, etc.
docker compose -f docker/docker-compose.yml up -d

# Local Python setup (for editing without Docker rebuild)
python -m venv venv
source venv/bin/activate
pip install -r requirements/development.txt
python manage.py migrate
python manage.py createsuperuser

# Run tests
pytest tests/ -v --tb=short

# MANDATORY linting before every PR
ruff check .
ruff format .
```

---

## Day 1 — March 20: First Contact + PR #1

### PR #1: Good-first-issue bug fix or docs improvement

**Strategy:** Find the most recent `good first issue` or help-wanted issue:
```
https://github.com/intelowlproject/IntelOwl/issues?q=is%3Aopen+label%3A%22good+first+issue%22
```

**High-value targets:**
- Any missing docstring on an analyzer
- Test coverage gap in `tests/analyzers/`
- Minor serializer validation issue
- Error message improvement

```bash
git checkout -b fix/[issue-description]
# make change
ruff check .  # MUST PASS
pytest tests/ -v  # MUST PASS
gh pr create --title "fix: [description]" --body "Closes #[n]"
```

### Day 1 Slack intro
Post in #gsoc channel on honeynet.slack.com (see ENGAGEMENT_GUIDE.md).

---

## Day 2 — March 21: PRs #2 and #3

### PR #2: Test coverage improvement

Pick an analyzer with low test coverage. Add tests:

```python
# tests/analyzers/test_[analyzer_name].py

class TestMyAnalyzer(TestCase):
    @staticmethod
    def get_params():
        return {
            "md5": "sample_md5",
            "observable_name": "8.8.8.8",
            "observable_classification": ObservableClassification.IP,
            "analyzers_requested": ["MyAnalyzer"],
        }

    @patch("api_app.analyzers_manager.observable_analyzers.my_analyzer.requests.get")
    def test_my_analyzer_success(self, mock_get):
        mock_get.return_value = MockResponse({"malicious": False}, 200)
        job = self._perform_job(self.get_params())
        self.assertEqual(job.status, Job.Status.REPORTED_WITHOUT_FAILS)
```

### PR #3: Serializer or API fix

Look at DRF viewsets in `api/` — add validation, improve error messages, or fix
a documented issue in the API response shape.

---

## Day 3 — March 22: PRs #4 and #5 — LangChain Proof-of-Concept

### PR #4: LangChain integration scaffolding

This is the GSoC project itself — submit a draft/RFC PR that shows the architecture:

```python
# intel_owl/llm/chatbot.py (new file)

from langchain_core.prompts import ChatPromptTemplate
from langchain_core.output_parsers import StrOutputParser
from langchain_openai import ChatOpenAI

class IntelOwlChatbot:
    """LLM chatbot for IntelOwl threat intelligence queries."""

    def __init__(self, api_key: str, model: str = "gpt-4o-mini"):
        self.llm = ChatOpenAI(api_key=api_key, model=model)
        self.prompt = ChatPromptTemplate.from_messages([
            ("system", "You are an expert threat intelligence analyst. "
                       "Answer questions about IntelOwl data concisely and accurately."),
            ("human", "{question}"),
        ])
        self.chain = self.prompt | self.llm | StrOutputParser()

    def ask(self, question: str) -> str:
        return self.chain.invoke({"question": question})
```

Open a draft PR, link to the GSoC idea, invite mentor feedback.

### PR #5: CI or configuration improvement

- Add a missing test dependency
- Improve docker-compose health checks
- Add a `Makefile` target for common dev tasks

---

## Day 4 — March 23: PRs #6 and #7

### PR #6: RAG prototype

Extend the chatbot with RAG over IntelOwl's documentation:

```python
# intel_owl/llm/rag.py

from langchain_community.document_loaders import DirectoryLoader
from langchain_text_splitters import RecursiveCharacterTextSplitter
from langchain_community.vectorstores import FAISS
from langchain_openai import OpenAIEmbeddings

def build_knowledge_base(docs_path: str) -> FAISS:
    loader = DirectoryLoader(docs_path, glob="**/*.md")
    docs = loader.load()
    splitter = RecursiveCharacterTextSplitter(chunk_size=1000, chunk_overlap=100)
    chunks = splitter.split_documents(docs)
    embeddings = OpenAIEmbeddings()
    return FAISS.from_documents(chunks, embeddings)
```

### PR #7: Streaming API endpoint

Add a streaming endpoint for the chatbot so the React frontend can show
real-time responses:

```python
# api/views.py

from django.http import StreamingHttpResponse

def chatbot_stream(request):
    question = request.GET.get("q", "")
    chatbot = IntelOwlChatbot(api_key=settings.OPENAI_API_KEY)

    def event_stream():
        for chunk in chatbot.chain.stream({"question": question}):
            yield f"data: {chunk}\n\n"

    return StreamingHttpResponse(event_stream(), content_type="text/event-stream")
```

---

## Day 5 — March 24: PRs #8–#10 + Proposal polish

### PR #8: Tests for LangChain components
```python
# tests/llm/test_chatbot.py

from unittest.mock import patch, MagicMock
from intel_owl.llm.chatbot import IntelOwlChatbot

class TestIntelOwlChatbot(TestCase):
    @patch("intel_owl.llm.chatbot.ChatOpenAI")
    def test_ask_returns_string(self, mock_llm):
        mock_llm.return_value.invoke.return_value = "test response"
        bot = IntelOwlChatbot(api_key="fake-key")
        result = bot.ask("Is 1.1.1.1 malicious?")
        self.assertIsInstance(result, str)
```

### PR #9: Frontend chatbot UI (draft)
Add a minimal React chatbot widget to the IntelOwl frontend.

### PR #10: Documentation
Add chatbot architecture docs to `docs/`.

---

## PR Summary Table

| Day | PR | Type | Status Target |
|-----|-----|------|--------------|
| Mar 20 | #1 | Bug fix / good-first-issue | Merged before Mar 24 |
| Mar 21 | #2 | Test coverage | Merged before Mar 24 |
| Mar 21 | #3 | API fix | In review |
| Mar 22 | #4 | LangChain scaffold (draft) | Open, mentor feedback |
| Mar 22 | #5 | CI improvement | Merged |
| Mar 23 | #6 | RAG prototype | Open |
| Mar 23 | #7 | Streaming endpoint | Open |
| Mar 24 | #8 | Tests | Open |
| Mar 24 | #9 | Frontend (draft) | Open |
| Mar 24 | #10 | Docs | Merged |

---

## Ruff Compliance (Non-Negotiable)

```bash
ruff check .        # Must show 0 violations
ruff check --fix .  # Auto-fix what it can
ruff format .       # Format code
ruff check .        # Verify clean
```
