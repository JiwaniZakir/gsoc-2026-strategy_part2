# GreedyBear: 5-Day Blitz Contribution Plan

**Project:** Event Collector API
**Mentors:** Tim Leonhard (frontend), Matteo Lodi (backend)
**Proposal deadline:** March 24, 2026
**Stack:** Python, Django, DRF, PostgreSQL, Elasticsearch, Django Q2

---

## CRITICAL RULES (Non-Negotiable)

1. **Get assigned before coding** — comment "I'd like to work on this" and wait
2. **Branch from `develop`**, never `main`
3. **Ruff must pass** before every commit: `ruff check . --fix && ruff format .`
4. **Draft PR within 1 week** of assignment — auto-unassign otherwise
5. **No AI copy-paste** — maintainers will reject it
6. **Fill PR template completely** — blank sections = rejection

---

## Day 1 — March 19: Environment + First Issue

### Hour-by-Hour

**08:00–09:30 — Environment Setup**
```bash
git clone https://github.com/intelowlproject/GreedyBear.git
cd GreedyBear
# Start the dev stack
./gbctl init --dev --elastic-local
# Verify containers running
docker ps | grep greedybear
# Install pre-commit hooks
pip install pre-commit
pre-commit install -c .github/.pre-commit-config.yaml
# Run tests to verify setup
docker exec greedybear_uwsgi python3 manage.py test
```

**09:30–11:00 — Codebase Orientation**
- Read `/docs/ARCHITECTURE.md` and `/CONTRIBUTING.md`
- Explore `/greedybear/api/` — understand existing ViewSets and serializers
- Read issues #1083, #1089, #1085, #1073 carefully
- Pick the most bounded issue to claim

**Issue Priority for Day 1:**
- #1083 (None session_id handling) — low complexity, bug fix, 2–4 hours
- #1089 (Feeds filter enhancement) — small API feature, 4–6 hours

**11:00–13:00 — Claim Issue + Start Work**
```
Comment on issue:
"I'd like to work on this for GSoC 2026 (applying for Event Collector API).
I've read the codebase and understand the scope.

My approach:
1. [Step 1 — specific]
2. [Step 2 — specific]
3. Add test for [specific behavior]

Starting now — will have a draft PR up within a couple hours."
```

Create branch:
```bash
git checkout develop
git pull origin develop
git checkout -b fix/issue-1083-session-id develop
```

Make the fix, write the test.

**13:00–14:30 — Code Quality Pass**
```bash
ruff check . --fix
ruff format .
pre-commit run --all-files
docker exec greedybear_uwsgi python3 manage.py test
```

**14:30–15:00 — Create Draft PR**
```bash
git push origin fix/issue-1083-session-id
```
Open PR, mark as **Draft**, fill PR template completely. Link issue.

**15:00–16:00 — Discord Intro**
Post in Honeynet Discord `#gsoc-2026` or `#greedybear`:
```
Hi Honeynet community! I'm Zakir — backend developer with Python/Django
background (FastAPI, Celery, PostgreSQL). Applying for GSoC 2026 on
GreedyBear's Event Collector API.

I've been working on security-adjacent projects — aegis (personal
intelligence platform) and evictionchatbot (AI legal chatbot). GreedyBear's
threat intelligence angle genuinely interests me.

Just submitted draft PR #NNN on issue #1083. Environment is running.

GitHub: JiwaniZakir
```

**16:00–19:00 — Event Collector Research**
- Read `/greedybear/api/` deeply — existing auth patterns, serializers, ViewSets
- Study the Django Q2 task queue setup in `/cronjobs/`
- Note: Which endpoints have proper validation? Which don't?
- Write down the exact technical questions to ask Matteo tomorrow

---

## Day 2 — March 20: Second PR + Engagement

**Target:** Second PR submitted. Specific technical question posted to Matteo.

### Tasks

**08:00–09:00** — Check PR #1 feedback. Respond immediately to any comments.

**09:00–12:00** — **PR #2: Issue #1089 or #1085**
- #1089: Feeds filter enhancement (touch API code without major refactor)
- #1085: Cronjob exception handling (Django Q2 error patterns)

