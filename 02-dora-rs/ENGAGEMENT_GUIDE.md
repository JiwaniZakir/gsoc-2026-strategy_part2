# dora-rs: Engagement Guide

**Priority:** #5 — Minimum investment, Python/docs only
**Community:** dora-rs Discord + GitHub Discussions
**Key contacts:** phil-opp (@phil-opp), haixuanTao (@haixuanTao)

---

## Intelligence Update (March 19) — READ FIRST

**Bhanudahiyaa** submitted 9 PRs in 48 hours:
- coordinator KV store, state persistence, CLI enforcement, OpenTelemetry
- 3 already merged
- They are systematically building a coherent feature set as a GSoC proposal in action

**Your strategy:** Python bindings only. Do not compete with Bhanudahiyaa on Rust/CLI/state.

**Bhanudahiyaa-free zones:**
- Python bindings (pyo3 experimental-inspect stubs)
- Getting Started documentation
- Progress bars (CLI UX, not architecture)
- Python operator API bugs

---

## Channels

| Channel | URL | Notes |
|---------|-----|-------|
| **Discord** | Find invite in README | Join `#gsoc-2026` |
| **GitHub Discussions** | https://github.com/dora-rs/dora/discussions | For design RFCs |
| **GitHub Issues** | https://github.com/dora-rs/dora/issues | Use `@dora-bot assign me` |

---

## Mentor Profiles

### phil-opp (@phil-opp)
- 1,940 commits — famous Rust blogger (blog.phil-opp.com)
- Reviews within HOURS — fastest reviewer of all 5 projects
- **Approach:** Your PR will be reviewed fast. Be ready to respond to feedback quickly.
- Tag as `@phil-opp` in issues/discussions

### haixuanTao (@haixuanTao)
- 1,854 commits — Python/robotics focus likely
- Good for: Python binding questions, robotics use cases
- **Approach:** For Python-specific questions, haixuanTao may be more relevant than phil-opp

---

## Day 2 — March 20: First (and Likely Only) PR

**No Day 1 activity here** — Day 1 is fully allocated to vulnerablecode, OCF, and Accord. Come to dora-rs on Day 2 after the first wave of PRs is submitted elsewhere.

### Step 1: Scan for Open Python Issues

```bash
gh api "repos/dora-rs/dora/issues?labels=python&state=open&per_page=20" \
  | jq '.[] | "\(.number): \(.title)"'

gh api "repos/dora-rs/dora/issues?labels=good-first-issue&state=open&per_page=20" \
  | jq '.[] | "\(.number): \(.title)"'
```

### Step 2: Claim with @dora-bot

On your chosen issue:
```
@dora-bot assign me

I'll work on [specific issue description]. This is the Python-side
implementation — focusing on pyo3 stubs/Python operator API.

Estimated timeline: 1–2 days. Draft PR within 24h.
```

### Step 3: Discord Intro (After PR is Submitted)

Post in `#gsoc-2026`:
```
Hello dora-rs community! I'm Zakir, applying for GSoC 2026 on
Testing Infrastructure.

Background: Built 338-test pytest suite for a FastAPI service (aegis)
and testing infrastructure for a multi-agent framework (lattice).
Python is my primary language — focusing on the Python bindings
side of the testing utilities.

Just submitted PR #[N] on [pyo3 stubs / Python operator issue].

GitHub: JiwaniZakir
```

---

## Day 2 (Late): Technical Question for phil-opp

Post in `#gsoc-2026` or as a GitHub Discussion:
```
Hi @phil-opp — design question for the Testing Infrastructure proposal
(Python side specifically).

For MockNode in the Python API:
Option A: Mock at the Python operator level (before Arrow serialization)
  — simpler for test authors, less faithful to real execution
Option B: Mock at the IPC/Arrow level (after serialization)
  — more faithful, but requires understanding Arrow schema

My instinct: two-tier — Option A for unit tests, Option B for integration
tests. The dora-test-utils Python package would expose both.

Does this make sense given how the Python bindings actually work?
```

---

## Day 3 — March 21: Design Issue (GitHub, Not Discord)

Create a GitHub issue titled: `[RFC] Python Testing Utilities Design — GSoC 2026`

This creates a public record of your design thinking and gives phil-opp and haixuanTao a concrete artifact to respond to — more durable than a Discord message.

Template in [CONTRIBUTION_PLAN.md](./CONTRIBUTION_PLAN.md).

---

## Day 4 — March 22: Proposal Share

