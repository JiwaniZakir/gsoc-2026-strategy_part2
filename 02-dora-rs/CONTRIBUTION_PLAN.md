# dora-rs: 5-Day Blitz Contribution Plan

**Project:** Testing Infrastructure (`dora-test-utils`)
**Mentors:** Alex Zhang, ZunHuan Wu
**Proposal deadline:** March 24, 2026
**Stack:** Rust, Python bindings

---

## CRITICAL RULES (Read Before Writing Any Code)

1. **`@dora-bot assign me`** in issue comments to claim work
2. **Non-trivial changes require issue/Discord discussion first** — the test infrastructure *is* non-trivial
3. **`cargo fmt --all` before every commit** — CI will reject without it
4. **Do NOT open release PRs** — maintainers only
5. Auto-unassignment after 2 weeks of inactivity

---

## Day 1 — March 19: Setup and First PR

### Hour-by-Hour

**08:00–09:00 — Build Verification**
```bash
git clone https://github.com/dora-rs/dora.git
cd dora
cargo build --workspace          # Verify clean build
cargo test --workspace           # All tests pass
cargo fmt --all                  # No formatting issues
cargo clippy --workspace         # No lint warnings
```

**09:00–10:30 — Documentation Issue Hunt**
- Browse `https://github.com/dora-rs/dora/issues?q=label%3Adocumentation`
- Browse `https://github.com/dora-rs/dora/issues?q=label%3Agood-first-issue`
- Best targets: Clarify an unclear section in `/docs/src/`, add comments to a complex example in `/examples/`, fix outdated CLI help text
- Read 3–5 issues before picking one

**10:30–12:00 — First PR**

Pick a documentation fix that requires no API discussion:
```bash
git checkout -b docs/clarify-NNN-description

# Make the change in /docs/src/ or /examples/

cargo fmt --all  # Always run this
cargo test --workspace  # Sanity check

git commit -m "docs: clarify [specific section] for new contributors"
git push origin docs/clarify-NNN-description
```

Open PR. Title: `docs: [what you improved]`. Link the issue. Short but complete description.

**12:00–13:00 — Discord Intro**

In dora-rs Discord `#gsoc-2026`:
```
Hello dora-rs community! I'm Zakir, CS student with systems/Rust background.
Interested in Testing Infrastructure for GSoC 2026.

Background: I've built testing infrastructure before —
338-test suite for a FastAPI server (aegis repo) and a multi-agent
framework (lattice). The dora testing gap is something I genuinely
want to fix.

Just submitted PR #NNN (docs clarification) while getting oriented.
Currently studying the test structure in /tests/ and the daemon
architecture.

GitHub: JiwaniZakir
```

**13:00–15:00 — Testing Gap Analysis**

Read every file in `/tests/`:
- What are they testing?
- How are they structured?
- What's missing? (node isolation, mock daemon, regression fixtures)
- Write down 5 specific gaps

**15:00–17:00 — Study Relevant Issues**
- Read issues #1456, #1454, #1452 carefully
- These are the proof points for the testing gap
- Note specific quotes you can use in your proposal

**17:00–19:00 — Proposal Skeleton**
Write title + synopsis + 4 key deliverables in PROPOSAL_DRAFT.md.

---

## Day 2 — March 20: Second Contribution

**Target:** Second PR submitted. Deeper technical engagement.

### Tasks

**08:00–09:00** — Check PR #1 status. Respond to all feedback immediately.

**09:00–12:00** — **PR #2: Example Improvement or Small Code Contribution**

If no code PR yet, target:
- Add a comment/explanation to a complex example in `/examples/`
- Improve an error message in a well-understood part of the codebase
- Add a unit test for an existing function in a non-critical module

**Do NOT** claim a testing infrastructure issue yet — that requires discussion first (Day 3).

```bash
git checkout -b improve/NNN-description
# Make change
cargo fmt --all && cargo clippy --workspace && cargo test --workspace
git commit -m "feat(examples): add explanation for [specific pattern]"
git push origin improve/NNN-description
```

**12:00–14:00** — Post testing gap analysis in `#gsoc-2026`:
```
Question about Testing Infrastructure GSoC project:

I've been studying the test structure in /tests/ and noticed:
1. [Specific gap 1 — file reference]
2. [Specific gap 2 — file reference]
3. [Specific gap 3]

My reading: these gaps mean [consequence for node developers].
Does this match the motivation behind the GSoC project?

Also: for the MockNode API — is the key design constraint
thread-safety, or primarily ergonomics for the test author?
```

