# dora-rs GSoC 2026 Strategy

## Organization Overview

**dora-rs** (Dataflow-Oriented Robotic Architecture) is a middleware framework for building low-latency AI applications in robotics and autonomous systems. It enables developers to compose complex robotic workflows using a declarative YAML-based dataflow model, where nodes communicate efficiently through shared memory and network protocols.

### Key Facts
- **Repository:** https://github.com/dora-rs/dora
- **License:** Apache 2.0
- **Community Size:** 3.1k stars, 335 forks, 4,635+ commits, 69 contributors
- **Latest Release:** v0.4.1 (January 20, 2026)
- **Primary Language:** Rust (92.9%)
- **Secondary Languages:** Python (4.0%), Shell (1.5%), C/C++

### Why dora-rs?

The project represents a modern approach to robotic middleware that prioritizes:
- **Low-latency execution** for time-critical AI workloads
- **Language flexibility** with Rust core, Python bindings, and C/C++ support
- **Scalability** through distributed dataflow orchestration
- **Developer experience** via intuitive CLI and clear abstractions

## GSoC 2026 Program

dora-rs is participating in Google Summer of Code 2026 with **10 projects** available:

1. **Testing Infrastructure** (Medium, 175 hours) — Primary focus for this strategy
2. **Package & Dependency Management** (Hard, 350 hours)
3. **Distributed State Support** (Medium)
4. **Dora-studio GUI** Enhancement
5. **Documentation Improvement**
6. **Cleanup/Refactor**
7. **SLAM/Localization**
8. **Obstacle Avoidance**
9. **ROSbag Reader Integration**
10. **Agentic Dora**

### Selected Project: Testing Infrastructure

**Mentors:** Alex Zhang, ZunHuan Wu
**Scope:** 175 hours (Medium difficulty)
**Status:** PROPOSED

The Testing Infrastructure project focuses on building a comprehensive testing utilities library (`dora-test-utils` crate) that will:
- Provide mock node APIs for isolated unit testing
- Implement regression testing helpers
- Create CI/CD templates for dataflow validation
- Improve overall test coverage across the codebase

## Communication Channels

- **Discord:** https://discord.com/channels/1146393916472561734/1346181173277229056
- **GitHub Issues:** Discussion and coordination for technical decisions
- **GitHub Discussions:** Community Q&A
- **GSoC Wiki:** https://github.com/dora-rs/dora/wiki/GSoC_2026

## Technology Stack

| Component | Technology |
|-----------|-----------|
| Language | Rust (primary) |
| Build System | Cargo (workspace monorepo) |
| Data Serialization | Apache Arrow |
| Bindings | Python 3.x, C, C++ |
| Testing | Standard Rust testing framework |
| CI/CD | GitHub Actions (multi-platform) |
| Code Quality | rustfmt, clippy, cargo-deny |

## Project Structure

The dora-rs repository follows a Cargo workspace monorepo pattern:

```
dora-rs/
├── dora-daemon/          # Runtime daemon managing dataflow execution
├── dora-cli/             # Command-line interface
├── dora-runtime/         # Node execution runtime
├── apis/                 # Language bindings (Python, C, C++)
├── libraries/            # Core libraries and abstractions
├── examples/             # Reference implementations
├── tests/                # Integration and end-to-end tests
├── docs/src/             # Documentation source
├── docker/               # Containerization configs
├── Cargo.toml            # Workspace manifest
└── Cargo.lock            # Dependency lock file
```

## Getting Started

### Prerequisites
- Rust 1.70+ (stable)
- Python 3.8+ (for Python examples/bindings)
- Git
- Discord account (for community access)

### Initial Setup
```bash
# Clone the repository
git clone https://github.com/dora-rs/dora.git
cd dora

# Build the entire workspace
cargo build --workspace

# Run all tests
cargo test --workspace

# Format code (required before any PR)
cargo fmt --all

# Check for style issues
cargo clippy --workspace
```

### First Contribution Steps
1. Review `CONTRIBUTING.md` in the repository root
2. Join Discord and introduce yourself in the GSoC channel
3. Start with documentation fixes in `/docs/src` or example improvements
4. Use `@dora-bot assign me` in GitHub issues to claim work
5. Discuss non-trivial changes in the GitHub issue BEFORE opening a PR

## Key Dates

- **GSoC Proposal Deadline:** Early April 2026
- **Program Start:** May 2026
- **Midterm Evaluation:** July 2026
- **Final Evaluation:** September 2026

## Current State of the Repository

### Active Development
- **Open Issues:** 77 (as of March 2026)
- **Open PRs:** 60 (974 previously merged)
- **Recent Focus Areas:** KV store, shared state RPC, registry indexing, CLI improvements

### Known Issues Being Addressed
- #1456: KV store implementation
- #1454: Shared state RPC mechanism
- #1452: Registry index optimization
- #1450: Dora.toml metadata schema
- #1448: CLI locking mechanism
- #1124: High CPU usage under load

## Mentorship

The dora-rs project provides structured mentorship through:
- **Weekly sync meetings** with assigned mentors
- **Discord channel access** for async communication
- **Code review guidance** on PR submissions
- **Architecture discussions** for complex features

Assigned mentors for Testing Infrastructure:
- **Alex Zhang** — Testing strategy and design patterns
- **ZunHuan Wu** — CI/CD integration and infrastructure

## Resources

- **GSoC Wiki:** https://github.com/dora-rs/dora/wiki/GSoC_2026
- **Contributing Guide:** `/CONTRIBUTING.md`
- **Architecture Docs:** `/docs/src/`
- **Example Code:** `/examples/`
- **Issue Tracker:** GitHub Issues with `gsoc-2026` label

## Next Steps

1. Review the ARCHITECTURE.md file for deep technical understanding
2. Study the CONTRIBUTION_PLAN.md for phased approach
3. Read ENGAGEMENT_GUIDE.md for communication protocols
4. Draft the proposal in PROPOSAL_DRAFT.md
5. Submit by the GSoC deadline

---

**Last Updated:** March 18, 2026
**Strategy Owner:** zakirjiwani
**Repository:** https://github.com/dora-rs/dora