Post in `#gsoc-2026`:
```
GSoC proposal outline for feedback (Testing Infrastructure — Python focus):

1. dora-test-utils crate: MockNode + TestFixture
2. Python test bindings: PyMockNode with equivalent API
3. CI template: GitHub Actions for Python dataflow testing
4. 10+ regression tests for critical Python dataflows
5. Docs: "How to Test Python dora Nodes" guide

Python-first angle: Python node developers currently have no mocking
or fixture utilities. This proposal builds the testing layer they need
without duplicating the Rust testing work.

Does this scope feel right? Any re-prioritization suggested?
```

---

## Day 5 — March 23: Final Summary

```
GSoC contribution summary (dora-rs):

PR this week:
- PR #[N]: [pyo3 stubs / Python issue] — [status]
- Design RFC: [link to GitHub issue]

Submitting proposal tomorrow. Thanks @phil-opp for the fast review!

GitHub: JiwaniZakir
```

---

## Response Templates

### When phil-opp Reviews Your PR (Fast — Be Ready)

```
Thanks @phil-opp — addressed feedback:

1. [Comment]: [What you changed]. cargo fmt --all — clean.
2. [Comment]: [What you changed]. cargo clippy — no warnings.
3. [Comment]: Good call — I changed approach to [X] because [reason
   that shows you understood the feedback].

cargo test --workspace: all pass. CI green. Ready for re-review!
```

---

## Handling Bhanudahiyaa's Presence

Do NOT:
- Comment on their PRs competitively
- Open issues in the same feature areas
- Acknowledge the competition in community messages

DO:
- Simply work in your lane (Python/docs)
- Let your Python contributions speak for themselves
- If you're in a Discord discussion and Bhanudahiyaa is present, engage technically and professionally

---

## Proposal Framing — Why Python Testing is the Gap

> "dora-rs has a strong Rust testing story but the Python operator ecosystem has no equivalent. Python is the primary language for ML/robotics node development, yet there's no MockNode, no TestFixture, and no CI template that works with Python dataflows. This GSoC project closes the Python testing gap specifically, serving the robotics and AI node developers who primarily write Python."

This framing:
1. Doesn't conflict with any of Bhanudahiyaa's work
2. Addresses a real and documented gap
3. Uses Zakir's Python strength
4. Is a coherent, bounded scope

---

**Last Updated:** March 19, 2026 (post-intelligence rewrite)
**Mentors:** Alex Zhang, ZunHuan Wu

---

## Day 1 — March 19: First Contact

### Post in Discord `#gsoc-2026`

```
Hello dora-rs community! I'm Zakir — CS student, Rust background,
interested in Testing Infrastructure for GSoC 2026.

A bit of context: I've built testing infrastructure before — a 338-test
suite for a FastAPI server (aegis project on my GitHub) and a regression
framework for an ML evaluation toolkit (spectra). The dora testing gap
— specifically the lack of MockNode — is a problem I've solved in other
forms and want to fix here properly.

I've built the repo locally, all tests pass, and I've been reading
through /tests/ to understand current patterns. Just submitted PR #NNN
(docs clarification) while getting familiar with the codebase.

GitHub: JiwaniZakir. Looking forward to contributing.
```

### Claim Your First Issue

In the issue comment box:
```
I'd like to work on this as part of my GSoC 2026 onboarding for
Testing Infrastructure. Starting now.

@dora-bot assign me
```

Wait for `@dora-bot` to confirm assignment. If no response in a few hours, proceed (bot may be slow) but update the issue with a progress note.

---

## Day 2 — March 20: Technical Depth

### Post a Specific Technical Question in `#gsoc-2026`

```
Question for @AlexZhang or @ZunHuanWu:

I've been studying how nodes communicate with the daemon internally
(looking at dora-daemon/src/ and the IPC channel code).

For MockNode design, I see two possible approaches:
A) Mock at the IPC level — inject serialized messages into channels
B) Wrap the actual node binary — intercept system calls

Option A seems simpler but might miss runtime bugs. Option B catches
more but adds complexity.

My leaning is Option A for v1 since it makes tests fast and deterministic.
Is that consistent with how you're thinking about it?
```

**Why this works:** You've done the homework (studied the IPC code). You're proposing a concrete design direction. You're asking for alignment, not asking to be taught.

---

## Day 3 — March 21: Open Design Issue

### Open a GitHub Issue

Title: `[Proposal] dora-test-utils: Testing Infrastructure API Design — GSoC 2026`

