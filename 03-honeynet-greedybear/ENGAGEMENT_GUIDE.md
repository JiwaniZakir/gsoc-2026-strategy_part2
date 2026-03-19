# GreedyBear: Engagement Guide

**Priority:** #4 — Crowded, but ML layer is the opening
**Community:** Honeynet Project Discord + GitHub Issues
**Key contacts:** mlodic (@mlodic), regulartim (@regulartim)

---

## Intelligence Update (March 19)

- **Most competitive per-star ratio** of all 5 repos: 10+ external PRs open simultaneously
- 8 external PRs merged in 3 days (March 17–19)
- mlodic reviews and merges SAME DAY when PRs are clean — fast feedback loop
- **The opening:** ML model layer is untouched by competitors (all focused on frontend/backend fixes)
- No CONTRIBUTING.md — follow recent merged PR patterns exactly

---

## Channels

| Channel | URL | Notes |
|---------|-----|-------|
| **Honeynet Discord** | Check honeynet.org or repo README | Look for `#greedybear` or `#gsoc-2026` |
| **GitHub Issues** | https://github.com/intelowlproject/GreedyBear/issues | Comment here to claim issues |
| **GitHub PRs** | https://github.com/intelowlproject/GreedyBear/pulls | Monitor competition here |

---

## Mentor Profiles

### mlodic (@mlodic)
- 267 commits, core maintainer — backend
- Reviews same day when PRs are clean
- Timezone: Italy likely (Honeynet.org is Italy-based) — post 07:00–14:00 UTC
- **Approach:** Clean PRs with filled templates get same-day reviews. Sloppy PRs get ignored.

### regulartim (@regulartim)
- 88 commits, core maintainer — frontend + infra
- Working on uv migration (has a DRAFT PR open)
- **Approach:** If you can contribute to the uv migration, this gets you regulartim attention

---

## Pre-Day-1: Unclaimed Issue Scan

**Do this before posting an intro or claiming anything:**

```bash
# Get all open issues (numbers and titles)
gh api "repos/intelowlproject/GreedyBear/issues?state=open&per_page=50" \
  | jq '.[] | "\(.number): \(.title)"'

# Get which issues are referenced in open PRs
gh api "repos/intelowlproject/GreedyBear/pulls?state=open&per_page=50" \
  | jq '.[] | .body' | grep -oE '(Closes|Fixes) #[0-9]+'

# Cross-reference to find UNCLAIMED issues
```

**Already claimed (March 19 intelligence):**
- #1089 — Prasad8830
- #1087 — Aditya30ag
- #1060 — R1sh0bh-1
- #1034 — IQRAZAM
- #987 — swara-2006
- #852 — opbot-xd
- #525 — lvb05 (country filter)

---

## Day 1 — March 19: Setup + First PR

### Discord Intro (After First PR is Submitted)

```
Hi Honeynet team! I'm Zakir — Python/Django/security developer.
Applying for GSoC 2026 on GreedyBear's Event Collector API.

Background:
- Merged to prowler-cloud/prowler (CORS config via environment variables) —
  security-adjacent Django work, directly relevant to GreedyBear's stack
- Built aegis (intelligence platform): Django/Celery async patterns similar
  to GreedyBear's Django Q2 setup
- Built evictionchatbot: Django REST API with authentication patterns

Environment is running. Just submitted draft PR #[N] on issue #[unclaimed issue].

GitHub: JiwaniZakir
```

**Reference the prowler-cloud/prowler merge prominently** — it's the most directly relevant credential for GreedyBear.

---

## Day 2 — March 20: ML Differentiation Signal

### Post Technical Question for mlodic

```
Hi @mlodic — Event Collector API design question.

I've studied the existing DRF ViewSets and the Django Q2 task setup.
For EventCollectorToken (scope-based auth):

Option A: Extend existing DRF TokenAuthentication
- Pro: simpler, fewer migrations
- Con: may create unintended coupling with existing token logic

Option B: Separate EventCollectorToken model with its own auth class
- Pro: clean isolation, enables per-token rate limiting
- Con: additional migration

My lean: Option B — the Event Collector has different rate limiting
needs (injection frequency) than the honeypot read API. These shouldn't
share a token model.

Does this match your thinking?
```