**14:00–17:00** — Write full Technical Approach section in PROPOSAL_DRAFT.md

**17:00–21:00** — Study MockNode design patterns in Rust ecosystem:
- `mockall` crate
- `tokio-test` patterns
- How existing node tests work (any in `/tests/`)

---

## Day 3 — March 21: Open the Design Conversation

**Target:** Testing infrastructure discussion opened with mentors. Proposal 80% complete.

### Tasks

**09:00–11:00** — **Open a Design Discussion Issue**

Create a GitHub issue titled: `[Proposal] Testing Infrastructure API Design — GSoC 2026`

Content:
```markdown
## Context
I'm applying for GSoC 2026 (Testing Infrastructure project) and want to
align my proposal API design with what would actually work for the codebase.

## Proposed dora-test-utils Public API

### MockNode
```rust
let mut node = MockNode::new("my_processor")
    .with_input("camera/image", InputType::Arrow)
    .with_output("result/image", OutputType::Arrow);

node.inject_input("camera/image", test_data);
node.tick();
let output = node.drain_output("result/image");
assert_eq!(output.len(), 1);
```

### TestFixture
```rust
let fixture = TestFixture::from_dataflow("examples/pipeline.yaml")
    .with_timeout(Duration::from_secs(5));
fixture.run()?;
let output = fixture.capture_output("final_output");
```

## Questions
1. Should MockNode wrap the actual node binary, or mock at the IPC level?
2. Is supporting Python node testing in scope for v1, or Rust-only?
3. Which existing test in /tests/ should I model the fixture setup after?
```

Tag @AlexZhang and @ZunHuanWu.

**11:00–13:00** — If no big PR yet, submit **PR #2** as a small code contribution (test for an existing function, or clippy-fix that isn't already being worked on).

**13:00–15:00** — Community review: comment on 2 open PRs in dora-rs with substantive observations.

**15:00–21:00** — Complete Timeline + Deliverables + About Me sections of proposal.

---

## Day 4 — March 22: Polish

**Target:** Proposal review-ready. Engage with any mentor response to Day 3 issue.

### Tasks

**09:00–11:00** — Address all PR feedback. Check if mentors responded to the design issue.

**11:00–12:00** — If mentors responded to design issue, post a thoughtful reply incorporating their feedback. Show you read and understood it.

**12:00–14:00** — Post in `#gsoc-2026`:
```
Sharing my draft proposal outline before finalizing — any feedback appreciated:

Testing Infrastructure for dora-rs — Key Deliverables:
1. dora-test-utils crate: MockNode + TestFixture + regression helpers
2. CI/CD template for custom dataflow testing
3. 10+ regression tests for critical dora-rs dataflows
4. Docs: "How to Test dora Nodes" guide

Timeline: 12 weeks / MockNode (w1-3) → TestFixture+snapshots (w4-6) →
Language bindings + CI (w7-9) → Polish + integration (w10-12)

Does this scope feel right for 175 hours? Any re-prioritization?
```

**14:00–21:00** — Write and finalize the complete proposal.

---

## Day 5 — March 23: Submit

**Target:** Proposal submitted. PRs in clean state.

### Tasks

**09:00–12:00** — Final proposal pass. Verify:
- Every deliverable is concrete (code artifact, not just "will implement")
- Timeline midterm checkpoint is specific
- About Me references specific Rust/testing experience

**12:00–15:00** — Address any remaining PR feedback.

**15:00–17:00** — Post contribution summary in `#gsoc-2026`.

**17:00–20:00** — Submit proposal.

---

## March 24: Submit Day

- Verify proposal on GSoC portal
- Ensure all PRs are still active (not stale)
- `@dora-bot unassign me` any issues you're not progressing (keep your reputation clean)

---

## Commit Message Format (Required)

```
<type>(<scope>): <subject>

[optional body]

[optional footer: Fixes #NNN]
```

Types: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`

Examples:
```
docs(examples): clarify message passing in pipeline example
test(dora-daemon): add unit test for connection cleanup
feat(dora-test-utils): add MockNode struct for isolated testing
```

---

## PR Checklist (Every PR)

- [ ] `cargo fmt --all` passes
- [ ] `cargo clippy --workspace` passes (no warnings)
- [ ] `cargo test --workspace` passes
- [ ] Examples still build
- [ ] No unrelated changes (especially no clippy fixes in untouched files)
- [ ] Commit message follows format above
- [ ] PR description explains the "why"

---

**Last Updated:** March 19, 2026
**Mode:** 5-day blitz
