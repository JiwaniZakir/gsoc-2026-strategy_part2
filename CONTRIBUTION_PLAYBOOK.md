# Open Source Contribution Playbook

A practical guide to standing out as a GSoC applicant and contributing effectively to open source projects.

---

## 1. Standing Out as a GSoC Applicant

### What Actually Matters

GSoC reviewers see hundreds of applications. Here's what separates strong candidates from noise:

#### Meaningful Contributions Over Volume

- **Don't:** Open 10 trivial PRs (typo fixes, minor refactors with no clear value)
- **Do:** Open 2–3 PRs that show you understand the codebase, testing philosophy, and project needs
- One PR that fixes a real bug with proper tests beats five typo fixes

#### Deep Codebase Understanding

- Mentors want someone who grasps *architecture*, not just syntax
- Reference specific design patterns used in the codebase
- Show you've read the contribution guide, architecture docs, and existing PRs carefully
- In your proposal, mention specific files/modules you've studied

**Example:** "I noticed the validation layer uses a decorator pattern across the auth modules. I'm proposing to extend this to the API gateway layer, which currently has inline checks."

#### Constructive Community Participation

- Answer questions in issues/discussions (even if you're new—show effort)
- Leave thoughtful code review comments on other PRs
- Ask *smart* questions: "I see you're using X pattern here. Does that mean Y is handled in Z module?" vs. "How do I run this?"
- Show respect for maintainers' time; they remember contributors who *reduce* their workload

#### Proposal That Matches Project Reality

- Don't propose your dream feature; propose what the maintainers actually need
- Reference open issues, project roadmaps, and recent discussions
- Show you've talked to mentors (or at least engaged with the community)
- Be specific about deliverables: "Implement X endpoint with Y test coverage, returning Z API contract"

---

## 2. Writing PRs That Get Merged Fast

### The Anatomy of a Fast-Merging PR

#### Title and Link

```
[BAD] Fix stuff
[GOOD] Fix race condition in connection pool shutdown

Closes #437
```

- Title should clearly state the problem or change
- Link to the issue immediately (GitHub auto-links with "Closes #123")
- Saves maintainers from wondering *why* you're changing things

#### Description: What / Why / How

```markdown
## What
Fixes a race condition where pending connections are not properly
cleaned up during connection pool shutdown.

## Why
When the app receives a SIGTERM, the pool shutdown completes before
all in-flight requests finish, leaving connections open and causing
file descriptor leaks. This is especially noticeable under high load.

## How
- Added a graceful shutdown timeout (configurable, default 30s)
- Queue pending connections in a thread-safe deque during shutdown
- Wait for active connections to finish before closing
- Tests added in test_pool_shutdown.rs

## Testing
- Unit tests for timeout and cleanup edge cases
- Integration test with 100 concurrent connections
- Manual test: `./scripts/test_shutdown_leak.sh`
```

#### Small, Focused Changes

- **One responsibility per PR**
- If you need 1000 lines, consider if it's actually 2 PRs
- Maintainers are more likely to merge a 50-line focused change than a 500-line refactor + feature combo

**Example split:**
- PR 1: Refactor validation layer (only refactoring, no behavior change)
- PR 2: Add new validation rule (only new logic, uses refactored layer)

#### Screenshots or Visual Evidence (When Applicable)

If touching UI, include a before/after screenshot.

```markdown
## Before
[screenshot of broken button alignment]

## After
[screenshot of fixed layout]
```

#### Test Coverage Proof

```markdown
## Tests
- [x] Unit test for happy path
- [x] Unit test for timeout scenario
- [x] Integration test with real connection pool
- [x] No existing tests broken (CI green)

Test results: 127 passed, 0 failed
Coverage added: pool_shutdown.rs (95%)
```

#### Addressing CI Failures Immediately

If tests fail:
1. Don't ignore them
2. Fix them *in the same PR* (or ask in a comment if you need guidance)
3. Maintainers see unresolved CI failures as "not ready"

```markdown
## CI Status
- [x] Tests passing (was failing in commit abc123, fixed in d4e5f6)
- [x] Linter passing
- [x] Type checks passing
```

---

## 3. Professional Open Source Communication

### First Message to the Community

**Context:** You're introducing yourself as someone who wants to contribute during GSoC.

```markdown
Hi [project name] team! I'm Zakir, a CS student interested in
[specific project area, e.g., "dataflow systems and Rust"]. I've
been exploring the codebase and am excited about [specific feature
or issue, e.g., "the new scheduler redesign in issue #521"].

I'd like to contribute meaningfully over the next few weeks and
eventually apply for GSoC. I'm starting with [specific issue/area],
and I'd appreciate any guidance on the best approach.

Thanks for building this project!
```

**What works:**
- Specific (not "I like your project")
- Shows you've done homework
- Clear intent (GSoC applicant)
- Asks for *guidance*, not approval
- Respectful tone

### Asking Smart Questions

**Bad question:**
```
How do I make a PR? The build is broken. Help?
```

**Good question:**
```
I'm working on issue #234 (adding retry logic). I see the config
is loaded in main.rs, but where should the retry_policy struct be
defined? I've checked config.rs and builder.rs but didn't find the
pattern used elsewhere. Any pointers?
```

**Why it works:**
- Shows you tried first
- Specific location reference
- Demonstrates you read the code
- Easy to answer (5-second pointer vs. teaching you how to PR)

### Responding to Code Review

**Reviewer comment:**
```
Why use a HashMap here instead of a BTreeMap? Insertion order
matters for the output, so BTreeMap seems more semantically correct.
```

**Bad response:**
```
OK I'll change it
```

**Good response:**
```
You're right, I didn't consider the ordering requirement. I used
HashMap for the O(1) lookup in the inner loop (line 42), but
BTreeMap's O(log n) insertion won't be the bottleneck there since
we only have ~100 entries. I'll switch to BTreeMap to make the
intent clearer and match the pattern used in data_builder.rs.

Thanks for catching that!
```

**Why it works:**
- Shows you understand the trade-off
- Explains your original thinking (not defensive)
- Demonstrates you thought about performance
- References similar code in the project
- Grateful tone

### Following Up Without Being Pushy

**Don't:**
```
Hi, I commented on my PR 3 days ago. When will you merge it?
```

**Do:**
```
FYI, I've addressed the review comments in commit abc123.
No rush—let me know if there's anything else I can help with!
```

**Or if it's been a week:**
```
Friendly bump on #456 when you have time. In the meantime,
I'm working on issue #234 if you'd like to see a draft.
```

---

## 4. Common Mistakes to Avoid

### Claiming Issues Without Following Up

```markdown
[BAD] "I'll fix issue #123" (then ghosting for 2 weeks)
```

**Impact:** Maintainer can't assign the issue, others can't start; trust erodes.

**Fix:** Only claim an issue when you're starting *that day*. If you need to step back, say so immediately.

```markdown
[GOOD] "I'm starting on #123 today. I'll have a first PR up by
Thursday."

[Also GOOD] "I started on #123 but hit a blocker with [specific
thing]. Can you point me to docs on [area]? If I'm stuck after
researching, I'll let you know so others can pick it up."
```

### Massive, Unfocused PRs

```
PR #999: "Add features and refactor stuff"
- Rename 50 files
- Refactor the entire validation layer
- Add 3 new API endpoints
- Fix 2 bugs
- Add some tests

[1,500 lines changed]
```

**Why this is bad:**
- Impossible to review in one session
- Risk of one bad part blocking the whole thing
- Hard to revert if something breaks
- Shows lack of project prioritization

**Fix:** Split into 4–5 PRs:
1. File renames (mechanical, easy to review)
2. Validation layer refactor (bigger, but single-purpose)
3. New API endpoints (feature, depends on #2)
4. Bugfix #1
5. Bugfix #2

### Not Reading the Contribution Guide

```
[BAD]
- No commit message format (guide says "Closes #X: description")
- Wrong test file location (guide says tests/ not test/)
- TypeScript in a Rust project, no explanation
- No PR template filled out
```

**Fix:** Before you write code, read:
1. CONTRIBUTING.md or CONTRIBUTING/ folder
2. CODE_OF_CONDUCT.md
3. Recent merged PRs (to see the pattern)
4. Linter config (.eslintrc, .clippy.toml, etc.)

Literally take 20 minutes. It's the difference between a mergeable PR and rework.

### AI-Generated Code Without Review

```
[BAD]
# Generated entire PR with ChatGPT
# Didn't understand half of it
# Submitted with "Let me know if this works"
```

**Why it fails:**
- LLMs hallucinate; code doesn't always match the project's patterns
- Maintainers can tell (inconsistent style, overengineered solutions)
- Shows you didn't learn anything
- Tests are often incomplete

**What to do instead:**
- Use LLMs for brainstorming, not wholesale generation
- Understand *every line* you submit
- Test thoroughly before submitting
- Add comments explaining why you chose that approach (especially if non-obvious)

```markdown
[GOOD]
I used ChatGPT to help sketch the algorithm, then:
- Rewrote it to match the project's error handling pattern
  (Result<T> with custom Error types)
- Added all test cases I could think of
- Verified it performs within SLA on large datasets
- Checked style against existing code

Tests: 42 passed, coverage 89%
```

### Ignoring CI Failures

```
[BAD]
PR #123 submitted
- Linter failing (red X)
- 3 tests failing (red X)
- "Looks good to me!"
```

**Fix:** Always run locally first:
```bash
cargo test
cargo clippy --all-targets
cargo fmt --check
npm test  # or equiv
npm run lint
```

Don't submit until these pass. It signals you care about quality.

---

## 5. Handling PR Rejection Gracefully

### When a Maintainer Says "No"

**Scenario:** Your PR is closed with "This doesn't fit our roadmap right now."

**Don't:**
```
Why? This feature is important! You should reconsider.
```

**Do:**
```
Thanks for the feedback. I understand this isn't aligned with the
current roadmap. For future contributions, are there specific areas
you'd prioritize over this? I want to focus on issues that move the
project forward.
```

**What happened:**
- You acknowledged their decision
- You asked for guidance (shows growth mindset)
- You repositioned for the *next* contribution
- You didn't burn bridges

### When Code Review Asks for Major Changes

**Reviewer:** "This approach won't scale to 10,000 items. Can you redesign?"

**Options:**

**Option A: Iterate (Often the right call)**
```
Good point about scalability. Let me redesign using a
priority queue instead of a Vec. I'll have a revised
version by [day].
```

**Option B: Discuss if unsure**
```
I see the concern about scale. Before I redesign,
would you prefer:
A) Priority queue (better insert perf, worse memory)
B) Lazy-loaded batching (more complex, best perf)

What aligns better with the project's constraints?
```

**Option C: Withdraw gracefully (Rare, but valid)**
```
You're right, this approach has fundamental limits I didn't
anticipate. I'll step back and study the codebase more before
tackling this. Thanks for the honest feedback!
```

### Extracting Lessons

After rejection or major rework, do this:

1. **Understand why** — Ask if you're not clear
2. **Document it** — "Oh, they always prefer X over Y" (helps next time)
3. **Don't dwell** — Move to the next issue (maintainers notice this resilience)

```markdown
[In your notes]
- Accord Project: Prefers TypeScript interfaces over types
  (saw this in 3 PRs, confirmed in review comment)
- dora-rs: Always wants perf benchmarks if touching critical path
- GreedyBear: Very strict on input validation, even in internal APIs
```

---

## 6. Template Messages

### Template: First Message to a Project

```markdown
Hi [project name] team! I'm [your name], a CS student interested
in [specific area, e.g., "systems programming and Rust"]. I've been
exploring the codebase and am impressed by [something specific,
e.g., "the modular architecture of the dataflow engine"].

I'm planning to contribute meaningfully over the next few weeks and
would like to apply for GSoC 2026. I'm starting with [specific
issue, e.g., "improving test coverage in the scheduler module"],
and I'd appreciate any guidance on the best approach or things to
watch out for.

Thanks for building this project. I'm excited to contribute!
```

### Template: Issue Comment (Asking to Work on Something)

```markdown
Hi! I'd like to work on this issue. I've looked at the codebase
and have a rough approach in mind:

1. [Step 1, specific]
2. [Step 2, specific]
3. [Step 3, specific]

I have a question about [specific thing]: [question]

I'll open a draft PR by [date] and would love feedback on the
approach before I finish the implementation. Thanks!
```

### Template: PR Description

```markdown
## Summary
[One sentence what this PR does]

## Problem
[What problem does this solve?]

## Solution
[How does this PR solve it? Approach and key design decisions]

## Testing
- [ ] Unit tests added
- [ ] Integration tests added
- [ ] Manual testing done (describe how)

## Checklist
- [ ] Followed contribution guidelines
- [ ] Tests passing locally
- [ ] No breaking changes
- [ ] Documentation updated (if applicable)

## Related
Closes #[issue number]
Related to #[other issue number] (if applicable)
```

### Template: Code Review Response

```markdown
Thanks for the review! I've addressed the comments:

1. **[Point 1]:** Changed to [change]. This [why it's better].
2. **[Point 2]:** Good catch. I didn't consider [thing].
   Changed to [approach], which [benefit].
3. **[Point 3]:** I explored [alternative], but stuck with
   [current] because [reason]. Open to other thoughts though!

Updated in commit [hash]. Tests still passing.
```

### Template: Mentor Outreach

```markdown
Hi [mentor name],

I'm [your name], a CS student interested in contributing to
[project] during GSoC 2026. I've been working on [specific
contribution], and I wanted to reach out because [reason]:

- I'm considering proposing [specific idea] for my GSoC project
- I'd like guidance on [specific technical question]
- I wanted to make sure [idea] aligns with the project roadmap

I'm planning to [concrete next step] by [date], and I'd appreciate
any thoughts or feedback when you have time.

Thanks for your time!
```

---

## Summary: The GSoC Edge

**What works:**
- Show up, stay present, keep learning
- Make 2–3 *great* contributions, not 10 okay ones
- Read before you code
- Engage genuinely with the community
- Propose something that *matters* to the project, not just you

**What doesn't:**
- Volume of PRs
- Ignoring feedback
- Assuming you know better
- Ghosting on claimed issues
- Overselling yourself

Maintainers pick GSoC contributors they'd *want to work with*. Be that person.

---

**Last Updated:** March 18, 2026
