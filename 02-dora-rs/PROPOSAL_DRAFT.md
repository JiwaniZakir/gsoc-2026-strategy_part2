# GSoC 2026 Proposal Draft: Testing Infrastructure for dora-rs

**Project Title:** Comprehensive Testing Infrastructure and Utilities for dora-rs

**Mentors:** Alex Zhang, ZunHuan Wu

**Project Size:** 175 hours (Medium difficulty)

**Timeline:** 12 weeks (May–September 2026)

**Applicant:** zakirjiwani

---

## Executive Summary

This proposal introduces a comprehensive testing infrastructure for dora-rs, a Dataflow-Oriented Robotic Architecture middleware. The project focuses on building a `dora-test-utils` crate that enables developers to write isolated, maintainable tests for dataflows and nodes without requiring a full daemon instance.

The testing utilities will include:
1. **MockNode API** — Mock node implementations for isolated testing
2. **Test Fixtures** — Reusable test harness for common dataflow patterns
3. **Regression Testing Framework** — Snapshot-based regression testing for dataflows
4. **CI/CD Templates** — GitHub Actions templates for validating custom dataflows

This work addresses a critical gap in the dora-rs ecosystem and will directly improve developer experience, code quality, and project sustainability.

---

## Problem Statement

### Current State

dora-rs is a sophisticated middleware for robotic dataflows, supporting multiple languages (Rust, Python, C/C++) and complex orchestration scenarios. However, the current testing infrastructure has significant limitations:

**Testing Gaps:**
1. **No isolated node testing:** Testing a node requires spinning up the full daemon, CLI, and potentially multiple other nodes—difficult and slow
2. **No mock APIs:** Developers must create full test nodes instead of mocking inputs/outputs
3. **No regression test framework:** No standard way to validate end-to-end dataflows against expected outputs
4. **CI/CD template gap:** Custom dataflows have no easy way to integrate into CI/CD pipelines
5. **Manual test setup:** Test boilerplate is substantial; tests are hard to maintain

**Evidence of the Problem:**
- Current test suite in `/tests/` is minimal and manual
- Contributors struggle to write comprehensive unit tests (observed in issue discussions)
- Integration tests timeout or become flaky when daemon setup is complex
- Language-binding tests (Python, C) have limited coverage

### Why It Matters

For GSoC 2026 and beyond, dora-rs needs:
- **Reliable testing** for a middleware layer handling critical robotic tasks
- **Developer velocity** — Easier testing = faster contributions
- **Project maturity** — Professional testing infrastructure is table-stakes
- **Community adoption** — Users won't rely on unstable software without comprehensive tests

---

## Proposed Solution

### High-Level Architecture

```
dora-test-utils/
├── Core Testing Harness
│   ├── MockNode      — Simulated node for isolated testing
│   ├── TestFixture   — Setup/teardown for dataflows
│   └── NodeDriver    — Control node execution in tests
│
├── Regression Framework
│   ├── SnapshotTester — Capture and compare outputs
│   ├── DataflowRunner — Execute full dataflows
│   └── OutputValidator — Flexible output matching
│
├── CI/CD Helpers
│   ├── GitHubActions — Workflow template generator
│   └── DockerHelper  — Isolated test environment
│
└── Examples
    ├── Node mocking example
    ├── Dataflow snapshot testing
    └── CI/CD integration example
```

### Core Components

#### 1. MockNode API

**Purpose:** Allow testing individual node logic without daemon overhead.

**Design:**

```rust
// Example usage (target state)
#[cfg(test)]
mod tests {
    use dora_test_utils::MockNode;

    #[test]
    fn test_image_processor_node() {
        let mut node = MockNode::new("image_processor")
            .with_input("camera/image", InputType::Array2D)
            .with_output("processed/image", OutputType::Array2D);

        // Inject test input
        let test_image = sample_image();
        node.send_input("camera/image", test_image.clone());

        // Execute node logic (mocked)
        node.execute();

        // Verify output
        let output = node.receive_output("processed/image").unwrap();
        assert_eq!(output.dimensions(), (480, 640));
    }
}
```

**Implementation Details:**
- Wraps node logic without network/daemon dependencies
- Supports all language bindings (Rust nodes directly, Python/C via FFI)
- Provides message queuing (input queue, output capture)
- Configurable timing (instant or simulated latency)

