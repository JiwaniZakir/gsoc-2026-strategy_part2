# dora-rs Architecture Deep Dive

## Codebase Organization

The dora-rs project is structured as a **Cargo workspace monorepo**, allowing multiple related crates to be developed, tested, and published together while sharing dependencies.

### Directory Structure and Purpose

#### Core Components

**`/dora-daemon/`** — Runtime Daemon
- Manages overall dataflow execution lifecycle
- Orchestrates communication between nodes
- Handles resource allocation and scheduling
- Implements the core event loop for distributed execution
- Responsible for graceful shutdown and error propagation
- Maintains state about active dataflows and nodes

**`/dora-cli/`** — Command Line Interface
- Entry point for user interactions
- Parses commands: `start`, `stop`, `describe`, `logs`, etc.
- Dispatches requests to the daemon
- Handles YAML dataflow file parsing and validation
- Provides user-friendly error messages
- Manages local configuration and environment setup

**`/dora-runtime/`** — Node Execution Runtime
- Provides node lifecycle management (spawn, init, run, stop)
- Manages memory and resource isolation
- Implements inter-process communication protocols
- Handles data serialization/deserialization
- Manages graceful shutdown and error recovery
- Supports both in-process and out-of-process nodes

#### Interfaces and Bindings

**`/apis/`** — Language Bindings
- `dora-core-rs/` — Core Rust API abstractions
- `dora-python/` — Python 3.x FFI bindings
- `dora-c/` — C language bindings
- `dora-cpp/` — C++ wrapper abstractions
- Provides unified interface across languages
- Handles type marshalling and error translation

#### Supporting Infrastructure

**`/libraries/`** — Core Libraries
- `dora-message/` — Message serialization and protocols
- `dora-schema/` — YAML and configuration schema definitions
- `dora-tracing/` — Distributed tracing instrumentation
- `dora-graph/` — Dataflow graph validation and analysis
- `dora-network/` — Network communication protocols
- `dora-utils/` — Common utilities (logging, error handling)

**`/examples/`** — Reference Implementations
- Rust examples demonstrating core API usage
- Python examples showcasing dataflow orchestration
- C/C++ integration examples
- End-to-end robotics use cases
- Benchmark and performance comparison examples

**`/tests/`** — Test Suite
- Unit tests (within individual crate `tests/` directories)
- Integration tests for multi-crate interactions
- End-to-end tests for full dataflows
- Performance benchmarks
- Platform-specific tests (Linux, Windows, macOS)

**`/docs/src/`** — Documentation
- User guides and tutorials
- API documentation source
- Architecture decision records (ADRs)
- Configuration reference
- Troubleshooting guides

**`/docker/`** — Container Configurations
- Docker images for development environments
- CI/CD container definitions
- Example containerized deployments

## Data Flow Architecture

The execution model follows this pipeline:

```
┌─────────────────────┐
│ Dataflow Definition │  (YAML file describing nodes and edges)
│ (Dora.toml)         │
└──────────┬──────────┘
           │
           ▼
┌──────────────────────┐
│  CLI Parser          │  Validates schema, infers types, checks edges
└──────────┬───────────┘
           │
           ▼
┌──────────────────────┐
│  Daemon              │  Graph execution planning, node scheduling
└──────────┬───────────┘
           │
           ▼
┌──────────────────────┐
│  Runtime             │  Spawns processes/threads, manages lifecycle
└──────────┬───────────┘
           │
           ▼
┌──────────────────────┐
│  Nodes               │  Process data through user-defined operations
└──────────┬───────────┘
           │
           ▼
┌──────────────────────┐
│  IPC Layer           │  Shared memory + network for node communication
└──────────┬───────────┘
           │
           ▼
┌──────────────────────┐
│  Output              │  Results streamed to sinks/outputs
└──────────────────────┘
```

### Data Serialization

- **Primary Format:** Apache Arrow columnar format
- **Benefits:** Zero-copy data passing, type-safe serialization, efficient memory layout
- **Message Protocol:** Custom frame-based protocol with Arrow payload
- **Endianness Handling:** Network byte order for distributed nodes

### Communication Patterns

**Shared Memory (Local)**
- Direct memory sharing between nodes on same machine
- Uses memory-mapped files or heap allocation
- Lower latency for co-located nodes

**Network (Distributed)**
- TCP/IP for remote node communication
- UDP for time-critical messages
- Protocol buffers for metadata, Arrow for bulk data

## Technology Stack Details

### Languages and Rationale

| Language | Usage | Percentage |
|----------|-------|-----------|
| **Rust** | Core daemon, runtime, CLI, libraries | 92.9% |
| **Python** | FFI bindings, example applications | 4.0% |
| **Shell** | Build scripts, deployment automation | 1.5% |
| **C/C++** | Legacy integrations, performance-critical sections | 1.6% |

### Build System: Cargo

**Workspace Structure:**
```toml
[workspace]
members = [
    "dora-daemon",
    "dora-cli",
    "dora-runtime",
    "apis/dora-python",
    "apis/dora-c",
    # ... more members
]
```

**Build Commands:**
- `cargo check` — Quick syntax validation without compilation
- `cargo build --workspace` — Compile all crates in release mode
- `cargo build --package dora-daemon` — Build specific crate
- `cargo test --workspace` — Run all unit and integration tests
- `cargo clippy` — Lint for common Rust mistakes
- `cargo fmt` — Auto-format code (required pre-commit)

**Dependency Management:**
- Stored in `Cargo.toml` at workspace and individual crate levels
- `Cargo.lock` ensures reproducible builds across all machines
- Regular dependency updates through Dependabot PRs

### Code Quality Standards

