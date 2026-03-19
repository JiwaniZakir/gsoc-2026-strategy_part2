# GreedyBear: Day-by-Day Engagement Guide

**Community:** Honeynet Project Discord
**GitHub:** https://github.com/intelowlproject/GreedyBear
**Mentors:** Matteo Lodi (backend), Tim Leonhard (frontend)

---

## Day 1 — March 19: Join and Land

### Discord Intro

Post in `#gsoc-2026` or `#greedybear`:
```
Hi Honeynet community! I'm Zakir — backend developer with Python/Django/DRF
background. Applying for GSoC 2026 on GreedyBear's Event Collector API.

I've been working on security-adjacent infrastructure: aegis (a personal
intelligence platform using FastAPI/Celery) and evictionchatbot (AI legal
chatbot). The threat intel aggregation angle of GreedyBear is genuinely
interesting to me.

I've cloned the repo, run `./gbctl init --dev --elastic-local`, read
ARCHITECTURE.md and CONTRIBUTING.md, and explored /greedybear/api/.

Just submitted draft PR #NNN on issue #1083 (session_id handling).
Looking forward to contributing.

GitHub: JiwaniZakir | Available EST, ~3-4 hrs/day this week, full-time in May
```

**Key elements:**
- Mention you've done homework (ran local setup, read docs)
- Reference the PR immediately — you're a contributor, not a lurker
- Note your relevant background (Django/security/async)

### Issue Claim Comment Template

```
I'd like to work on this for GSoC 2026 (applying for Event Collector API).

I've read the codebase and understand the scope. My approach:
1. [Step 1 — specific to this issue]
2. [Step 2]
3. Test: [describe test you'll add]

Starting now — draft PR within a couple of hours.
```

---

## Day 2 — March 20: Technical Engagement with Matteo

### Post a Targeted Technical Question

In Discord (or as a GitHub issue comment on a relevant PR):
```
Hi @matteo.lodi — working on my Event Collector API proposal and
want to make sure the auth design aligns with your thinking.

I looked at the existing token auth in /authentication/ and see
DRF's TokenAuthentication is used. For the Event Collector, I'm
proposing a separate EventCollectorToken model with:
- scope-based access (events:write, events:read)
- per-token rate limiting
- IP whitelisting (optional)
- expiry + revocation

The main question: separate model (cleaner, more isolated) vs.
extending the existing token (simpler, less migration risk).

From PR #789 (Django Q2 migration), I can see the team prefers
incremental changes. So my instinct is separate model with a separate
auth class — but I wanted to check before going deep on the design.

What's your preference?
```

**Why this works:** You've referenced a specific recent PR (#789). You've shown you've read the auth code. You're asking for alignment, not asking to be taught.

---

## Day 3 — March 21: Substance Visible

### After Submitting PR #3

Post in Discord:
```
Draft PR #NNN up for issue #1087 (training data export).
It touches serialization and large-dataset handling — relevant to
the Event Collector API patterns I'm designing.

Would appreciate feedback, especially on the chunking approach I used
for large result sets. Not sure if that's the team's preferred pattern.
```

### Comment on Open PRs

Find 2 PRs open >3 days. Leave substantive comments:
- Edge case in validation logic
- Alternative approach to error handling
- Missing test scenario

This builds community presence beyond your own work.

---

## Day 4 — March 22: Mentor Alignment on Proposal

### Share Proposal Summary

```
Hi @matteo.lodi @tim.leonhard — I've drafted the Event Collector API
proposal and want to align on scope before finalizing.

Backend (primary, 10 weeks):
✓ EventCollectorToken model (scope-based auth)
✓ DRF serializer with full validation
✓ ViewSet: POST /collect/ + GET /collect/{id}/status/
✓ Django Q2 async processing task
✓ Per-token rate limiting
✓ >80% test coverage + OpenAPI docs

Frontend (if time allows, weeks 10-11):
✓ Token management CRUD UI
✓ Basic injection statistics

Two open questions:
1. Frontend token UI — in GSoC scope, or defer entirely?
2. ES indexing — separate index for injected events or merge with T-Pot?

Happy to share the full draft. Wanted to check priorities before locking in.
```

---

## Day 5 — March 23: Contribution Summary

### Post in Discord

```
Week 1 summary before submitting GSoC proposal:

PRs submitted to GreedyBear:
- PR #NNN: Issue #1083 (session_id handling) — [merged/reviewing]
- PR #MMM: Issue #1089 (feeds filter) — [reviewing]
- PR #PPP: Issue #1087 (training data export) — [reviewing]

What I learned: [1–2 specific technical insights from the codebase,
e.g., "The Django Q2 task pattern in /cronjobs/ is cleaner than I
expected — event processing will fit naturally into that architecture."]

Thanks for the feedback this week. Submitting proposal tomorrow.
```

---

## Response Templates

### When Matteo Reviews Your PR

```
Thanks for the thorough review!

1. **Re: [comment on validation]:** You're right — I was checking [X]
   but missed [Y]. Fixed by adding [specific check] in commit [hash].

2. **Re: [comment on Ruff compliance]:** Ran `ruff check . --fix` and
   `ruff format .` again — all clean.

3. **Re: [question on approach]:** I chose [X] because [reason].
   If you prefer [Y], I can change — just want to understand the tradeoff.

All checks passing. Squashed to one commit. Ready for re-review!
```

### When Asking Tim About Frontend

```
Hi @tim.leonhard — quick frontend question:

For the token management UI, I'm looking at the existing auth components
in /frontend/src/components/. I need to build a form for creating
EventCollectorTokens with name, scope selection, and rate limit input.

Looking at [specific existing component] as a model. One question:
for the "copy token to clipboard" feature — does Certego-UI have a
built-in copy component, or should I build a custom one?

I saw you handled something similar in PR #846. Is that the pattern
to follow, or has the approach changed?
```

---

## GreedyBear-Specific Rules

| Rule | Why It Matters |
|------|---------------|
| Branch from `develop`, not `main` | PRs to `main` are rejected silently |
| `ruff check . --fix && ruff format .` before every commit | CI fails without this |
| `pre-commit run --all-files` before pushing | Catches issues CI would catch |
| Draft PR within 1 week of issue assignment | Auto-unassign otherwise |
| Fill PR template completely | Blank sections = rejection |
| One logical commit (squash) | Maintainers prefer clean history |

---

## Key Observation for Proposals

The strongest signal in a GreedyBear proposal is showing you understand:
1. The Django Q2 architecture (it was recently migrated from Celery — reference PR #789)
2. The existing auth patterns (and why token-per-service is better than per-user for this use case)
3. The Elasticsearch integration (how data flows from API to ES)

Reference these specifically in your proposal. Generic Django knowledge is not enough — show you've read GreedyBear's specific implementation.

---

**Last Updated:** March 19, 2026