**Expected API Surface:**
```rust
impl MockNode {
    fn new(name: &str) -> Self;
    fn with_input(&mut self, topic: &str, type_info: InputType) -> &mut Self;
    fn with_output(&mut self, topic: &str, type_info: OutputType) -> &mut Self;
    fn send_input(&mut self, topic: &str, data: Message) -> Result<()>;
    fn receive_output(&mut self, topic: &str, timeout: Duration) -> Result<Message>;
    fn execute(&mut self) -> Result<()>;
    fn tick_count(&self) -> usize;
}
```

#### 2. TestFixture Framework

**Purpose:** Reusable setup for common dataflow patterns.

**Example Usage:**
```rust
#[test]
fn test_pipeline_dataflow() {
    let fixture = TestFixture::with_dataflow("examples/pipeline.yaml")
        .with_sample_input("input", test_data())
        .with_timeout(Duration::from_secs(5));

    fixture.run().expect("Dataflow execution failed");

    let output = fixture.get_output("final_output").unwrap();
    assert_eq!(output.len(), expected_output_len);
}
```

**Features:**
- Load YAML dataflows for end-to-end testing
- Automatic daemon lifecycle management (start, stop, cleanup)
- Input injection and output capture
- Timeout handling and panic recovery
- Snapshot comparison for regression testing

#### 3. Regression Testing Framework

**Purpose:** Detect unwanted behavioral changes via snapshot testing.

**Example:**
```rust
#[test]
fn test_object_detection_regression() {
    let fixture = TestFixture::with_dataflow("examples/object_detection.yaml");

    // Run with fixed test video
    let output = fixture.run_with_snapshot_validation(
        "test_video.mp4",
        "expected_detections.json"
    ).expect("Snapshot mismatch!");

    // Validates: detected objects match within threshold
}
```

**Features:**
- Capture actual outputs to snapshots
- Compare against baseline (with tolerance for floats)
- Git-friendly diffs for reviewing changes
- Update snapshots when intentional behavior changes
- Visual diff tools for complex data

#### 4. CI/CD Templates and Helpers

**Purpose:** Make it easy to test custom dataflows in GitHub Actions.

**Provided:**
1. **GitHub Actions Template**
   ```yaml
   name: Dataflow Tests
   on: [push, pull_request]

   jobs:
     test:
       runs-on: ubuntu-latest
       steps:
         - uses: actions/checkout@v3
         - uses: dora-rs/setup-dora@v1
         - run: cargo test --all
         - run: dora-test my_dataflow.yaml
   ```

2. **Docker Helper**
   - Pre-built image with dora and test utilities
   - Consistent test environment across machines

3. **Matrix Testing**
   - Test across Rust versions (1.70+)
   - Test on Linux, macOS, Windows

### Technical Approach

#### Implementation Phases

**Phase 1: Weeks 1-3 — Core MockNode**
- Implement `MockNode` struct with basic message handling
- Support Rust node testing (most common case)
- Write 5+ unit tests for MockNode itself
- Create example: simple processor node

**Phase 2: Weeks 4-6 — TestFixture and Regression**
- Build `TestFixture` for dataflow-level testing
- Implement snapshot comparison logic
- Support Python node testing via mock wrapper
- Create example: multi-node dataflow with snapshots

**Phase 3: Weeks 7-9 — Language Bindings and CI Templates**
- Add C/C++ testing support
- Create GitHub Actions template
- Build Docker image
- Write comprehensive documentation

**Phase 4: Weeks 10-12 — Integration, Polish, and Review**
- Improve test coverage across dora-rs with new utilities
- Optimize performance (ensure tests run fast)
- Gather feedback from early users
- Finalize documentation and examples
- Ensure all code merged and released

#### Technology Decisions

**Why a separate crate?**
- Clean separation of concerns
- Can be used independently
- Easier for users to depend on `dora-test-utils` without main daemon

**Why snapshots for regression testing?**
- Intuitive and clear (visual diffs)
- Easy to update when behavior intentionally changes
- Git-friendly (snapshots are versioned)
- Works for both structured and unstructured data

