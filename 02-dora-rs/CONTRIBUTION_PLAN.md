# Contribution Plan for dora-rs GSoC 2026

## Overview

This document outlines a structured approach to contributing to dora-rs with the goal of completing the **Testing Infrastructure** GSoC project. The plan is divided into three phases: onboarding and initial contributions, building expertise, and executing the GSoC project scope.

## Important Rules from CONTRIBUTING.md

Before beginning any work, understand these critical project norms:

### Issue Assignment and Ownership
- Use `@dora-bot assign me` in GitHub issues to claim work
- Use `@dora-bot unassign me` to release work
- **Auto-unassignment Policy:** Issues are automatically unassigned after 2 weeks of inactivity
- **Planning Implication:** Plan buffer time for life events; communicate proactively if stuck

### Code Changes
- **Discussion First:** All non-trivial changes must be discussed in a GitHub issue or Discord BEFORE opening a PR
- **What's "non-trivial"?** Anything beyond simple documentation fixes or obvious bug fixes
- **Testing Infrastructure:** Definitely requires upfront discussion about API design
- **Format Check:** MUST run `cargo fmt --all` before submitting any PR

### PR Review and Merge Criteria
- **CI Checks:** All of the following must pass:
  - `CI/Test` — Builds + unit tests on Linux/Windows/macOS
  - `CI/Examples` — Rust/C/C++ example compilation
  - `CI-python` — Python binding tests (Linux only)
  - `CI/Clippy` — Lint check passes without warnings
  - `CI/Formatting` — Code passes rustfmt check
  - `CI/License` — All dependencies have compatible licenses
- **No Unrelated Changes:** Don't fix clippy warnings or style issues in files you're not modifying
- **Code Review:** At least one maintainer approval required

### Release Management
- **Contributor Rule:** Do NOT open unsolicited release PRs (version bumps, CHANGELOG updates)
- **How to Handle:** If a PR is merged and you want it released, request via issue or comment on the merged PR
- **Maintainers Only:** Only project maintainers publish new releases to crates.io

## Phase 1: Onboarding and Foundation (Weeks 1-3)

**Goals:**
- Understand the codebase architecture
- Build and run tests locally
- Make first trivial contributions
- Join community communications
- Establish working relationship with mentors

### Week 1: Setup and Exploration

**Tasks:**

1. **Environment Setup**
   ```bash
   # Clone repository
   git clone https://github.com/dora-rs/dora.git
   cd dora

   # Install Rust if needed
   curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

   # Verify build
   cargo build --workspace
   cargo test --workspace

   # Verify formatting
   cargo fmt --all
   cargo clippy --workspace
   ```

2. **Documentation Review**
   - Read `/CONTRIBUTING.md` (the actual file in repo)
   - Study `/docs/src/` for user-facing documentation
   - Review `/examples/` for common patterns
   - Skim `/dora-daemon/src/`, `/dora-cli/src/` for architecture

3. **Community Engagement**
   - Join Discord: https://discord.com/channels/1146393916472561734/1346181173277229056
   - Introduce yourself in GSoC channel
   - Add message: "Hi, I'm [name], interested in Testing Infrastructure for GSoC 2026"
   - Reach out to mentors: @Alex Zhang, @ZunHuan Wu (if available)

4. **First Issue Analysis**
   - Filter GitHub issues: `label:good-first-issue` or `label:documentation`
   - Read 3-5 simple issues to understand issue tracking style
   - Do NOT claim yet; just read

**Deliverables:**
- Clean local build: `cargo build --workspace` succeeds
- All tests pass: `cargo test --workspace` succeeds
- Discord introduction posted
- 3-5 issue analysis notes (not public)

### Week 2: Documentation Contributions

**Tasks:**

