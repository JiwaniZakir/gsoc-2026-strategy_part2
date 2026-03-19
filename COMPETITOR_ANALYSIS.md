# Competitor Analysis — GSoC 2026 Target Repos
> Generated: 2026-03-19 via `gh` CLI
> Identifies active external contributors, their PR quality, and threat level to Zakir's GSoC candidacy

---

## Methodology

For each repo, identified all external contributors (non-core-team) who submitted PRs in the last 30 days. Assessed:
- **Volume**: Number of PRs submitted
- **Quality**: Are they trivial (docs/typo) or substantive (features, tests, bug fixes)?
- **Merge rate**: Are their PRs getting merged?
- **Threat level**: HIGH = likely GSoC aspirant with strong momentum; MEDIUM = contributing but not overwhelming; LOW = one-off contributor

---

## 1. dora-rs/dora — Competitor Landscape

### Active Competitors

| User | Open PRs | Merged PRs | PR Quality | Threat Level |
|------|----------|------------|------------|--------------|
| **Bhanudahiyaa** | **9** | 3 merged | **VERY HIGH** — coordinator KV store, state persistence, CLI enforcement, OpenTelemetry propagation | 🔴 **EXTREME** |
| ashnaaseth2325-oss | 3 | 0 | Medium — panic fixes for edge cases (non-UTF-8 paths) | 🟡 MEDIUM |
| swar09 | 1 | 0 | Medium — example overhaul | 🟡 MEDIUM |
| Monti-27 | 0 | 1 | Medium — build output draining fix | 🟡 MEDIUM |
| PavelGuzenfeld | 0 | 2 merged | **HIGH** — zero-copy output API, dynamic node init (C++ features) | 🔴 HIGH |

### Bhanudahiyaa Deep Dive
**Most dangerous competitor in the entire analysis.** In the 48 hours ending 2026-03-19:
- `feat(state): add coordinator in-memory shared KV store with TTL and delete`
- `eat(state): add state_get/state_set RPC contract with no-op coordinator plumbing`
- `feat(cli): add local registry index reader and inspect command`
- `feat(cli): add Dora.toml metadata schema validation command`
- `feat(cli): enforce --locked validation for start and run`
- `feat(coordinator): add optional file-backed archived state persistence`
- `fix(cli): invalidate stale build session on dataflow changes`
- `feat(cli): add dora.lock prototype for git-backed nodes`
- `feat(observability): add structured node runtime health API`

**Assessment**: This is not random contribution — Bhanudahiyaa is methodically building out a coherent feature set (state management, CLI, coordinator persistence) that looks like a GSoC proposal in action. They've already had 3 PRs merged. They are implementing features that would normally be a GSoC project scope.

**Counter-strategy**: Do not compete on CLI/state/coordinator features. Target Python bindings (pyo3), documentation site, or examples — areas Bhanudahiyaa hasn't touched.

### Recommended Counter-Moves for Zakir
- Fix the `pyo3 experimental-inspect` good first issue (Python, not Rust)
- Improve Getting Started docs (non-Rust, no overlap with Bhanudahiyaa)
- Look at open issues in `node/python` or `node/c++` directories — less contested
- Submit a substantive fix to an open bug in the Python operator API

---

## 2. honeynet/GreedyBear — Competitor Landscape

### Active Competitors

| User | Open PRs | Merged | PR Quality | Threat Level |
|------|----------|--------|------------|--------------|
| **drona-gyawali** | 0 | 1 merged | HIGH — ML feature importances logging | 🔴 HIGH |
| **opbot-xd** | 1 | 0 | HIGH — pre-compute ASN aggregates (database architecture) | 🔴 HIGH |
| **rootp1** | 0 | 1 merged | HIGH — Heralding extraction strategy (full feature) | 🔴 HIGH |
| **cclts** | 0 | 1 merged | HIGH — Cowrie file transfer metadata extraction | 🔴 HIGH |
| Prasad8830 | 1 | 0 | Medium — feeds filter + DOM fix | 🟡 MEDIUM |
| Aditya30ag | 1 | 0 | Medium — training_data validation | 🟡 MEDIUM |
| R1sh0bh-1 | 1 | 0 | Medium — Sensor model custom labels | 🟡 MEDIUM |
| TEMHITHORPHE | 1 | 0 | Medium — renaming GeneralHoneypot→Honeypot | 🟡 MEDIUM |
| manik3160 | 0 | 1 merged | Medium — utilities.py test coverage | 🟡 MEDIUM |
| rahulgunwanistudy-2005 | 0 | 1 merged | Medium — IPv6 support fix | 🟡 MEDIUM |
| Deepanshu1230 | 0 | 1 merged | Medium — persist Feeds filters in URL params | 🟡 MEDIUM |
| IQRAZAM | 1 | 0 (earlier duplicate closed) | Medium — cronjob exception propagation | 🟡 MEDIUM |
| piyushzgautam99 | 1 | 0 | Low-Medium — dashboard test coverage | 🟢 LOW |
| swara-2006 | 1 | 0 | Low — useAuthStore test | 🟢 LOW |