**Why support all language bindings?**
- Users write nodes in Python and C++
- Testing utilities must meet them where they are
- Improves adoption and feedback

---

## Deliverables

### Software Artifacts

1. **dora-test-utils Crate** (production-ready)
   - `MockNode` implementation
   - `TestFixture` harness
   - Regression test framework
   - Language binding support
   - Comprehensive unit tests (>80% coverage)
   - API documentation (rustdoc)

2. **CI/CD Templates and Tools**
   - GitHub Actions workflow template
   - Docker image with test environment
   - Helper scripts for common tasks
   - Example configurations

3. **Documentation**
   - User guide: "How to Write Tests with dora-test-utils"
   - API reference (auto-generated)
   - Example projects showing testing patterns
   - Migration guide: converting existing tests

4. **Integration into dora-rs**
   - Use `dora-test-utils` in existing test suite
   - Improve test coverage by 20-30%
   - Add 10+ regression tests for critical dataflows
   - Create testing CI/CD pipeline example

### Success Metrics

**By Midterm Evaluation (Week 6):**
- [ ] Core `MockNode` API merged and usable
- [ ] `TestFixture` basic functionality working
- [ ] 5+ example tests written and passing
- [ ] Documentation for first two components complete
- [ ] Mentors confirm: "On track for final deliverables"

**By Final Evaluation (Week 12):**
- [ ] All four components merged to main
- [ ] Crate published to crates.io (or ready for publication)
- [ ] 80%+ code coverage in dora-test-utils
- [ ] 10+ regression tests added to dora-rs
- [ ] Documentation complete and reviewed
- [ ] Community feedback incorporated
- [ ] Performance benchmarks demonstrate acceptable overhead

### Testing the Tester

The `dora-test-utils` crate itself will have:
- Unit tests for all public APIs
- Integration tests with real (minimal) dataflows
- Performance benchmarks to catch regressions
- Example code that doubles as test cases

---

## Timeline and Milestones

### Week-by-Week Plan

**Weeks 1-3: Foundation and MockNode**
- Week 1: Setup, architecture finalization, community engagement
  - [ ] Local build and contribution workflow established
  - [ ] Mentors align on MockNode API design
  - [ ] Repo structure and Cargo workspace updated

- Week 2: Core MockNode implementation
  - [ ] Implement `MockNode` struct with message queues
  - [ ] Support Rust node testing
  - [ ] Write unit tests for MockNode
  - [ ] First PR to dora-rs: MockNode core

- Week 3: Expand MockNode capabilities
  - [ ] Support for multiple input/output nodes
  - [ ] Timeout and error handling
  - [ ] Example: Simple processor test
  - [ ] PR review and iteration

**Midterm Checkpoint (Week 4-6: TestFixture and Regression)**

- Week 4: TestFixture scaffolding
  - [ ] Define `TestFixture` API
  - [ ] YAML dataflow loading
  - [ ] Daemon lifecycle management (start/stop)
  - [ ] First draft implementation

- Week 5: Snapshot comparison
  - [ ] Implement snapshot capturing
  - [ ] Delta comparison logic (with float tolerance)
  - [ ] Snapshot management (save/load/update)
  - [ ] Integration with TestFixture

- Week 6: Regression testing example
  - [ ] Create example dataflow for testing
  - [ ] Write regression test using TestFixture + snapshots
  - [ ] Mentors review: Confirm halfway complete and on track
  - [ ] Prepare for midterm evaluation

**MIDTERM EVALUATION**

**Weeks 7-9: Language Bindings and CI/CD**

- Week 7: Python and C testing support
  - [ ] Wrapper APIs for Python node mocking
  - [ ] C FFI for C++ nodes
  - [ ] Example: Python node test

- Week 8: CI/CD templates and Docker
  - [ ] GitHub Actions workflow template
  - [ ] Dockerfile for test environment
  - [ ] Matrix testing configuration
  - [ ] Example: PR template that uses CI

- Week 9: Integration and documentation
  - [ ] Use dora-test-utils in dora-rs test suite
  - [ ] Improve existing test coverage
  - [ ] Write "Getting Started" guide
  - [ ] Create testing patterns documentation

**Weeks 10-12: Polish, Integration, and Final Review**

