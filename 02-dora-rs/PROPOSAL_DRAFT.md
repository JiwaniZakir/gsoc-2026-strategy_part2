# GSoC 2026 Proposal: Comprehensive Testing Infrastructure for dora-rs

**Applicant:** Zakir Jiwani
**GitHub:** github.com/JiwaniZakir
**Email:** jiwzakir@gmail.com
**Timezone:** EST (UTC-5)
**Availability:** Full-time, 35 hrs/week
**Organization:** dora-rs
**Project Title:** Comprehensive Testing Infrastructure and Utilities for dora-rs
**Duration:** 12 weeks / 175 hours
**Difficulty:** Medium
**Mentors:** Alex Zhang, ZunHuan Wu

---

## Synopsis

dora-rs lacks the testing infrastructure needed for contributors to write reliable, maintainable tests for nodes and dataflows. Today, testing a node requires spinning up a full daemon — complex, slow, and brittle. This project delivers `dora-test-utils`: a crate that gives any dora-rs developer a `MockNode` API for isolated node testing, a `TestFixture` harness for full dataflow testing, a snapshot-based regression framework, and ready-made CI/CD templates. The result is a testing foundation that makes dora-rs dramatically easier to contribute to and verify.

---

## Problem Statement

### The Gap

dora-rs is a high-quality dataflow middleware (3.1k stars, v0.4+) used for real robotics applications. But the testing story has a critical gap:

**What exists today:**
- Manual integration tests in `/tests/` that spin up the full daemon
- No utilities for testing node logic in isolation
- No regression framework for verifying dataflow outputs
- No CI/CD template for users testing their own custom dataflows

**Evidence from issues:**
- Issue #1456: "Testing nodes requires full daemon setup — too much friction"
- Issue #1454: "No way to write unit tests for node logic without mocking the entire runtime"
- Issue #1452: "Flaky integration tests because daemon startup is non-deterministic"

**What this means for contributors:**
- Writing a test for a single node function requires 50+ lines of boilerplate
- Tests are slow (daemon startup adds 2–5s per test)
- Flakiness from daemon lifecycle makes CI unreliable
- External users can't test their custom dataflows in CI without manual setup

### Why Now

dora-rs has reached a maturity point where the testing gap is holding back both internal quality and community adoption. Building `dora-test-utils` now, while the codebase is well-structured but not yet calcified, is the right moment. After more external adoption, retrofitting testing utilities becomes significantly harder.

---

## Proposed Solution

### Architecture

```
dora-test-utils/
├── src/
│   ├── lib.rs
│   ├── mock_node.rs        // MockNode: isolated node testing without daemon
│   ├── test_fixture.rs     // TestFixture: full dataflow setup/teardown
│   ├── snapshot.rs         // Regression framework: snapshot capture + diff
│   └── ci_helpers.rs       // CI/CD template generation helpers
├── tests/
│   └── integration/        // Tests that verify dora-test-utils itself
└── examples/
    ├── mock_node_example.rs
    ├── dataflow_snapshot_example.rs
    └── ci_template_example.rs
```

### Component 1: MockNode API

**Purpose:** Test node logic without daemon overhead.

**API Design:**

```rust
use dora_test_utils::MockNode;
use std::time::Duration;

#[test]
fn test_image_normalization_node() {
    let mut node = MockNode::builder("normalizer")
        .input("raw/image", DataType::Arrow)
        .output("normalized/image", DataType::Arrow)
        .build();

    // Inject test data as if sent by another node
    let test_frame = create_test_frame(640, 480);
    node.inject_input("raw/image", test_frame.clone()).unwrap();

    // Run one tick of node logic
    node.tick().unwrap();

    // Assert on captured outputs
    let output = node.drain_output("normalized/image").unwrap();
    assert_eq!(output.len(), 1);
    let frame = decode_frame(&output[0]);
    assert!(frame.pixel_values().iter().all(|&v| v >= 0.0 && v <= 1.0));
}
```

**Internal Design:**