### Overall Assessment
GreedyBear has the **most competitors per repo size** of any target. At least 8 unique external contributors have had PRs merged in the last week. The competition is not as technically deep as dora-rs (where Bhanudahiyaa is building full feature sets), but it is extremely wide.

**Pattern**: Competitors are targeting:
1. Existing open issues (finding `Closes #XXX` issues and claiming them)
2. Extraction strategies for honeypot types
3. Test coverage improvements
4. Frontend React fixes

### Recommended Counter-Moves for Zakir
- Find open issues NOT yet claimed with PRs (`gh api "repos/honeynet/GreedyBear/issues?state=open&per_page=50"` and filter for those without linked PRs)
- Target the `uv migration` (regulartim has a DRAFT PR — could contribute to it or claim an adjacent task)
- ML model improvements (Random Forest is mentioned — could add more sophisticated ML)
- The country filter feature (#525) by lvb05 is open but not merged — check if there's a competing approach opportunity

---

## 3. aboutcode-org/vulnerablecode — Competitor Landscape

### Active Competitors

| User | Open PRs | Merged | PR Quality | Threat Level |
|------|----------|--------|------------|--------------|
| **NucleiAv** | **6** | 0 merged yet | Medium — all "Add [X] importer" pattern | 🔴 HIGH (volume) |
| **Tednoob17** | 3 | 0 merged yet | Medium — importers + docs | 🔴 HIGH (volume) |
| **ziadhany** | 1 | 1 merged | HIGH — API + UI vulnerability rules (substantive) | 🔴 HIGH (quality) |
| Dhirenderchoudhary | 1 | 0 (prior PR also unmerged) | Medium — Apache Tomcat importer enhancement | 🟡 MEDIUM |
| Samk1710 | 1 | 0 | Medium — VMware Photon importer | 🟡 MEDIUM |
| malladinagarjuna2 | 1 | 0 | Medium — Gentoo improver | 🟡 MEDIUM |
| Tarun-goswamii | 0 | 0 (PR closed) | Low | 🟢 LOW |

### NucleiAv Deep Dive
NucleiAv has 6 open PRs all following identical pattern: "Add [X] security advisories importer":
- Check Point, Eclipse Foundation, LibreOffice, Collabora Online, Alpine, ZDI, Grafana

**Assessment**: This is a spray-and-pray strategy. While impressive in volume, the core team (TG1999, keshav-space) has NOT merged any of NucleiAv's PRs yet — only core team and `ziadhany` are getting merged. NucleiAv may be writing importers that fail code review.

**Implication for Zakir**: **Do NOT copy the "add an importer" strategy.** The pattern is saturated AND the core team isn't merging them. Instead, focus on what IS getting merged: API design changes, pipeline architecture, UI features.

### ziadhany Analysis
ziadhany (149 commits, regular contributor) submitted "Add API and UI support for vulnerability rules" — this is a substantive feature. They appear to be a past GSoC contributor who is continuing to contribute. Not a direct competitor for Zakir (they're already established).

### Recommended Counter-Moves for Zakir
- Pick a `good first issue` labeled `difficulty:easy` that involves API or UI work
- Specifically: "Sort packages and vulnerabilities newest-to-oldest" — UI/API change, easy but visible
- "Use centralized function/objects for all network access" — architecture improvement (intermediate) that demonstrates systems thinking
- "Add tests for Docker" — tests are always valued and less contested
- Avoid: adding any new data importer (oversaturated)

---

## 4. accordproject/cicero — Competitor Landscape

### Active Competitors

| User | Open PRs | Merged | PR Quality | Threat Level |
|------|----------|--------|------------|--------------|
| **Divyansh2992** | 2 | 0 | Medium — core fixes (await, metadata preservation) | 🟡 MEDIUM |
| **yashhzd** | 2 | 0 | Medium-High — DEFLATE compression, circular inheritance guard | 🟡 MEDIUM |
| vermarjun | 1 | 0 | Medium — reenable template signing (large feature) | 🟡 MEDIUM |
| Rahul-R79 | 0 | 1 merged | HIGH — Windows path normalization | 🔴 HIGH |
| Drita-ai | 0 | 1 merged | Medium — test coverage | 🔴 HIGH |
| Atharva7115 | 0 | 1 merged | Low — docs HTTPS link | 🟢 LOW |
| yuanglili | 0 | 1 merged | Medium — versioned namespaces in test files | 🟡 MEDIUM |
| Darshan-paul | 1 | 0 | Low — README grammar | 🟢 LOW |
| utkarsh636-developer | 1 | 0 | Medium — remove deprecated dependency | 🟡 MEDIUM |

### Overall Assessment
Accord Project has moderate competition. The pool is smaller than GreedyBear/vulnerablecode. Key contributors (Rahul-R79, Drita-ai) are targeting test coverage and cross-platform fixes — good GSoC-style work.

### Recommended Counter-Moves for Zakir
- Template signing feature (vermarjun's PR is open — check if it needs review/improvement)
- Windows compatibility improvements (Rahul-R79 got merged — more cross-platform fixes likely exist)
- Find issues in concerto (the more maintained repo with 26 open issues)
- Check if GSoC 2026 org application lists Accord Project as a participating org

---

## 5. openclimatefix/quartz-solar-forecast — Competitor Landscape

### Active Competitors

| User | Open PRs | Merged | PR Quality | Threat Level |
|------|----------|--------|------------|--------------|
| **Raakshass** | 4 | 2 merged | HIGH — Python 3.12, ML models, trailing whitespace | 🔴 HIGH |
| **Sharkyii** | 3 | 0 | Medium — geographic viz, netcdf fix, midnight bug | 🟡 MEDIUM |
| CodeVishal-17 | 2 | 1 merged | HIGH — APITally monitoring, CI rewrite | 🔴 HIGH |
| stromfee | 1 | 0 | Medium — new API integration | 🟡 MEDIUM |
| astropedrocosta | 1 | 0 | Medium — xgboost fix | 🟡 MEDIUM |
| danishdynamic | 0 | 1 merged | Medium — remove sentry | 🟡 MEDIUM |
| yuvraajnarula | 1 | 0 | Medium — DuckDB query layer | 🟡 MEDIUM |

### Overall Assessment
OCF has fewer competitors than the other repos and the competition is moderate quality. Raakshass is the primary threat — they've already gotten 2 PRs merged and have 4 open.

### Recommended Counter-Moves for Zakir
- "Add python3.12" good first issue — Raakshass submitted a PR but it's open and unmerged; check if it can be improved or if there's a better approach
- CI tests optimization (20 mins issue) — concrete, measurable improvement
- pvnet repo (49 stars, 14 open issues) — much less competition than quartz-solar-forecast

---

## Threat Matrix Summary

| Repo | Top Competitor | Their Strategy | Can Zakir Compete? | Recommended Zakir Action |
|------|---------------|----------------|-------------------|--------------------------|
| dora-rs/dora | **Bhanudahiyaa** (9 PRs, coordinator/CLI/state) | Systematic feature build-out | ⚠️ Hard to displace | Target Python bindings, docs, avoid CLI/state overlap |
| honeynet/GreedyBear | **Multiple** (8+ competitors, all active) | Spray of bug fixes + features | ⚠️ Crowded but possible | Find unclaimed issues, focus on ML/backend |
| aboutcode-org/vulnerablecode | **NucleiAv** (6 importer PRs, none merged) | Importer spam | ✅ Yes — avoid importers | API/UI features, network centralization |
| accordproject/cicero | **Divyansh2992 + yashhzd** (moderate) | Core bug fixes | ✅ Yes — low competition | concerto issues, cross-platform fixes |
| openclimatefix/quartz-solar | **Raakshass** (4 PRs, 2 merged) | ML models + compatibility | ✅ Yes — pvnet is open | pvnet repo, CI speed, model evaluation |

---

## Overall Strategic Recommendations

### Priority Ranking (Best GSoC chances for Zakir)

1. **aboutcode-org/vulnerablecode** — BEST CHOICE
   - 756 open issues = massive unclaimed work
   - Competitors are doing the wrong thing (importers)
   - Do: API features, UI improvements, centralized networking
   - Python stack matches Zakir's background

2. **openclimatefix/quartz-solar or pvnet** — SECOND BEST
   - Moderate competition
   - pvnet is even less contested
   - Climate tech = compelling GSoC narrative
   - Python/ML fits Zakir's profile

3. **accordproject/cicero** — THIRD
   - If Zakir knows JavaScript well
   - Less competition than GSoC-targeted Python repos
   - But smaller org/fewer mentors

4. **honeynet/GreedyBear** — RISKY
   - Too crowded right now
   - If Zakir can find a genuinely unclaimed high-value issue, possible
   - Security + Django = matches Zakir's skills

5. **dora-rs/dora** — AVOID (unless Rust-capable)
   - Dominated by Bhanudahiyaa
   - Rust barrier is high
   - Python bindings is the only low-Rust entry point

---

## Quality Benchmarks — What "Good" Looks Like

Based on PRs that actually got merged, the bar is:

| Repo | Minimum Bar | Gold Standard |
|------|-------------|---------------|
| dora-rs | Working Rust code with tests | New API feature with benchmarks |
| GreedyBear | Fix an open issue, pass CI | New extraction strategy with tests |
| vulnerablecode | Pass existing test suite | New API endpoint with tests + docs |
| accordproject | Pass CI, follow conventions | Fix with test coverage increase |
| openclimatefix | Working Python, passes CI | New model or benchmark improvement |

**Common pattern in all merged PRs**: They reference an issue (`Closes #XXX`), pass CI, and have a clear description of what changed and why.