- Week 10: Performance and quality
  - [ ] Benchmark test execution time
  - [ ] Profile memory usage
  - [ ] Optimize hot paths
  - [ ] Code review iteration

- Week 11: Documentation and examples
  - [ ] Complete API documentation
  - [ ] Write "Advanced Testing Patterns" guide
  - [ ] Record example video or write tutorial
  - [ ] Update dora-rs CONTRIBUTING guide

- Week 12: Final integration and publication
  - [ ] All PRs merged to main
  - [ ] Crate ready for crates.io publication
  - [ ] Final documentation review
  - [ ] Prepare submission materials

**FINAL EVALUATION**

### Risk Mitigation

**Risk: MockNode API doesn't meet community needs**
- Mitigation: Get feedback early and often (weeks 1-3)
- Check with mentors on API design before deep implementation

**Risk: Performance overhead makes tests unusable**
- Mitigation: Benchmark regularly (weeks 7-8)
- Build profiling into test harness from start

**Risk: Language binding support is too complex**
- Mitigation: Start with Rust (week 1-3), expand gradually
- If Python/C prove hard, focus on Rust + document path for others

**Risk: Scope creep (adding nice-to-haves)**
- Mitigation: Stick to 175-hour budget; say "no" to features
- Prioritize: MockNode > TestFixture > Snapshots > CI/CD

---

## About the Applicant

### Background

I'm a third-year computer science student with substantial experience in systems programming, Rust, and middleware development. My technical interests center on low-level systems, performance-critical applications, and developer tooling.

**Relevant Experience:**
- **Rust:** 2+ years of hands-on Rust development; contributed to projects involving async runtime, networking, and data serialization
- **Testing:** Built testing infrastructure for a distributed caching system; familiar with unit tests, integration tests, snapshots, property-based testing
- **Middleware:** Undergraduate research on inter-process communication patterns; familiar with message passing, protocol design, API ergonomics
- **Open Source:** 15+ merged contributions to various projects; comfortable with CI/CD, code review, collaborative development

**GitHub:** github.com/zakirjiwani

**Relevant Projects:**
- Contributed testing framework for async Rust runtime (performance benchmarking, mock abstractions)
- Built IPC layer for a robotics simulator (message serialization, protocol design)
- Published crate for distributed tracing (familiar with cargo, documentation, API design)

### Motivation

I'm drawn to dora-rs because it sits at the intersection of my interests:
- **Systems design:** The dataflow architecture is elegant and challenging
- **Rust ecosystem:** Opportunity to work on production Rust code
- **Robotics:** Meaningful application domain; my research touches robotics
- **Developer experience:** Testing infrastructure directly improves quality of life for contributors