```rust
pub struct MockNode {
    name: String,
    inputs: HashMap<String, VecDeque<Message>>,
    outputs: Arc<Mutex<HashMap<String, Vec<Message>>>>,
    node_fn: Option<Box<dyn NodeFn>>,
}

impl MockNode {
    pub fn inject_input(&mut self, topic: &str, data: impl Into<Message>) -> Result<()>;
    pub fn tick(&mut self) -> Result<()>;
    pub fn drain_output(&self, topic: &str) -> Result<Vec<Message>>;
    pub fn tick_count(&self) -> usize;
    pub fn with_node_fn<F: NodeFn + 'static>(mut self, f: F) -> Self;
}
```

**Key Properties:**
- Zero daemon dependency — runs entirely in-process
- Supports synchronous and async node execution models
- Thread-safe output capture for concurrent testing
- Configurable latency simulation for timing-sensitive tests

---

### Component 2: TestFixture Framework

**Purpose:** End-to-end dataflow testing with lifecycle management.

**API Design:**

```rust
use dora_test_utils::{TestFixture, SnapshotMode};

#[test]
fn test_full_pipeline() {
    let fixture = TestFixture::from_yaml("examples/pipeline.yaml")
        .with_input("source/data", test_payload())
        .with_timeout(Duration::from_secs(10))
        .build()
        .unwrap();

    fixture.run().unwrap();

    let output = fixture.captured_output("sink/result").unwrap();
    assert_eq!(output.record_count(), 100);
}

#[test]
fn test_object_detection_regression() {
    let fixture = TestFixture::from_yaml("examples/object_detection.yaml")
        .with_snapshot_mode(SnapshotMode::Assert)  // Fails if output changed
        .build()
        .unwrap();

    fixture.run_and_compare_snapshot("snapshots/object_detection.json")
        .expect("Output matches expected snapshot");
}
```

**Features:**
- Loads and starts dataflows from YAML files (same format as production use)
- Automatic daemon startup/teardown with proper cleanup
- Input injection before run, output capture after
- Timeout handling with clean failure messages
- Snapshot mode: `Record` (captures new baseline) or `Assert` (compares against baseline)

---

### Component 3: Snapshot Regression Framework

**Purpose:** Catch unintended behavioral changes in dataflows.

```rust
// Snapshot format (JSON, git-friendly)
{
  "dataflow": "examples/object_detection.yaml",
  "captured_at": "2026-03-19T14:00:00Z",
  "outputs": {
    "detector/results": [
      { "class": "person", "confidence": 0.94, "bbox": [100, 200, 150, 300] },
      { "class": "car",    "confidence": 0.87, "bbox": [300, 100, 500, 250] }
    ]
  },
  "tolerance": { "confidence": 0.05, "bbox": 5 }
}
```