#### Formatting
- **Tool:** `rustfmt` with default configuration
- **Enforcement:** Must pass before PR merge
- **Command:** `cargo fmt --all`
- **Pre-commit:** Recommended hook to catch violations early

#### Linting
- **Tool:** `clippy` (Rust compiler plugin for lint analysis)
- **Severity Levels:** Allow, warn, deny (enforced in CI)
- **Command:** `cargo clippy --workspace`
- **CI Integration:** Blocks PRs on clippy warnings

#### License Compliance
- **Tool:** `cargo-deny` for dependency license auditing
- **Requirement:** All dependencies must be compatible with Apache 2.0
- **CI Check:** Automatic validation on every PR

#### Documentation
- **Inline:** Doc comments on public APIs (required)
- **Examples:** Every public function should have usage examples
- **Generation:** `cargo doc --open` builds HTML documentation

## CI/CD Pipeline

### GitHub Actions Workflows

#### CI/Test
- **Trigger:** On push to main, PRs to any branch
- **Platforms:** Linux (Ubuntu), Windows, macOS
- **Steps:**
  1. Checkout code
  2. Install Rust toolchain
  3. Run `cargo check --workspace`
  4. Run `cargo build --workspace`
  5. Run `cargo test --workspace`
  6. Report coverage metrics

#### CI/Examples
- **Purpose:** Ensure example code compiles and runs
- **Coverage:** Rust, Python, C, C++ examples
- **Validation:** Must successfully execute or build

#### CI-python/Python Examples
- **Platforms:** Linux only (Python FFI binding limitation)
- **Steps:**
  1. Build Python extension
  2. Run Python unit tests
  3. Validate example scripts execute

#### CI/Clippy
- **Runs:** On all pushes and PRs
- **Fails PR:** On any clippy warnings
- **Purpose:** Catch common Rust mistakes early

#### CI/Formatting
- **Tool:** `rustfmt --check`
- **Purpose:** Enforce style consistency
- **Fails PR:** On formatting violations

#### CI/License Checks
- **Tool:** `cargo-deny`
- **Purpose:** Verify all dependencies have compatible licenses
- **Enforcement:** Blocks PRs with incompatible dependencies

## Key Components and Their Interactions

### The Daemon-Runtime Relationship

```
Daemon (Main Process)
├── Listens on socket for commands
├── Maintains graph state
├── Spawns Runtime instances
├── Coordinates resource allocation
└── Manages node lifecycle

    ↓ (sends commands to)

Runtime (Child Process/Thread per node)
├── Receives initialization data
├── Loads user code (Python, C++, etc.)
├── Executes on loop
├── Handles IPC communication
└── Reports status back to Daemon
```

### Message Flow in a Dataflow

```
Node A (Output)
    ↓ (arrow: message)
    │ (serializes to Arrow format)
    │
    ▼ (IPC: shared memory or TCP)
Node B (Input)
    │ (deserializes from Arrow)
    ▼ (processes data)
Output or Forward to Node C
```

### API Layer

Each language binding provides:
- Initialization/teardown hooks
- Message receive (blocking/non-blocking)
- Message send with type safety
- Lifecycle callbacks

## Testing Strategy (Relevant for GSoC Testing Infrastructure)

### Current Testing Coverage

**Unit Tests:**
- Located in `tests/` subdirectories within crates
- Test individual functions in isolation
- Mock external dependencies where possible
- Fast execution (milliseconds)

**Integration Tests:**
- Located in `/tests/` at workspace root
- Test interaction between multiple crates
- May require daemon setup
- Moderate execution time (seconds)

**End-to-End Tests:**
- Full dataflow execution from CLI to output
- Use example dataflows
- Validate complete workflows
- Longer execution time (tens of seconds)

### Testing Infrastructure Gap (Opportunity)

Current challenges being addressed by GSoC project:
- **Lack of testing utilities** for mock node APIs
- **No standard regression test framework**
- **Limited CI templates** for custom dataflow testing
- **Difficult to write isolated node tests** without full daemon

## Deployment and Distribution

### Package Management
- Published on **crates.io** for Rust crates
- Pre-built **binaries** available for CLI on GitHub Releases
- **Docker images** for containerized deployments
- **Installation script:** `install.sh` for quick setup

### Compatibility Matrix
- **Linux:** Ubuntu 20.04+, Debian 11+
- **macOS:** 10.15+
- **Windows:** Windows 10+
- **RISC-V:** Experimental support

## Performance Considerations

### Latency Targets
- Inter-node message latency: < 1ms (same machine)
- Daemon scheduling overhead: < 100µs per message
- Python binding overhead: ~1-2ms per message

### Optimization Techniques
- Zero-copy data passing via Arrow
- Memory pooling in hot paths
- Efficient scheduler design
- Lock-free data structures where feasible

## Error Handling and Recovery

### Failure Modes
- **Node crash:** Daemon detects, propagates error
- **Deadlock:** Timeout mechanism triggers recovery
- **Data corruption:** Arrow validation catches most cases
- **Network failure:** Automatic reconnection with exponential backoff

### Logging
- Structured logging via `tracing` crate
- Multiple verbosity levels
- Separate logs per daemon/node instance
- Integration with OpenTelemetry for distributed tracing

## Future Architecture Evolution

### Planned Enhancements
- **Distributed state management** (separate GSoC project)
- **Dynamic graph reconfiguration** (pause, modify, resume)
- **Built-in observability** (metrics, traces, logs)
- **GPU acceleration** support for compute nodes

---

**Document Version:** 1.0
**Last Updated:** March 18, 2026
**Relevant for GSoC Testing Infrastructure:** Code organization, CI/CD pipeline, testing gap analysis
