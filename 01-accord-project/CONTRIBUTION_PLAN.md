# Accord Project: AI-Augmented Contribution Plan

**Priority:** #3 — Moderate competition, concerto repo is the opening
**Project:** APAP and MCP Server Hardening
**Mentors:** Dan Selman (@dselman), Jerome Simeon (@jeromesimeon)
**Proposal deadline:** March 24, 2026
**Stack:** TypeScript, Node.js, MCP, Jest

---

## Why Accord is #3

- Moderate competition (Divyansh2992 and yashhzd have some PRs but nothing overwhelming)
- **concerto** has 26 open issues — less contested than cicero/template-archive
- Recent merges: Windows path fix, test coverage — show maintainers DO merge external work
- If GSoC 2026 officially lists Accord Project, this jumps in priority
- JavaScript/TypeScript stack is Zakir's secondary language (behind Python/ML)

---

## Intelligence from REPO_INTELLIGENCE.md

| Metric | Value |
|--------|-------|
| Active competitor threat | Moderate — Divyansh2992 (2 PRs), yashhzd (2 PRs) |
| Recent merge rate | 4 external PRs in 2 weeks |
| Mentor responsiveness | Days — not hours |
| Best repo to target | **concerto** (26 issues, less contested) |
| Secondary repo | template-archive (93 issues, more activity) |

---

## Competitor Map

| Competitor | Their PRs | Threat Level | Counter |
|-----------|----------|-------------|---------|
| Divyansh2992 | 2 PRs: fix missing await, setReadme preserves logo | Medium | Work in concerto, not cicero |
| yashhzd | 2 PRs: DEFLATE compression, circular inheritance | Medium-High | Avoid DEFLATE/compression areas |
| Rahul-R79 | 1 merged: Windows path fix | Already merged | Cross-platform is still open — more issues? |
| Drita-ai | 1 merged: test coverage | Already merged | More test coverage is still viable |
| vermarjun | 1 open: reenable template signing | Medium | Check if you can help or complement |

---

## Target Issues

### concerto (Primary Target)
Browse: https://github.com/accordproject/concerto/issues

26 open issues — scan for:
- Test coverage gaps
- Cross-platform compatibility (Windows / path normalization)
- Type validation edge cases
- Documentation improvements

### template-archive (Secondary)
Browse: https://github.com/accordproject/template-archive/issues (93 issues)
- Lots of issues but also more competitors
- Use only if concerto has nothing immediately accessible

---

## Day 1 — March 19: Setup + PR #1 (concerto)

### Setup (07:00–08:00)
```bash
git clone https://github.com/accordproject/concerto.git
git clone https://github.com/accordproject/template-archive.git
cd concerto && npm install && npm test  # Verify pass
cd ../template-archive && npm install && npm test
```

### PR #1 — concerto issue (12:00–13:30)

Browse concerto issues and claim the first good match.

**Claim comment:**
```
I'd like to work on this for GSoC 2026 (applying for APAP/MCP Server Hardening).

I've reviewed the codebase and understand the scope.
My approach:
1. [Step 1 — specific to the issue]
2. [Step 2]
3. Test: [what the new test verifies]

Starting now — draft PR within 2 hours.
```

```bash
cd concerto
git checkout -b fix/issue-NNN-description
# Make change
npm test && npm run lint && npm run build  # All must pass
git add [specific files]
git commit -m "fix: [clear description]"  # Conventional commits
git push origin fix/issue-NNN-description
```

---

## Day 2 — March 20: PR #2 (Second concerto or template-archive)

**Target:** Second PR in a different area of the codebase.
Options:
- Add Jest test for a function missing coverage in concerto
- Fix a template-archive issue that hasn't been claimed
- Cross-platform fix (Windows path normalization pattern from Rahul-R79's merged PR — are there more?)

```bash
npm test -- --coverage  # Check coverage report to find gaps
```

---

## Day 3 — March 21: PR #3 (APAP/MCP direct)

**Target:** PR touching the APAP server or MCP server — the actual GSoC project area.

This is the most important PR for the proposal because it shows you can work in the specific code being hardened.

Best targets:
- Add a test for an existing APAP endpoint that lacks one
- Add input validation to an endpoint using Zod
- Improve error response consistency

```bash
cd apap-server  # or relevant repo
npm test && npm run lint
git commit -m "test: add system test for template compilation endpoint"
# OR
git commit -m "fix: add Zod input validation to /templates POST endpoint"
```

---

## Day 4 — March 22: Polish + Proposal

Focus shifts to proposal writing. Only submit PR #3 in morning if not already done.

---

## PR Checklist

- [ ] Branch from `main` (verify — check repo default branch)
- [ ] `npm test` passes locally
- [ ] `npm run lint` passes (ESLint)
- [ ] `npm run build` succeeds (TypeScript compiles)
- [ ] Conventional commit message: `feat:`, `fix:`, `docs:`, `test:`
- [ ] PR description: What / Why / How / Testing
- [ ] Issue linked: `Closes #NNN`
- [ ] No unrelated changes

---

## Key Repositories

| Repo | URL | Priority |
|------|-----|----------|
| concerto | accordproject/concerto | Primary (26 open issues, less contested) |
| template-archive | accordproject/template-archive | Secondary (93 issues, more competitive) |
| cicero (template-archive equivalent) | accordproject/cicero | Check if archived — use template-archive instead |
| APAP server | Check GSoC 2026 org listing for exact repo | GSoC project area |

---

**Last Updated:** March 19, 2026 (post-intelligence rewrite)
**Priority:** #3 of 5
