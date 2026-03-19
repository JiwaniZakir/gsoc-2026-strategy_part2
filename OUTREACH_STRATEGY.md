# Outreach Strategy — GSoC 2026

> Detailed day-by-day outreach plan for all 5 projects.
> Includes: exact channels, mentor names/handles, message templates, timing, and what NOT to do.

---

## Table of Contents

1. [Master Outreach Calendar](#master-outreach-calendar)
2. [VulnerableCode (aboutcode-org)](#1-vulnerablecode--priority-1)
3. [Open Climate Fix](#2-open-climate-fix--priority-2)
4. [Accord Project](#3-accord-project--priority-3)
5. [GreedyBear (Honeynet)](#4-greedybear--priority-4)
6. [dora-rs](#5-dora-rs--priority-5)
7. [Universal Message Templates](#universal-message-templates)
8. [What NOT to Do](#what-not-to-do)

---

## Master Outreach Calendar

| Day | Action |
|-----|--------|
| **March 19 AM** | Join all 5 community channels |
| **March 19 PM** | Post intro messages to all 5 (after first PR submitted to each) |
| **March 20** | Post smart technical questions in each channel (1 per project) |
| **March 21** | Comment on 2–3 open PRs per repo — leave substantive technical notes |
| **March 21 PM** | Share proposal outlines in channels, ask for mentor feedback |
| **March 22** | Follow up on proposal feedback, incorporate changes |
| **March 23** | Post final contribution summaries, thank mentors by name |
| **March 24** | Submit proposals. Keep watching PRs. |

---

## 1. VulnerableCode — Priority #1

### Channels

| Channel | URL / How to Join |
|---------|------------------|
| **Gitter (primary)** | https://gitter.im/aboutcode-org/vulnerablecode |
| **GitHub Discussions** | https://github.com/aboutcode-org/vulnerablecode/discussions |
| **IRC** | `#aboutcode` on Libera.Chat (secondary, less active than Gitter) |
| **GitHub Issues** | https://github.com/aboutcode-org/vulnerablecode/issues |

### Key Mentors

| Mentor | GitHub Handle | Gitter | Role | Response Time |
|--------|--------------|--------|------|---------------|
| **TG1999** | @TG1999 | @TG1999 | Core maintainer, 598 commits — primary reviewer | 24–48h |
| **keshav-space** | @keshav-space | @keshav-space | Core maintainer, 465 commits — implementation details | 24–48h |
| **pombredanne** | @pombredanne | @pombredanne | Founder, 458 commits — architecture decisions | 24h |
| **sbs2001** | @sbs2001 | @sbs2001 | Core maintainer, 574 commits | 48h |

**Primary contact:** TG1999 (most recently active, reviewing current PRs)
**Secondary:** keshav-space (implementation depth)

### Day-by-Day Outreach

#### Day 1 — March 19

**Step 1 — Join Gitter (before posting):**
Sign in at gitter.im with GitHub, join the vulnerablecode room.

**Step 2 — Post intro AFTER your first PR is up:**
```
Hi AboutCode! I'm Zakir — Python/ML developer applying for GSoC 2026.

Background: I've built NLP extraction pipelines and multi-agent
frameworks (lattice), and an intelligence platform with entity
extraction (aegis). Also merged PRs to huggingface/transformers
and prowler-cloud/prowler this week — both involve large
unfamiliar Python codebases, which VulnerableCode also is.

I've set up the local environment, reviewed CONTRIBUTING.rst,
and just submitted:
- PR #[N]: [Sort packages newest-to-oldest / whatever issue you hit first]

Exploring the codebase now. Happy to help wherever useful.

GitHub: JiwaniZakir
```

**Step 3 — Claim first issue:**
Comment on the "Sort packages and vulnerabilities newest-to-oldest" issue:
```
I'd like to work on this as a GSoC 2026 applicant (NLP/ML vulnerability
detection project).

I've reviewed the codebase and understand the scope. This affects the
packages API endpoint and the UI sort order. My approach:
1. Add `ordering = ['-updated_at']` to the PackageViewSet queryset
2. Add `ordering = ['-updated_at']` to the VulnerabilityViewSet queryset
3. Add a test asserting newest records appear first in API response

Starting now. Will have a draft PR up within 2 hours.
```

#### Day 2 — March 20

**Post a technical architecture question in Gitter:**
```
Hi @TG1999 @keshav-space — design question for my GSoC proposal.

I'm studying the network access patterns across importers and noticed
each importer makes its own requests.get() calls without a centralized
timeout or retry policy (the "use centralized function" issue).

For my proposal's scope, two options:
Option A: Add a `utils.fetch_url(url, timeout=30, retries=3)` function
          and migrate all importers to use it.
Option B: Add a shared `NetworkSession` class that importers instantiate,
          with configurable retry + exponential backoff.

My lean: Option B — more testable (can mock the session) and opens the
door to rate limiting per domain.

Does this align with how you're thinking about it, or is the scope
different from what's in the issue?
```

#### Day 3 — March 21

**Review 2 open PRs — leave substantive comments:**
- Find NucleiAv's importer PRs — leave technical observations (shows you've read the code deeply)
- Example comment on a PR: "I noticed this importer doesn't handle the case where the advisory has no CVE ID assigned yet — the existing Debian importer handles this in [file:line]. Worth adding similar handling?"

**Post proposal outline:**
```
Hi — sharing my GSoC proposal outline for early feedback:

Project: NLP/ML Vulnerability Detection from Unstructured Data

Key deliverables:
1. NLPExtractor: Named entity recognition for CVE IDs, package names,
   version ranges, severity from advisory text (spaCy + transformers)
2. ConfidenceScorer: Per-field + aggregate confidence (0.0–1.0)
3. 15+ TextFetcher implementations (mailing lists, PyPI, npm, cargo, GitHub)
4. NLPImporter: hooks into existing importer framework
5. Operator review queue for low-confidence extractions
6. Centralized network access (simultaneously fixes the open "use centralized
   function" issue as a concrete deliverable)

Priority question: Is model fine-tuning in scope, or should I use
pre-trained HuggingFace models and focus on the pipeline architecture?

Happy to share the full draft.
```

#### Day 4 — March 22

**Follow up on proposal feedback:**
```
Thanks @TG1999 / @keshav-space for the feedback! I've incorporated:
1. [Their specific point] → Changed approach to [new approach]
2. [Their specific point] → Added [specific thing] to deliverables

Updated draft: [link to gist or paste]

One remaining question: For the fine-tuned NER model, is there an
existing labeled dataset I should know about, or is creating a training
set part of the project scope?
```

#### Day 5 — March 23

**Final summary:**
```
GSoC contribution summary (VulnerableCode):

PRs this week:
- PR #[N]: [title] — [merged/in review]
- PR #[N]: [title] — [merged/in review]
- PR #[N]: [title] — [merged/in review]

Submitting my proposal tomorrow. Thank you all for the reviews,
feedback on the proposal, and answering my design questions.
This is exactly the kind of work I want to spend a summer on.

GitHub: JiwaniZakir
```

### Timing Notes

- Pombredanne is likely in France (CET / UTC+1) — post before 15:00 UTC for same-day response
- TG1999 and keshav-space timezone unknown — post before 12:00 UTC to maximize global coverage
- Gitter is more responsive than GitHub Discussions for quick questions

---

## 2. Open Climate Fix — Priority #2

### Channels

| Channel | URL / How to Join |
|---------|------------------|
| **OCF Slack** | Check repo README for current invite link — primary channel |
| **GitHub Discussions** | https://github.com/openclimatefix/open-source-quartz-solar-forecast/discussions |
| **GitHub Issues (pvnet)** | https://github.com/openclimatefix/pvnet/issues |
| **GitHub Issues (quartz)** | https://github.com/openclimatefix/open-source-quartz-solar-forecast/issues |

### Key Mentors

| Mentor | GitHub Handle | Role | Response Time |
|--------|--------------|------|---------------|
| **peterdudfield** | @peterdudfield | Core maintainer, 150 commits — primary reviewer | Slow (last merge March 16) |
| **aryanbhosale** | @aryanbhosale | Regular contributor, 47 commits | 48h |
| **froukje** | @froukje | Regular contributor, 41 commits | 48h |

**Key risk:** peterdudfield appears to be the only active merger — bottleneck. Manage expectations on merge speed.

### Day-by-Day Outreach

#### Day 1 — March 19

**Post intro (OCF Slack or GitHub Discussions):**
```
Hi Open Climate Fix! I'm Zakir — ML developer applying for GSoC 2026
on the error adjustment / TabPFN project.

I've worked on tabular ML pipelines and uncertainty quantification —
including a RAG evaluation toolkit (spectra) that does confidence
scoring, which directly parallels the error adjustment challenge here.

I've set up the local environment and just submitted PR #[N] on [issue].

For pvnet specifically: I noticed the repo has 14 open issues and
lower PR traffic — I'm planning to contribute there as well.

GitHub: JiwaniZakir
```

**Claim first issue (pvnet or quartz-solar):**
```
I'd like to work on this as a GSoC 2026 applicant (error adjustment project).

My approach: [specific approach based on issue]
Timeline: Will have a draft PR up within 2–3 hours.
```

#### Day 2 — March 20

**Post TabPFN design question:**
```
[For GitHub Discussions or Slack]

Hi @peterdudfield — design question for the error adjustment proposal.

For the TabPFN adjuster integration, I see two integration points:

Option A: Post-processing layer — adjuster runs after the main forecast
and adds a residual. Clean separation, easy to test, backward compatible.
API: run_forecast(apply_adjuster=True)

Option B: Feature augmentation — adjuster informs the base model's
features at training time. More tightly coupled but potentially
more accurate.

My preference: Option A first, since TabPFN works well as a residual
learner and keeps the existing model untouched.

Is this how the project is envisioned, or is there a different
architecture in mind?
```

#### Day 3 — March 21

**Post proposal outline:**
```
GSoC proposal outline for feedback — TabPFN Error Adjustment:

1. TabPFNAdjuster class: takes (raw_forecast, features) → residual
2. Training pipeline: build historical (forecast, actual) dataset from HF Hub
3. API integration: run_forecast(apply_adjuster=True) opt-in parameter
4. Evaluation framework: MAE/RMSE before/after adjustment across sites
5. pvnet integration: same adjuster architecture applied to pvnet outputs
6. CI: add adjustment benchmarks to test suite

Question: For pvnet — is the adjuster architecture meant to be the
same interface, or does pvnet's different data format need a separate class?
```

---

## 3. Accord Project — Priority #3

### Channels

| Channel | URL / How to Join |
|---------|------------------|
| **Discord** | https://discord.gg/accordproject — join `#introductions` then `#technology-cicero` |
| **GitHub Issues (concerto)** | https://github.com/accordproject/concerto/issues |
| **GitHub Issues (template-archive)** | https://github.com/accordproject/template-archive/issues |
| **Mailing list** | Check accordproject.org for current email contact |

### Key Mentors

| Mentor | GitHub Handle | Role | Response Time |
|--------|--------------|------|---------------|
| **jeromesimeon** | @jeromesimeon | Core maintainer, 385 commits | 24–48h |
| **dselman** | @dselman | Core maintainer, 322 commits | 24–48h |
| **mttrbrts** | @mttrbrts | Core maintainer, 236 commits | 48h |

**Note:** Dan Selman (@dselman) appears most responsive to external contributors based on recent merge patterns. Tag him first.

### Day-by-Day Outreach

#### Day 1 — March 19

**Discord intro (post in `#introductions` then excerpt to `#technology-cicero`):**
```
Hi Accord community! I'm Zakir — TypeScript/Node.js developer with
ML/systems background (LangGraph, MCP integrations, multi-agent frameworks).

Applying for GSoC 2026 on "APAP and MCP Server Hardening."

The intersection of legal contracts + AI protocol is genuinely
interesting — I've been building MCP-integrated systems personally,
so this is relevant beyond just GSoC.

Just submitted PR #[N] to [concerto/template-archive] as my first
contribution while getting familiar with the codebase.

GitHub: JiwaniZakir
```

**Target concerto (26 open issues) over cicero/template-archive:**
concerto is more actively maintained with fewer competitors. Browse its 26 issues for unclaimed work.

```
Issue claim comment:
I'd like to work on this for GSoC 2026 (APAP/MCP Hardening).
I've reviewed the codebase and understand the scope.

My approach:
1. [Step 1 — specific]
2. [Step 2 — specific]
3. Test: [specific test]

Starting now.
```

#### Day 2 — March 20

**Technical question in `#technology-cicero`:**
```
Hi @dan.selman @jeromesimeon — working on my GSoC proposal for
MCP Server Hardening.

I've been exploring the APAP server code and noticed that [specific
file/endpoint] doesn't have input validation for [specific field].
This means [specific failure mode].

For the GSoC project: is the priority (a) comprehensive system tests
first, then catch validation gaps via tests, or (b) add validation
directly and test as we go?

Asking because it affects the milestone structure in my proposal.
```

#### Day 3 — March 21

**Share proposal outline:**
```
Hi — GSoC proposal outline for APAP/MCP Hardening:

1. System test suite: 100+ integration tests covering all APAP endpoints
2. Input validation: Zod-based schemas for all POST/PUT endpoints
3. Typed error hierarchy: consistent error format across MCP + APAP
4. MCP Integration Guide: 20+ pages + 3 end-to-end tutorials
5. 5 new MCP tools: validateTemplate, searchTemplates, previewTemplate,
   validateConcertoModel, listTemplates

Key question: Are there specific APAP endpoints that are higher priority
for hardening based on how they're used in production?
```

---

## 4. GreedyBear — Priority #4

### Channels

| Channel | URL / How to Join |
|---------|------------------|
| **Honeynet Discord** | Check honeynet.org or GreedyBear repo for link — look for `#greedybear` or `#gsoc-2026` |
| **GitHub Issues** | https://github.com/intelowlproject/GreedyBear/issues |
| **GitHub Discussions** | https://github.com/intelowlproject/GreedyBear/discussions |

### Key Mentors

| Mentor | GitHub Handle | Role | Response Time |
|--------|--------------|------|---------------|
| **mlodic** | @mlodic | Core maintainer, 267 commits — backend | Same-day reviews observed |
| **regulartim** | @regulartim | Core maintainer, 88 commits — frontend/infra | 24–48h |

**Note:** mlodic reviews and merges same day when PRs are clean. This is good — but means competition is also real-time.

### Day-by-Day Outreach

#### Day 1 — March 19

**Critical first step: scan for unclaimed issues BEFORE posting:**
```bash
# Check which open issues have NO linked PRs
gh api "repos/intelowlproject/GreedyBear/issues?state=open&per_page=50" | jq '.[] | {number, title}'
# Then cross-reference with open PRs to find unclaimed issues
gh api "repos/intelowlproject/GreedyBear/pulls?state=open&per_page=30" | jq '.[] | .body' | grep -o 'Closes #[0-9]*'
```

**Discord intro (after first PR):**
```
Hi Honeynet team! I'm Zakir — Python/Django/security developer.
Applying for GSoC 2026 on GreedyBear's Event Collector API.

Background: I've merged to prowler-cloud/prowler (configurable
CORS via environment variables — security-adjacent Django work),
and built an intelligence platform (aegis) with similar Django/
Celery async patterns to what GreedyBear uses.

Just submitted PR #[N] on issue #[unclaimed issue].
Environment is running.

GitHub: JiwaniZakir
```

**IMPORTANT:** GreedyBear has no CONTRIBUTING.md. Follow the pattern of recent merged PRs:
- Branch from `develop`
- Ruff format
- Fill PR template completely
- Reference `Closes #NNN`

#### Day 2 — March 20

**Technical question for mlodic:**
```
Hi @mlodic — working on the Event Collector API proposal.

I've studied the existing DRF ViewSets and the Django Q2 task queue.
For the EventCollectorToken (scope-based auth), I see two options:

Option A: Extend the existing token auth — simpler migration, less code
Option B: Separate EventCollectorToken model — cleaner isolation,
         allows per-token rate limiting without affecting existing tokens

My lean: Option B because the Event Collector has different rate
limiting needs than the honeypot read API.

Does this match your thinking, or is there an existing approach I
should build on?
```

#### Day 3 — March 21

**ML improvement angle — differentiate from competitors:**
Most competitors are doing frontend fixes or simple backend bug fixes.
Target the ML model layer which has less competition:
```
Hi — I noticed the Random Forest model for event classification
currently doesn't expose feature importances in the API response
(the "Log feature importances" PR just merged adds logging, but
not the API endpoint).

I'd like to add a `/api/ml/feature-importances/` endpoint that exposes
the trained model's feature importances via API, so operators can
understand what signals drive the classification. Would this be a
valuable addition, or is there a reason not to expose this?

Issue: [link to relevant issue or open a new one]
```

#### Day 4 — March 22

**Proposal outline for mentors:**
```
Hi @mlodic @regulartim — GSoC proposal outline for Event Collector API:

Backend:
1. EventCollectorToken model (scope: events:write / events:read)
2. DRF ViewSet with serializer-based input validation
3. Django Q2 async task: validate → normalize → index to Elasticsearch
4. Rate limiting per token (django-ratelimit integration)
5. Status endpoint: event processing tracking
6. >80% test coverage for all new code

Frontend (if time allows):
7. Token management CRUD UI
8. Injection statistics dashboard

Question: For ES indexing — separate index for injected events vs.
T-Pot data, or merge with event_type discrimination?
```

---

## 5. dora-rs — Priority #5

### Channels

| Channel | URL / How to Join |
|---------|------------------|
| **Discord** | Find invite in dora-rs README or repo — look for `#gsoc-2026` |
| **GitHub Discussions** | https://github.com/dora-rs/dora/discussions |
| **GitHub Issues** | https://github.com/dora-rs/dora/issues |

### Key Mentors

| Mentor | GitHub Handle | Role | Response Time |
|--------|--------------|------|---------------|
| **phil-opp** | @phil-opp | Core maintainer, 1940 commits, famous Rust blogger | Reviews within hours |
| **haixuanTao** | @haixuanTao | Core maintainer, 1854 commits | 24–48h |

**Warning:** phil-opp reviews within hours — PRs will get fast feedback, but also Bhanudahiyaa's PRs are being reviewed alongside yours.

### Day-by-Day Outreach

#### Day 1 — March 19

**Discord intro (after first Python-only PR):**
```
Hello dora-rs community! I'm Zakir, applying for GSoC 2026 on
Testing Infrastructure.

Background: I've built 338-test pytest suites for FastAPI services
(aegis) and testing frameworks for multi-agent systems (lattice).

I'm focusing on the Python bindings side — just submitted PR #[N]
on the pyo3 experimental-inspect stubs issue. I'll stay on Python
and docs contributions to avoid overlap with existing Rust work.

GitHub: JiwaniZakir
```

**CRITICAL — Bhanudahiyaa avoidance:**
Do NOT claim any issue related to:
- state management / KV store
- coordinator persistence
- CLI enforcement (`--locked`, `dora.lock`)
- structured health API

All of these are Bhanudahiyaa's territory. Claim issues tagged `python`, `docs`, or `good-first-issue`.

#### Day 2 — March 20

**Use `@dora-bot assign me` to claim:**
```
@dora-bot assign me

I'll work on the pyo3 experimental-inspect migration for the Python
stubs. Estimated time: 2–3 days. I'll post a draft PR within 24h.
```

**Technical question for phil-opp:**
```
Hi @phil-opp — design question for the Testing Infrastructure proposal.

For MockNode in the Python API specifically: should it mock at the
Python operator level (before serialization) or at the IPC/Arrow level
(after serialization)?

Mocking at the operator level is simpler for test authors. Mocking at
IPC level is more faithful to the real execution path.

My instinct: operator-level for unit tests, IPC-level for integration
tests. Two-tier testing utility.

Does this match the team's thinking, or is there a reason to prefer one?
```

#### Day 3 — March 21

**Post design issue (GitHub Issue, not just Discord):**
Create an issue: `[RFC] Python Testing Utilities Design — GSoC 2026`
This shows initiative and starts a public record of your design thinking.

#### Day 4 — March 22

**Proposal outline:**
```
Hi @phil-opp @haixuanTao — GSoC proposal outline for Testing Infrastructure:

1. dora-test-utils crate: MockNode + TestFixture structs
2. Python test bindings: PyMockNode with identical API
3. CI template: GitHub Actions workflow for custom dataflow testing
4. 10+ regression tests for critical dora dataflows
5. Documentation: "How to Test dora Nodes" guide with Python examples

The Python angle is intentional — I can contribute more there given my
background, and it's an underserved part of the testing story.

Any concerns about the Python-first approach?
```

---

## Universal Message Templates

### Introduction Message (Copy-Paste Base)
```
Hi [community]! I'm Zakir — [relevant tech stack match] developer.
Applying for GSoC 2026 on [project title].

I've merged PRs to [most relevant recent merge] and [second most relevant],
which involved [relevant skill]. I've also built [specific personal project
with direct parallel to GSoC project].

Just submitted PR #[N] on [specific issue]. Environment is running.
Happy to contribute beyond my GSoC scope — [specific thing you find
genuinely interesting about the project].

GitHub: JiwaniZakir
```

### Issue Claim Comment
```
I'd like to work on this for GSoC 2026 (applying for [project name]).

I've reviewed the codebase and understand the scope.
My approach:
1. [Specific step with file reference if possible]
2. [Specific step]
3. Test: [what behavior the test will verify]

Starting now — draft PR within [1–3 hours].
```

### PR Description Template
```markdown
## What
[One sentence: what this PR changes]

## Why
[One sentence: why this is needed]
Closes #[issue number]

## How
- [Specific thing changed and where]
- [Any tradeoffs or alternatives considered]

## Testing
- [What tests were added/modified]
- [How to manually verify if applicable]
- CI: green locally (`[command used]`)
```

### Technical Question to Mentors
```
Hi @[mentor handle] — [project] architecture question for my GSoC proposal.

I've been studying [specific file/component] and noticed [specific observation].
This raises a design question:

Option A: [describe]
- Pro: [benefit]
- Con: [cost]

Option B: [describe]
- Pro: [benefit]
- Con: [cost]

My lean: [A/B] because [specific reason tied to the codebase].

Does this align with how you're thinking about it?
```

### Proposal Feedback Request
```
Hi @[mentor] — I've drafted my GSoC proposal for [project title] and would
appreciate a sanity check before I finalize it.

Key deliverables:
1. [Deliverable 1]
2. [Deliverable 2]
3. [Deliverable 3]

My contributions so far: PR #[N] ([status]), PR #[N] ([status]).

Two questions:
1. [Specific question about scope/priority]
2. [Specific question about technical approach]

Happy to share the full draft if useful.
```

### Responding to Code Review Feedback
```
Thanks for the thorough review!

1. **[Reviewer's point]:** [What you changed and why it's better now].
   Updated in [commit hash or "latest commit"].
2. **[Reviewer's point]:** Good catch — I hadn't considered [edge case].
   Added test for this scenario.
3. **[Reviewer's point]:** I'm using [approach] because [reason].
   Happy to change if you prefer [alternative] — just want to understand
   the tradeoff.

CI green. Ready for re-review when you have a moment.
```

### Handling Pushback on a PR
```
Thanks for the feedback — makes sense that [their concern].

I can revise this to [adjusted approach] which should address the concern.
Main change would be [specific thing].

Should I:
(a) Update this PR with the revised approach?
(b) Close this and open a new PR with the cleaner version?

Let me know your preference and I'll get it done today.
```

### Polite PR Bump (After 48h+ No Response)
```
Friendly bump on PR #[N] when you have bandwidth — no rush.

In the meantime, I've also opened PR #[N] on [different issue], so
there's no blocker on my end.
```

---

## What NOT to Do

### Community Behavior Anti-Patterns

1. **Do NOT copy the importer spam pattern (vulnerablecode):** NucleiAv has 6 open importer PRs with ZERO merges. The core team is not interested in more importers right now.

2. **Do NOT work on CLI/state/coordinator features in dora-rs:** Bhanudahiyaa owns this territory completely. Any PR you open here will be compared unfavorably.

3. **Do NOT post generic introductions:** "Hi, I'm interested in GSoC" with no PR link gets ignored. Always post intro AFTER you have a PR up.

4. **Do NOT ask "can I work on X?" without proposing an approach:** Maintainers are busy. Show you've thought about it, not just that you're interested.

5. **Do NOT leave PRs sitting without responding to feedback:** mlodic (GreedyBear) and phil-opp (dora-rs) review within hours/days. If you go silent for 48h, the window closes.

6. **Do NOT duplicate in-progress work:** Always check for open PRs on an issue before claiming it. Prasad8830 already has the feeds filter issue in GreedyBear. Don't submit a competing PR.

7. **Do NOT DM mentors first:** Start in public channels. Only DM after you've built rapport (Day 3+) or for urgent blockers.

8. **Do NOT skip the PR template:** GreedyBear especially — blank sections in the PR template = rejection. Fill everything in.

9. **Do NOT submit PRs without running CI locally:** Every project has a local test command. Run it. Don't let trivially fixable CI failures block your PR from review.

10. **Do NOT over-claim:** Don't say "I'll have this done in 30 minutes" if it needs a day. Mentors track whether you deliver on your stated timelines.

### Tone Anti-Patterns

- "LGTM" on other people's PRs — useless. Leave technical observations instead.
- "+1 I'm interested in this too" — use emoji reactions, not comments
- "I'm a beginner but..." — don't diminish yourself, just show the work
- Defensive responses to code review — always acknowledge feedback gracefully even if you disagree

---

## Mentor Timezone Estimates

| Project | Key Mentor | Estimated Timezone | Best Posting Window (UTC) |
|---------|-----------|-------------------|--------------------------|
| vulnerablecode | pombredanne | France (CET, UTC+1) | 07:00–14:00 UTC |
| dora-rs | phil-opp | Unknown — Europe likely | 07:00–14:00 UTC |
| GreedyBear | mlodic | Italy likely (honeynet.org is Italy-based) | 07:00–14:00 UTC |
| Accord Project | dselman | Unknown | 12:00–20:00 UTC (covers EU + US morning) |
| OCF | peterdudfield | UK (OCF is UK-based) | 08:00–16:00 UTC |

**Optimal global posting window:** 09:00–13:00 UTC — catches Europe morning/midday, covers UK, overlaps with US East Coast afternoon.

---

**Last Updated:** March 19, 2026