This is the formal record of your design thinking. Write it in the issue body:
- Problem statement (quote specific issues #1456, #1454, #1452)
- Proposed API (show actual Rust code)
- 3–4 open questions for maintainers

Tag: `@AlexZhang @ZunHuanWu`

**Important:** This issue becomes a reference in your proposal. Every mentor who sees your proposal should be able to click through to this issue and see a substantive technical conversation.

### Comment on an Existing Issue

Find an open issue related to testing or CI. Leave a substantive comment that adds value:
- Additional context you found while studying the code
- A related edge case they may not have considered
- A pointer to a relevant crate or pattern you found

---

## Day 4 — March 22: Proposal Feedback

### Discord Message

```
Hi @AlexZhang @ZunHuanWu — sharing my GSoC proposal outline:

Testing Infrastructure Deliverables:
1. dora-test-utils crate: MockNode + TestFixture + snapshot regression
2. Python node testing support (MockNode wrapper)
3. GitHub Actions CI template for custom dataflows
4. 10+ regression tests added to dora-rs itself
5. Documentation: "Writing Tests for dora Nodes"

Timeline: MockNode (w1-3) → TestFixture+snapshots (w4-6) →
Language bindings (w7-8) → Integration + docs (w9-11) → Polish (w12)

Question: For the midterm checkpoint, is "MockNode merged and 5 tests
written" a strong enough deliverable, or should I include TestFixture too?

Full draft available if you want to review.
```

---

## Day 5 — March 23: Final Visibility

### Contribution Summary Post

```
GSoC application summary before submitting tomorrow:

PRs submitted to dora-rs this week:
- PR #NNN: [docs clarification] — [merged/under review]
- PR #MMM: [code contribution] — [under review]

Design discussion opened: Issue #PPP (Testing Infrastructure API)

I've been focused on understanding the IPC internals and the daemon
lifecycle — both are essential to getting MockNode right.

Thanks for the engagement this week. Looking forward to (hopefully)
working on this full-time in May.
```

---

## Response Templates

### When Your PR Gets Reviewed

```
Thanks for the thorough review!

Addressing all comments:

1. **Re: [comment about formatting/style]:** Fixed in commit [hash].
   I ran `cargo fmt --all` and `cargo clippy --workspace` — clean now.

2. **Re: [comment about approach]:** You're right that [their concern].
   I changed [what] to [what new thing] to address this.
   New approach: [brief explanation].

3. **Re: [question about design]:** I chose [X] because [reason].
   If you prefer [Y], I can change — just want to understand the tradeoff.

CI green. Ready for re-review!
```

### When Asking Alex or ZunHuan for Guidance

```
Hi @AlexZhang — I'm working on [specific thing] and hit a design question.

Context: I'm implementing [component] and the decision I'm facing is
[specific choice between A and B].

I've looked at [specific file/code] which suggests [your interpretation].

Question: [single specific question]

I can do it either way — just want to make sure the approach aligns
with how you're thinking about the architecture.
```

### Polite Bump After 48h

```
Friendly bump on PR #NNN when you have bandwidth.
In the meantime, I've been working on [next thing] to keep momentum.
```

---

## The dora-bot Workflow

Every time you want to work on an issue:
```
@dora-bot assign me
```

If you need to release it (life event, blocker, wrong scope):
```
@dora-bot unassign me
```

Never let an issue sit 5+ days without a progress update. The 2-week auto-unassignment exists for a reason — respect it.

---

## What Mentors Are Looking For

Alex Zhang and ZunHuan Wu have evaluated GSoC applicants before. Based on past selections:

1. **Rust competency proof:** They need to see you can actually write Rust before accepting a 175-hour Rust project. Your contributions must have real code, not just docs.
2. **Design thinking:** The Testing Infrastructure project requires API design skill. Show this through the design issue and your Discord questions.
3. **Process discipline:** dora-rs is strict about `cargo fmt`, no unrelated changes, discussion-before-PR. Following these rules perfectly signals you'll be reliable to work with.
4. **Realistic timeline:** Proposals that claim too much for 175 hours get rejected. Prioritize `MockNode → TestFixture → Snapshots` and be clear Python/C is stretch.

**Zakir's edges:**
- Rust + testing infrastructure background is rare and directly relevant
- The lattice multi-agent framework experience maps onto dora's testing problem
- Systems-level thinking about IPC and daemon lifecycle

---

**Last Updated:** March 19, 2026