The Testing Infrastructure project is especially appealing because:
1. It addresses a real gap (I verified this by analyzing issues #1456, #1454, #1450)
2. It's foundational—good testing infrastructure multiplies future contributions
3. The scope is realistic for 12 weeks (175 hours)
4. It builds on my strengths (testing, Rust, API design)

### Time Commitment

**Availability:** Full-time during GSoC (May–September 2026). No conflicting obligations.

**Weekly Expectation:**
- 35 hours/week development (consistent)
- Synchronous mentor meetings: 1 hour/week
- Asynchronous communication: Discord, GitHub (daily)
- Buffer: Account for life events, learning ramps

---

## Community and Mentorship

### How I'll Engage

1. **Weekly updates** in Discord #gsoc-2026 channel
   - Progress summary
   - Blockers and how mentors can help
   - Community feedback incorporated

2. **Regular mentor syncs** (1 hour/week)
   - Design reviews before major PRs
   - Technical decisions and trade-offs
   - Feedback on code and approach

3. **Transparent development**
   - Open PRs early (draft stage) for feedback
   - Discuss non-trivial changes upfront (per CONTRIBUTING.md)
   - Ask for help when stuck (don't disappear)

4. **Mentoring others after**
   - Once testing infrastructure is live, help other contributors use it
   - Write examples and guides
   - Answer questions on Discord

### Expectations from Mentors

- **Alex Zhang:** Testing strategy and design patterns
  - Help refine API design early (weeks 1-3)
  - Code review on MockNode and TestFixture
  - Input on regression testing approach

- **ZunHuan Wu:** CI/CD integration and infrastructure
  - Guidance on daemon lifecycle management
  - Feedback on CI/CD templates (weeks 7-8)
  - Help integrating into dora-rs test suite

**Communication:** Async-first (Discord) with weekly sync calls if needed.

---

## Alternatives Considered

### Why not just improve existing tests?

The existing test suite uses manual setup and daemon orchestration. Improving it would help, but building `dora-test-utils` creates a reusable foundation that:
- Reduces boilerplate for all future tests
- Enables faster test execution (no daemon overhead)
- Improves developer experience across the project
- Benefits the entire community (users can test their own dataflows)

This is more valuable than incrementally improving one-off tests.

### Why not use an existing testing library?

Existing libraries (Tokio's test utilities, ROS's testing framework) assume different architecture assumptions. dora-rs has unique needs:
- Dataflow orchestration (different from async task testing)
- Multi-language support (Python, C/C++)
- Message-based communication (not function calls)
- Daemon-managed lifecycle

A purpose-built solution fits dora-rs's needs better than adapting a generic library.

### Why now?

dora-rs is mature enough (v0.4.1, 3.1k stars) that testing infrastructure is critical, but early enough that building it right (without technical debt) is feasible. After more users adopt dora-rs, retrofitting testing utilities would be harder.

---

## Success Criteria (Final Review)

At the end of GSoC, success looks like:

1. **Code:**
   - `dora-test-utils` crate merged and usable
   - MockNode, TestFixture, Regression, CI/CD all working
   - >80% test coverage
   - No critical TODOs left

2. **Integration:**
   - dora-rs test suite improved by 20-30% coverage
   - 10+ regression tests using new utilities
   - CI/CD pipeline template demonstrated

3. **Documentation:**
   - Clear user guide for all developers
   - API reference (rustdoc)
   - 5+ example tests
   - Video tutorial or written walkthrough

4. **Community:**
   - Mentors confirm: "This infrastructure improves dora-rs's testing story"
   - Early adopters (other contributors) providing feedback
   - Pathway clear for future testing enhancements

5. **Sustainability:**
   - Code is maintainable (clear structure, well-commented)
   - Crate published or ready for publication
   - Documented for future maintainers
   - Tests verify dora-test-utils works correctly

---

## Questions for Mentors

Before submitting, I'd like feedback on:

1. **API Design:** Does the MockNode approach align with how nodes are structured internally? Any concerns?

2. **Scope:** Is 175 hours realistic for all four components, or should I prioritize differently?

3. **Integration:** How deeply should dora-test-utils be integrated into the existing test suite? (All tests? Just critical paths?)

4. **Python/C Support:** Is it essential for v1, or acceptable to focus on Rust and plan Python/C for v2?

5. **Timeline:** Any GSoC program constraints I should know about? (e.g., freeze dates, evaluation timing)

---

## Appendix: Reference Implementation Sketch

A rough sketch of how MockNode might look internally (pseudocode):

```rust
pub struct MockNode {
    name: String,
    input_channels: HashMap<String, Receiver<Message>>,
    output_channels: HashMap<String, Sender<Message>>,
    captured_outputs: Arc<Mutex<HashMap<String, Vec<Message>>>>,
}

impl MockNode {
    pub fn send_input(&mut self, topic: &str, msg: Message) -> Result<()> {
        self.input_channels
            .get(topic)
            .ok_or(Error::UnknownTopic)?
            .send(msg)?;
        Ok(())
    }

    pub fn receive_output(&self, topic: &str, timeout: Duration) -> Result<Message> {
        let captured = self.captured_outputs.lock().unwrap();
        captured
            .get(topic)
            .and_then(|msgs| msgs.last().cloned())
            .ok_or(Error::NoOutput)
    }

    pub fn execute(&mut self) -> Result<()> {
        // Call actual node logic
        // Collect outputs to captured_outputs
        Ok(())
    }
}
```

This is simplified for illustration; actual implementation will handle async, error propagation, and lifecycle more carefully.

---

**Proposal Status:** DRAFT (Ready for mentor review)

**Last Updated:** March 18, 2026

**Next Steps:**
1. Share with mentors for feedback
2. Refine based on comments
3. Submit to GSoC program by April 2, 2026