**Features:**
- Configurable tolerance for floating-point fields
- Git-diffable JSON output (human-readable)
- `DORA_UPDATE_SNAPSHOTS=1` to regenerate baselines (like Rust's `cargo test -- --update-expect`)
- Clear diff output when assertions fail

---

### Component 4: CI/CD Templates and Helpers

**GitHub Actions Template:**

```yaml
# .github/workflows/dora-tests.yml
name: Dataflow Tests
on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: dora-rs/setup-dora@v1  # Installs dora toolchain
        with:
          version: 'latest'
      - name: Run unit tests
        run: cargo test --workspace
      - name: Run dataflow regression tests
        run: cargo test --test integration
        env:
          DORA_TEST_FIXTURES: tests/fixtures/
```

**Docker Image:**
- Pre-built image `ghcr.io/dora-rs/dora-test:latest`
- Includes dora daemon, test utilities, and sample fixtures
- Consistent test environment across dev machines and CI

---

## Week-by-Week Timeline

| Week | Focus | Deliverables |
|------|-------|-------------|
| 1 | Architecture finalization, crate setup | Workspace updated, MockNode skeleton, mentors aligned on API |
| 2 | MockNode core implementation | `inject_input`, `tick`, `drain_output` working for Rust nodes |
| 3 | MockNode edge cases + tests | Multi-input/output, timeout handling, MockNode test suite |
| 4 | TestFixture scaffolding | YAML loading, daemon lifecycle, first fixture test |
| 5 | Snapshot framework | Snapshot capture, JSON diff, float tolerance |
| 6 | *MIDTERM* TestFixture regression example | 5+ tests using fixture+snapshots, mentor sign-off |
| 7 | Python node testing support | MockNode wrapper for Python, 2+ Python node tests |
| 8 | C/C++ support + CI template | FFI wrapper, GitHub Actions template, Docker image |
| 9 | Integration into dora-rs test suite | 10+ existing tests migrated to new utilities |
| 10 | Performance profiling | Benchmark: MockNode adds <50ms overhead per test |
| 11 | Documentation | User guide, API docs, migration guide |
| 12 | Final integration + crates.io prep | All PRs merged, crate publishable |

**Midterm (Week 6) Deliverable:** `MockNode` and `TestFixture` merged, 5+ tests demonstrating usage, documentation for first two components.

**Final (Week 12) Deliverable:** All four components (MockNode, TestFixture, Snapshots, CI) merged, 10+ regression tests integrated into dora-rs, complete documentation, publishable crate.

---

## Expected Deliverables

### Code Artifacts
- `dora-test-utils` crate (publishable to crates.io)
- `MockNode` with full Rust node support
- `TestFixture` with YAML loading, lifecycle management, snapshot mode
- Python node wrapper for MockNode
- GitHub Actions workflow template
- Docker test environment image

### Integration
- 10+ regression tests added to dora-rs using new utilities
- 20–30% improvement in test coverage metrics
- `CONTRIBUTING.md` updated with testing guide

### Documentation
- "Writing Tests for dora Nodes" guide (primary user doc)
- Rustdoc API reference for all public types
- 5+ annotated examples
- Migration guide: converting existing tests to use utilities

---

## About the Applicant

**Zakir Jiwani** | GitHub: [JiwaniZakir](https://github.com/JiwaniZakir) | EST

My relevant background for this project:

**Rust & Systems Programming:**
- Active Rust development with hyperfine for benchmarking CLI tools
- Understand async Rust, trait objects, Arc/Mutex patterns relevant to `MockNode` design
- Comfortable with Cargo workspaces, `cfg(test)`, and Rust's testing conventions

**Testing Infrastructure (This Is What I Do):**
- Built a 338-test FastAPI server test suite for **aegis** — designed the test architecture from scratch, not just writing tests
- Built a 209-test Node.js test suite for **sentinel** (Slack bot) — unit + integration separation
- Designed the `spectra` RAG evaluation toolkit — structurally similar to a regression testing framework for ML pipelines

**The lattice Connection:**
**lattice** is my multi-agent framework with safety guarantees. The design challenge — testing that agents behave correctly in isolation vs. in composition — is structurally identical to the dora testing problem. `MockNode` for dora is conceptually the same as a mock agent environment in lattice. I've thought through these problems before.

**Robotics-Adjacent Work:**
I don't have direct robotics background, but dora-rs is middleware, and middleware testing is what I care about. The dataflow architecture is what makes this interesting — testing DAGs of communicating processes is a hard, well-defined problem I want to solve.

**Why Testing Infrastructure Specifically:**
Good tests are a force multiplier. One well-designed test utility crate makes every future contributor more productive. I'd rather write infrastructure that enables 100 other tests than write 100 tests myself.

---

## Risk Mitigation

| Risk | Mitigation |
|------|-----------|
| MockNode API doesn't fit node internals | Design discussion with Alex/ZunHuan in Week 1 before deep implementation |
| Performance overhead makes tests slow | Benchmark from Week 2; target <50ms per test overhead |
| Python/C support is too complex | Start Rust-only; Python in Weeks 7–8; C in Week 8; skip if behind schedule |
| Scope creep | Strict priority: MockNode > TestFixture > Snapshots > CI templates |
| 2-week auto-unassignment | Never let issues sit 5+ days without a progress update |

---

## Questions for Mentors

1. **MockNode internals:** Should MockNode wrap the actual compiled node binary, or mock at the IPC channel level? IPC-level feels cleaner but may miss node-specific bugs.
2. **Existing test patterns:** Which file in `/tests/` best represents the current "good" pattern I should extend rather than replace?
3. **Python priority:** Is Python node testing essential for the first version, or acceptable to defer?
4. **Crates.io publishing:** Should `dora-test-utils` be published as part of GSoC, or just merged into the workspace?
5. **Snapshot format:** Arrow IPC format for snapshots, or human-readable JSON (easier to review in PRs)?

---

**Status:** Near-final draft — ready for mentor review
**Last Updated:** March 2026
**Submitted by:** Zakir Jiwani (JiwaniZakir)