### Signal ML Interest Early

In a separate message or on a relevant issue:
```
I noticed drona-gyawali's PR just merged adding ML feature importances
logging. I'm thinking about a follow-on: exposing the trained RF model's
feature importances via a `/api/ml/feature-importances/` endpoint, so
operators can see which signals drive classification through the API.

Is this something the team would find valuable? Happy to open an issue
to discuss before starting.
```

---

## Day 3 — March 21: ML PR Attempt

### Differentiation Move

If you have bandwidth after PR #1 and #2, open an issue proposing the ML feature importances API endpoint. Get mlodic to comment before building it.

```
Opening this issue to propose: add a read-only API endpoint exposing the
trained Random Forest model's feature importances.

Use case: operators and developers want to understand which honeypot
signal features are most predictive — currently this is only available
in the logs (merged in drona-gyawali's recent PR), not programmatically.

Proposed endpoint: GET /api/ml/feature-importances/
Returns: [{"feature": "...", "importance": 0.34}, ...]

Implementation: Load the serialized model → extract .feature_importances_ →
return sorted by importance via DRF.

cc @mlodic — does this align with where you'd like the ML API to go?
```

---

## Day 4 — March 22: Proposal Share

### Post to Discord or GitHub

```
Hi @mlodic @regulartim — GSoC proposal outline for Event Collector API:

Backend:
1. EventCollectorToken model (scope: events:write / events:read)
2. DRF ViewSet with Serializer-based input validation
3. Django Q2 async task: validate → normalize → index to Elasticsearch
4. Rate limiting per token (django-ratelimit)
5. Status endpoint: event processing tracking
6. >80% test coverage for all new code

Frontend (if scope allows):
7. Token management CRUD UI
8. Injection statistics dashboard

Two questions:
1. For ES indexing: separate index for injected events, or merge with T-Pot data?
2. Frontend token management: in-scope for GSoC, or defer?

Happy to share the full draft.
```

---

## Day 5 — March 23: Final Summary

```
GSoC 2026 contribution summary (GreedyBear):

PRs this week:
- PR #[N]: [first issue fix] — [merged/in review]
- PR #[N]: [second contribution] — [merged/in review]
- PR #[N]: [ML endpoint or third fix] — [merged/in review]

Submitting proposal tomorrow. Thanks @mlodic @regulartim for the
rapid reviews and the responsive community.

GitHub: JiwaniZakir
```

---

## Response Templates

### When mlodic Reviews Your PR

```
Thanks @mlodic — addressed all comments:

1. [Comment]: [Specific change]. The ruff format issue was in [file] — fixed.
2. [Comment]: [What you changed] — PR template updated with test output.
3. [Comment]: Good catch. Added test for [edge case].

Ruff clean, pre-commit passes, manage.py test: [X] tests pass.
Ready for re-review!
```

---

## What NOT to Do in GreedyBear

1. **Never submit a PR without filling the template completely** — mlodic will close without review
2. **Never work on an issue that already has a linked PR** — scan for this before claiming
3. **Never skip ruff format** — CI will fail and block review
4. **Never copy AI code verbatim** — GreedyBear's informal rules include this
5. **Never open a PR without a draft within a week of claiming** — auto-unassignment

---

## Zakir's Edge for GreedyBear

- **prowler-cloud/prowler merge**: CORS config via env vars in a Django security tool — directly relevant
- **aegis**: Django/Celery async = same pattern as Django Q2
- **sentinel**: Slack bot with security event handling = community management + security overlap
- Security domain knowledge = fits GreedyBear's threat intelligence mission

---

**Last Updated:** March 19, 2026 (post-intelligence rewrite)

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