```bash
git checkout develop && git pull origin develop
git checkout -b fix/issue-1089-feeds-filter develop
# Implement
ruff check . --fix && ruff format .
pre-commit run --all-files
docker exec greedybear_uwsgi python3 manage.py test
git push origin fix/issue-1089-feeds-filter
```

**12:00–14:00** — Post technical question for Matteo:
```
Hi @matteo.lodi — working on understanding the auth architecture
for my Event Collector API proposal.

I looked at the existing token auth patterns in /authentication/
and noticed [specific thing, e.g., "TokenAuthentication is used but
without custom scopes"].

For the Event Collector API, I'm planning scope-based auth
(events:write, events:read). My question: should I extend the existing
DRF TokenAuthentication class, or build a separate EventCollectorToken
model with its own auth class?

The main tradeoff I see: separate model is cleaner but more migration risk.
Extending existing is simpler but may cause unintended coupling.

What's your preferred approach? I want to match how you're thinking
about the auth layer.
```

**14:00–17:00** — Study the Event Collector architecture deeply:
- How does data flow from the API to Elasticsearch?
- Where does Django Q2 fit?
- What models would a new Event need?
- Sketch the EventCollectorToken model

**17:00–21:00** — Write full Problem Statement + Technical Approach in PROPOSAL_DRAFT.md

---

## Day 3 — March 21: Substance

**Target:** More complex PR. Proposal 80% complete. Community visible.

### Tasks

**09:00–12:00** — **PR #3: Training Data Export (#1087) or more complex bug fix**
- #1087 (Training Data Export) touches serialization and data handling — directly relevant to Event Collector API work
- Shows you can handle large data and async patterns

```bash
git checkout develop && git pull origin develop
git checkout -b feature/issue-1087-training-export develop
```

**12:00–14:00** — Review 2 open PRs in GreedyBear. Leave substantive comments.

**14:00–16:00** — Post in Discord: share that you're working on Issue #1087 and have a draft PR. This keeps you visible.

**16:00–21:00** — Complete Timeline + Deliverables + "About Me" in proposal.

---

## Day 4 — March 22: Polish

**Target:** Proposal review-ready. Mentors know your approach.

### Tasks

**09:00–11:00** — Address all PR feedback. Every comment gets a response. Every fix gets pushed.

**11:00–13:00** — Post proposal outline to mentors:
```
Hi @matteo.lodi @tim.leonhard — I've drafted my Event Collector API
proposal and would love a sanity check:

Backend (primary):
- EventCollectorToken model (scope-based: events:write/read)
- DRF ViewSet with input validation (Serializer)
- Django Q2 async processing task
- Rate limiting per token
- Status endpoint for event processing tracking
- >80% test coverage

Frontend (supporting, if time allows):
- Token management CRUD UI
- Injection statistics dashboard

Two questions:
1. Should frontend token management be in GSoC scope, or defer?
2. For ES indexing — separate indices for injected events, or merge with T-Pot?

Happy to share full draft.
```

**13:00–21:00** — Final proposal polish.

---

## Day 5 — March 23: Submit

**Target:** Proposal submit-ready.

### Tasks

**09:00–12:00** — Final proposal pass. Verify deliverables are concrete and timeline is realistic.

**12:00–14:00** — Post contribution summary in Discord.

**14:00–17:00** — Address any last PR feedback.

**17:00–20:00** — Submit proposal.

---

## PR Template (Copy-Paste for Every PR)

```markdown
## What changed
[One sentence description]

## Why
[Why this change is needed]
Fixes #[issue number]

## How I tested it
- Ran `ruff check . --fix && ruff format .` — clean
- Ran `pre-commit run --all-files` — all hooks pass
- Ran `docker exec greedybear_uwsgi python3 manage.py test` — [X] tests pass
- Manual test: [describe if applicable]

## Breaking changes
None / [describe if any]

## Related issues
Fixes #NNN
```

---

## Git Workflow

```bash
# Always start from develop
git checkout develop && git pull origin develop

# Feature branch
git checkout -b fix/issue-NNN-description develop

# Before committing
ruff check . --fix
ruff format .
pre-commit run --all-files
docker exec greedybear_uwsgi python3 manage.py test

# Squash to one logical commit
git rebase -i develop
# Mark all but first as 'squash'

# Push
git push origin fix/issue-NNN-description
```

---

**Last Updated:** March 19, 2026
**Mode:** 5-day blitz