1. **Identify Low-Risk Contributions**
   - Find typos or unclear sections in `/docs/src/`
   - Identify missing examples in documentation
   - Look for outdated CLI help text
   - **Verify these are trivial** (don't need issue discussion)

2. **First PR: Documentation Fix**
   ```bash
   # Create feature branch
   git checkout -b fix/docs-clarification

   # Make edits
   # Example: Fix a typo or clarify an explanation

   # Format and test
   cargo fmt --all
   cargo test --workspace  # Quick sanity check

   # Commit with clear message
   git commit -m "docs: clarify initialization section in user guide"

   # Push and create PR
   git push origin fix/docs-clarification
   ```

3. **Submit PR and Get Feedback**
   - Title: Descriptive but concise
   - Description: Why this change improves documentation
   - Reference any related issues
   - Address review comments professionally

4. **Second PR: Example Improvement**
   - Find an example in `/examples/` that could be clearer
   - Add comments explaining the dataflow
   - Or create a minimal new example showing a common pattern
   - Follow same PR process

**Expectations:**
- Both PRs should merge successfully
- Learn the CI/review cycle
- Build confidence in contribution process

**Deliverables:**
- 2 merged documentation-focused PRs
- Experience with CI pipeline
- Understanding of PR review process

### Week 3: Code Contributions and Mentor Sync

**Tasks:**

1. **Claim a Small Code Issue**
   - Look for: `good-first-issue`, `bug`, or `low-effort` labels
   - Examples: Fix a clippy warning, improve error message, add unit test for existing function
   - **CRITICAL:** Before claiming, comment in the issue: "I'd like to work on this for GSoC onboarding"
   - Wait for maintainer OK before starting work

2. **Code PR: Bug Fix or Improvement**
   ```bash
   # Use @dora-bot to assign
   # In issue comment: @dora-bot assign me

   # Create branch
   git checkout -b fix/issue-number-description

   # Make change (keep small and focused)
   # Add tests if appropriate

   # Full test cycle
   cargo fmt --all
   cargo clippy --workspace
   cargo test --workspace

   # Commit and push
   ```

3. **Mentor Introduction Meeting**
   - Schedule async or sync with Alex Zhang and ZunHuan Wu
   - Share your GSoC interest in Testing Infrastructure
   - Discuss high-level approach
   - Get guidance on next steps

4. **Review Project Roadmap**
   - Study the Testing Infrastructure gap in ARCHITECTURE.md
   - Read related issues: #1456, #1454, #1452 (understand context)
   - Understand what "test utilities" and "mock APIs" mean in this codebase

**Deliverables:**
- 1 small code PR merged
- Mentor contact established
- Clear understanding of Testing Infrastructure gap

## Phase 2: Building Expertise (Weeks 4-7)

**Goals:**
- Develop deeper understanding of testing patterns
- Contribute higher-impact changes
- Design and propose Testing Infrastructure solution
- Refine GSoC proposal based on feedback

### Week 4-5: Testing Deep Dive

**Tasks:**

1. **Analyze Current Testing Practices**
   - Read all test files in `/tests/`
   - Understand how daemon is tested
   - Understand how nodes are tested
   - Identify pain points and gaps
   - Document findings in a private note

2. **Explore Testing Patterns in Rust Ecosystem**
   - Research mock libraries: `mockall`, `proptest`, `test-case`
   - Research test fixtures in Rust
   - Study how other middleware projects (e.g., ROS2, Zenoh) structure tests
   - Review relevant crates on crates.io

3. **Contribute Test Improvements**
   - Add tests for currently untested code paths
   - Improve existing test organization
   - Claim 2-3 testing-related issues
   - Goal: Understand what makes tests hard to write/maintain

4. **Design Discussion with Mentors**
   - Share findings: Current testing gaps
   - Propose high-level approach for `dora-test-utils`
   - Discuss API design: How should tests mock node behavior?
   - Get feedback on feasibility

**Deliverables:**
- 2-3 test-related PRs merged
- Testing gap analysis document (shared with mentors)
- Initial API design sketch for `dora-test-utils`

### Week 6-7: Proposal Development

**Tasks:**

1. **Study GSoC Project Definition**
   - Reread the Testing Infrastructure project scope
   - Align proposed solution with scope
   - Identify success criteria

2. **Draft Technical Proposal**
   - Detailed approach: How will you build `dora-test-utils`?
   - Architecture: What modules/traits will the crate expose?
   - Example: Show how a test would use it
   - Timeline: Realistic 12-week breakdown
   - Deliverables: What will exist at midterm? At final?

3. **Community Feedback Loop**
   - Post proposal draft in Discord GSoC channel
   - Invite feedback from mentors and community
   - Refine based on responses
   - Address potential concerns

4. **Polish PROPOSAL_DRAFT.md**
   - Incorporate feedback
   - Add rationale: Why is this project valuable?
   - Add "about me" section with relevant experience
   - Include links to contributions so far

**Deliverables:**
- Polished proposal draft ready for GSoC submission
- Mentors have reviewed and approved direction
- Community understands your approach

## Phase 3: GSoC Project Execution (Weeks 8-12+)

**Goals:**
- Execute Testing Infrastructure project
- Build `dora-test-utils` crate
- Create CI templates
- Improve overall test coverage
- Complete quality milestones

### Weekly Cadence

**Week Start (Monday)**
- Sync with mentors: What's blocked? What's priorities?
- Review previous week's progress
- Adjust plan if needed

**Mid-Week Check-in (Wednesday)**
- Discord async update in GSoC channel
- Any blockers? Ask for help
- Share learnings

**Week End (Friday)**
- Prepare PR for review
- Ensure all CI checks pass
- Update documentation
- Plan next week

### Milestone Structure (Midterm and Final)

**Midterm Evaluation (Week 6 of GSoC)**
- `dora-test-utils` crate exists with core API
- Mock node framework implemented
- At least 5 example tests written
- Documentation for testing patterns
- All code reviewed and merged
- Mentors sign off on progress

**Final Evaluation (Week 12 of GSoC)**
- `dora-test-utils` complete and published
- Regression testing helpers fully implemented
- CI/CD templates created and documented
- Test coverage improved across codebase (metrics)
- Performance benchmarks for test harness
- Final documentation and examples
- All deliverables merged to main branch

### Testing Infrastructure Scope

**Core Deliverables:**

1. **dora-test-utils Crate**
   ```rust
   // Proposed structure
   dora-test-utils/
   ├── src/
   │   ├── lib.rs
   │   ├── mock_node.rs        // Mock node implementations
   │   ├── test_fixture.rs      // Test harness
   │   ├── regression.rs        // Regression testing framework
   │   └── ci_templates.rs      // CI/CD pattern generators
   └── tests/
       └── integration/
   ```

2. **Mock Node API**
   - Allow isolated testing of node logic without daemon
   - Support all language bindings (Rust, Python, C/C++)
   - Provide input/output mocking
   - Example:
   ```rust
   #[test]
   fn test_node_logic() {
       let mock = MockNode::new("my_node");
       mock.send_input("input_topic", test_data);
       let output = mock.receive_output("output_topic", timeout);
       assert_eq!(output, expected_output);
   }
   ```

3. **Regression Testing Framework**
   - Define test dataflows declaratively
   - Run them in isolation
   - Verify outputs match expected results
   - Support snapshot testing

4. **CI Templates**
   - GitHub Actions template for testing custom dataflows
   - Docker container for isolated test environments
   - Matrix testing (different Rust versions, platforms)

**Success Criteria:**
- 80%+ code coverage improvement in tested modules
- 10+ regression tests for critical dataflows
- Documentation that explains testing patterns
- Mentors and community positive feedback

## Commit Message Guidelines

All commits should follow this format:

```
<type>(<scope>): <subject>

<body>

<footer>
```

**Types:** feat, fix, docs, style, refactor, test, chore
**Scope:** The module being changed (e.g., dora-test-utils, dora-daemon)
**Subject:** Imperative mood, lowercase, ~50 characters
**Body:** Explain what and why, not how; ~72 character lines
**Footer:** Reference issues: "Fixes #1234"

**Examples:**
```
feat(dora-test-utils): add MockNode struct for isolated testing

Implement MockNode to allow testing node logic without daemon.
Supports message injection and output capture.

Fixes #1455
```

```
docs(dora-test-utils): document testing patterns and examples

Add comprehensive guide on how to write tests using dora-test-utils,
including mock node setup, fixture creation, and regression testing.
```

## PR Template (Use When Submitting)

```markdown
## Description
Brief explanation of what this PR does.

## Related Issues
Fixes #XXXX

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Documentation update
- [ ] Testing enhancement

## Testing
Describe how this was tested. What test cases did you add?

## Checklist
- [ ] Code passes `cargo fmt --all`
- [ ] Code passes `cargo clippy --workspace`
- [ ] New tests added (if applicable)
- [ ] Documentation updated (if applicable)
- [ ] All CI checks pass
```

## Risk Mitigation

### Risk: 2-Week Auto-Unassignment
**Mitigation:**
- Plan work in 1-2 week chunks
- If stuck, reach out to mentors within 3 days
- Update issue with progress regularly
- If life event occurs, comment in issue: "I need to pause this; will resume on [date]"

### Risk: Scope Creep
**Mitigation:**
- Agree on MVP (Minimum Viable Product) with mentors early
- Say "no" to feature requests; scope is 175 hours
- Track time spent
- Prioritize: Core utilities > Examples > Optimizations

### Risk: CI Failures
**Mitigation:**
- Run full test suite locally before pushing: `cargo test --workspace`
- Use GitHub's "allow edits from maintainers" to let mentors push fixes
- Ask in Discord if CI fails mysteriously
- Don't force-push unless absolutely necessary

### Risk: Proposal Rejection
**Mitigation:**
- Get mentors' approval on proposal draft BEFORE GSoC deadline
- Align scope with available hours (175 = 5 weeks full-time)
- Be realistic about dependencies on other PRs merging

## Communication Templates

### When Claiming an Issue
```
Hi! I'd like to work on this as part of my GSoC 2026 onboarding
for the Testing Infrastructure project.

Quick question: Should I approach this by [describe your approach]?

@dora-bot assign me
```

### When Stuck
```
I've been working on [issue], but I'm blocked on [specific problem].
Could someone point me toward [resource/documentation/example] or
clarify [specific question]?

Thanks!
```

### When Ready for Review
```
This PR implements [feature]. It adds [concrete changes].

I've verified:
- [X] cargo fmt --all passes
- [X] cargo test --workspace passes
- [X] Examples still work
- [X] Documentation updated

Ready for review!
```

## Success Indicators

**Week 3:** 1 code PR merged, mentors engaged
**Week 7:** Testing infrastructure proposal approved
**Midterm:** Core dora-test-utils crate merged, 5+ tests written
**Final:** Complete project delivered, merged, and documented

---

**Document Version:** 1.0
**Last Updated:** March 18, 2026
**Owner:** zakirjiwani
**Next Review:** After GSoC submission deadline
