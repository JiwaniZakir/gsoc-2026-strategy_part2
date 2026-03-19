# dora-rs: AI-Augmented Contribution Plan

**Priority:** #5 — Bhanudahiyaa dominates, Python bindings is the only opening
**Project:** Testing Infrastructure (dora-test-utils)
**Mentors:** phil-opp (@phil-opp), haixuanTao (@haixuanTao)
**Proposal deadline:** March 24, 2026
**Stack:** Rust (primary), Python bindings (pyo3), GitHub Actions

---

## Why dora-rs is #5 (Not Abandoned)

From COMPETITOR_ANALYSIS.md:
- **Bhanudahiyaa** submitted 9 PRs in 48 hours — coordinator KV store, CLI enforcement, state persistence, OpenTelemetry
- 3 of Bhanudahiyaa's PRs already merged
- This is a dedicated GSoC aspirant building a coherent feature set — cannot compete on CLI/state/coordinator

**BUT:** Python bindings, docs, and examples are Bhanudahiyaa-free territory. phil-opp reviews within hours and has high merge velocity.

**Reduced investment:** 1 PR total (Day 2 only). Primary energy goes to vulnerablecode.

---

## CRITICAL RULES

1. **`@dora-bot assign me`** in issue comments to claim work
2. **`cargo fmt --all` before every commit** — CI rejects without it
3. **AVOID entirely:** CLI, state management, coordinator, lock files — Bhanudahiyaa's territory
4. **Target only:** Python bindings, docs, examples, UX improvements

---

## Bhanudahiyaa-Free Zones

| Area | Issues | Why Safe |
|------|--------|----------|
| Python bindings (pyo3 stubs) | "Use pyo3 experimental-inspect instead of generate_stubs.py" | Bhanudahiyaa hasn't touched this |
| Getting Started docs | "Improve Users-Getting Started on dora-rs.ai" | Bhanudahiyaa focused on architecture, not docs |
| Progress bars | "Provide progress bars for time-consuming operations" | UX, not architecture |
| Python operator API bugs | Browse `node/python/` directory for issues | Python path, not Rust CLI path |
| Examples overhaul | `swar09` has one open PR — find adjacent examples | Specific to Python examples |

---

## Day 2 — March 20: Single PR (Python Only)

**Don't start until Day 2.** Day 1 is fully allocated to vulnerablecode and OCF.

### Setup (13:00–13:30)
```bash
git clone https://github.com/dora-rs/dora.git
cd dora
cargo build --workspace  # Verify clean build
cargo test --workspace
cargo fmt --all
cargo clippy --workspace
# Python setup:
pip install maturin
cd node/python && pip install -e .
python -c "import dora; print('Python bindings working')"
```

### PR #1 — pyo3 experimental-inspect stubs (13:30–15:00)

Issue: "Use pyo3 experimental-inspect instead of generate_stubs.py"

**Claim:**
```
@dora-bot assign me

I'll migrate the Python stub generation from the manual generate_stubs.py
script to use pyo3's experimental-inspect feature for automatic stub
generation. This is the pure-Python path — no overlap with other ongoing work.

Estimated: 1–2 days. Draft PR within 24h.
```

**Implementation approach:**
1. Read the current `generate_stubs.py` script
2. Read pyo3 `experimental-inspect` documentation
3. Replace the manual approach with the pyo3 native approach
4. Verify generated stubs are equivalent or better

```bash
git checkout -b feat/pyo3-experimental-inspect-stubs
cargo fmt --all && cargo clippy --workspace && cargo test --workspace
git commit -m "feat(python): use pyo3 experimental-inspect for stub generation"
git push origin feat/pyo3-experimental-inspect-stubs
```

---

## If pyo3 Stubs Issue is Already Claimed

Fallback options (all Python/docs territory):

1. **"Improve Users-Getting Started on dora-rs.ai"** — Documentation, no code
2. **"Provide progress bars for time-consuming operations"** — CLI UX
3. **Browse Python-tagged issues:** `gh api "repos/dora-rs/dora/issues?labels=python&state=open"`

---

## Commit Format (Required)

```
<type>(<scope>): <subject>

[optional body]

[Fixes #NNN]
```

Types: `feat`, `fix`, `docs`, `test`, `chore`
Examples:
```
docs(examples): clarify message passing in python pipeline example
feat(python): add pyo3 experimental-inspect stub generation
fix(python): handle None output in Python operator API
```

---

## PR Checklist

- [ ] `cargo fmt --all` passes
- [ ] `cargo clippy --workspace` passes
- [ ] `cargo test --workspace` passes
- [ ] Python tests pass if touching Python code
- [ ] `@dora-bot assign me` was used to claim the issue first
- [ ] No unrelated changes
- [ ] No changes to: CLI, coordinator, state, lock files

---

## Proposal Angle — Python Testing Infrastructure

The GSoC proposal for "Testing Infrastructure" can be framed as Python-first:

> "The dora-rs testing story is strong for Rust nodes but weak for Python nodes. Python node developers have no MockNode equivalent, no TestFixture, and no CI template that works with Python-based dataflows. This GSoC project builds a Python-first testing layer that gives Python node developers the same testing power as Rust developers."

This framing:
1. Doesn't compete with Bhanudahiyaa's Rust work
2. Addresses a real gap (Python is a primary user language)
3. Uses Zakir's Python strength
4. Is a coherent, bounded scope

---

**Last Updated:** March 19, 2026 (post-intelligence rewrite)
**Priority:** #5 of 5 — minimum investment, Python-only
