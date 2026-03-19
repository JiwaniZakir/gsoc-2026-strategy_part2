# VulnerableCode: Engagement Guide

**Priority:** #1 — Put the most community energy here
**Community:** Gitter (gitter.im/aboutcode-org/vulnerablecode) + GitHub Discussions
**Key contacts:** TG1999, keshav-space, pombredanne

---

## Why This Project Gets the Most Outreach Energy

- 756 open issues = longest relationship runway
- Competitors are doing the WRONG thing — your differentiated approach will stand out
- Python/ML stack = strongest narrative for your proposal
- More merges here = more selection signal

---

## Channels (Priority Order)

1. **Gitter** — `https://gitter.im/aboutcode-org/vulnerablecode` — primary real-time channel
2. **GitHub Discussions** — for longer technical discussions
3. **GitHub Issue comments** — for claiming issues and showing design thinking
4. **IRC** — `#aboutcode` on Libera.Chat — secondary, less active

---

## Mentor Profiles

### TG1999 (@TG1999)
- 598 commits, most recently active
- Merging: API changes, architecture work (recent: "Store advisory content hash", "Review all v2 pipelines")
- NOT merging: importer PRs from NucleiAv/Tednoob17
- **Approach:** Show you understand the v2 pipeline architecture. Reference his recent PRs.

### keshav-space (@keshav-space)
- 465 commits, implementation depth
- Good for: implementation questions, testing patterns, debugging
- **Approach:** Technical questions about the importer framework and data models

### pombredanne (@pombredanne)
- 458 commits, founder
- Good for: architecture decisions, project direction
- Timezone: France (CET) — post before 15:00 UTC for same-day response
- **Approach:** Big-picture design questions, NLP pipeline architecture alignment

---

## Day 1 — March 19: Join + First Intro

### Step 1: Join Gitter

Sign in at gitter.im with GitHub account. Join the vulnerablecode room.

### Step 2: Post Intro (AFTER first PR is submitted)

Post in Gitter main channel:
```
Hi AboutCode! I'm Zakir — Python/ML developer applying for GSoC 2026
on NLP/ML vulnerability detection.

Background relevant to this project:
- Merged PR to huggingface/transformers (CPU computation bug) — large unfamiliar Python ML codebase
- Built spectra: RAG evaluation toolkit with confidence scoring + entity extraction pipelines
- Built aegis: intelligence platform that extracts structured entities from unstructured reports
- Lattice: multi-agent framework with confidence-based reasoning

These are the exact skills the NLP pipeline needs: entity extraction, confidence scoring, structured output from unstructured text.

I've set up the local environment, run pytest (all passing), reviewed CONTRIBUTING.rst, and just submitted:
- PR #[N]: [sort packages newest-to-oldest / your first issue]

My plan: API/UI features and architecture improvements — not importers.

GitHub: JiwaniZakir
```

**Key elements:**
- Reference SPECIFIC merged PRs (huggingface/transformers — the flagship)
- Mention specific personal projects with direct parallels
- Signal you know the right lane (NOT importers)
- Link GitHub profile

### Step 3: DCO Setup

```bash
git config --global user.name "Zakir Jiwani"
git config --global user.email "jiwzakir@gmail.com"
# Every commit needs -s:
git commit -s -m "your message"
```

---

## Day 2 — March 20: Technical Depth Signal

### Post Architecture Question in Gitter

```
Hi @TG1999 @keshav-space — design question for my GSoC NLP proposal.

I've been studying the network access patterns in the importers.
Each importer makes its own requests.get() calls without centralized
timeout or retry. The "use centralized function for all network access"
issue seems like important infrastructure for the NLP pipeline too —
an NLP importer scraping mailing list archives will need robust
retry/backoff more than a static advisory feed.

Two options I'm considering for the centralized function:
Option A: utils.fetch_url(url, timeout=30, retries=3) — simple function
Option B: NetworkSession class — injectable, mockable in tests

My lean: Option B because it makes NLP importer tests cleaner — you
can inject a mock session and test the extraction logic independently
of network calls.

Does this align with how the team is thinking about the architecture?
```

**Why this works:**
- Shows you've read the codebase deeply (specific issue + files)
- Demonstrates NLP-specific thinking (not just generic)
- Presents options + a reasoned preference
- Asks a real question rather than fishing for compliments

### Leave a Substantive Comment on a PR

Find one of NucleiAv's open importer PRs. Leave a technical observation:
```
Looking at this importer — I noticed that if the advisory URL returns
a 5xx error, the importer will silently fail (no exception logged,
no retry). The existing [RepoImporter] handles this differently by
[method].

Not blocking the PR, just noting this for the "centralized network
access" issue (#[N]).
```

This shows:
1. You've read multiple files in the codebase
2. You're thinking about cross-cutting concerns (not just your own PR)
3. You're aware of the open issues

---

## Day 3 — March 21: Establish Presence + Proposal Share

### Post Proposal Outline in GitHub Discussions

```markdown
# [GSoC 2026] NLP/ML Vulnerability Detection — Proposal Outline

Hi — posting my draft outline for early feedback before I finalize.

## Problem
VulnerableCode's data coverage is limited to sources with structured
advisory formats. High-value vulnerability intelligence exists in
mailing lists, GitHub issues, changelogs, and security blogs —
unstructured text that can't be ingested by current importers.

## Proposed Solution
An NLP pipeline that extracts structured vulnerability data from
unstructured text, with confidence scoring and an operator review
queue for low-confidence extractions.

## Deliverables

1. **NLPExtractor**: Named entity recognition for CVE IDs, package names,
   version ranges, severity. Based on spaCy + HuggingFace transformers.
2. **ConfidenceScorer**: Per-field + aggregate confidence (0.0–1.0)
3. **15+ TextFetcher implementations**: mailing list archives, PyPI/npm/cargo
   changelogs, GitHub security advisories, NVD descriptions
4. **NLPImporter**: Hooks into existing importer framework
5. **Operator review queue**: Django admin view for low-confidence records
6. **Centralized network access utility**: Resolves issue #[N] as a
   concrete deliverable (robust retry/backoff for all importers)

## Key Technical Questions for Mentors
1. Is a separate `PendingAdvisory` staging model in scope, or should
   low-confidence records use an existing status field?
2. For the fine-tuned NER model: is there labeled training data available,
   or is dataset creation part of the project scope?
3. Priority order for TextFetcher sources: mailing lists first, or PyPI/npm?

GitHub: JiwaniZakir
```

---

## Day 4 — March 22: Mentor Alignment

### Follow Up on Proposal Feedback

If TG1999 or pombredanne responded:
```
Thanks for the feedback @[mentor]!

I've updated the proposal based on your points:
1. [Their point] → Changed to [new approach]. Reason: [why this is better]
2. [Their point] → Added [specific thing] to Week [N] deliverables

Updated the staging model question: I'll go with [Option A/B] based
on your guidance about [specific thing they said].

One remaining question: [specific open question]

Full draft available here: [link to gist if ready]
```

---

## Day 5 — March 23: Final Summary

### Post Contribution Summary in Gitter

```
GSoC 2026 contribution summary before I submit my proposal tomorrow:

PRs this week:
- PR #[N]: [Sort packages newest-to-oldest] — [merged/in review]
- PR #[N]: [Centralized network access utility] — [merged/in review]
- PR #[N]: [Severities vectors UI improvement] — [merged/in review]
- PR #[N]: [CURL advisories data source] — [merged/in review]

Key things I learned that shaped my proposal:
- The v2 pipeline architecture (TG1999's recent work) changes how NLP importers should integrate
- The importer framework's Advisory output format is the right integration point
- Network access centralization is actually infrastructure work, not just a refactor

Thank you @TG1999 @keshav-space @pombredanne for the reviews, feedback
on the proposal, and being welcoming to new contributors.

This is exactly the work I want to spend a summer on.
```

---

## Response Templates

### When TG1999/keshav-space Reviews Your PR

```
Thanks for the thorough review!

1. **DCO:** Added `-s` to all commits. Updated.
2. **[Their formatting comment]:** Ran `black . && isort .` — clean.
3. **[Their code comment]:** Good catch — [explanation of what you changed and why].
   Updated in commit [hash].
4. **[Design comment]:** I was using [approach] because [reason]. Happy to change
   to [their preferred approach] — I can see why [their reason is valid].

CI green. Ready for re-review when you have a moment!
```

### When Asking About NLP Architecture

```
Hi @[mentor] — architecture question for [specific component]:

Context: I'm designing [part of NLP pipeline] and need to decide
between [option A] and [option B].

Option A: [describe]
- Pro: [benefit specific to this codebase]
- Con: [cost in terms of this codebase]

Option B: [describe]
- Pro: [benefit]
- Con: [cost]

My preference: [A/B] because [specific reason that shows codebase knowledge].

But I want to make sure this aligns with the v2 pipeline direction —
I've seen TG1999's recent API design PR and want to stay consistent.
```

---

## What Mentors Are Looking For (Based on Intelligence)

1. **Not another importer** — they see through importer spam immediately
2. **Understanding of the v2 pipeline** — TG1999's recent work is the future direction
3. **NLP/ML credibility** — demonstrate you've actually built extraction pipelines, not just read about them
4. **Confidence scoring design thinking** — the hard part of the project is not the NER, it's the confidence + review workflow
5. **DCO compliance** — non-negotiable, all commits signed

**Zakir's edge:**
- spectra (RAG eval) = confidence scoring for ML pipeline output — exact parallel
- aegis (intelligence platform) = entity extraction from unstructured text — exact parallel
- transformers merge = proven ability to work in large ML codebases
- prowler merge = security-adjacent Python work

Reference all four in mentor conversations.

---

**Last Updated:** March 19, 2026 (post-intelligence rewrite)
