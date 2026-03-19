# VulnerableCode: AI-Augmented Contribution Plan

**Priority:** #1 — Biggest GSoC opportunity in the entire analysis
**Project:** NLP/ML Vulnerability Detection from Unstructured Data
**Organization:** AboutCode
**Proposal deadline:** March 24, 2026
**Stack:** Python, Django, DRF, NLP/ML, spaCy/HuggingFace, PostgreSQL

---

## Why VulnerableCode is #1

- **756 open issues** — massive unclaimed work
- Competitors (NucleiAv, Tednoob17) are doing the WRONG thing: adding importers
- Core team is merging API changes, architecture work — NOT importers
- ziadhany (regular contributor) got merged doing exactly this: "Add API and UI support for vulnerability rules"
- Python/Django stack matches Zakir's strongest skills

---

## CRITICAL RULES

1. **Sign the DCO** before your first commit: `git commit -s`
2. **Comment on issue first** — before writing any code
3. **Run `black` and `isort`** before every commit
4. **Run `pytest`** locally before every PR
5. **NEVER add a new importer** — this pattern is saturated and not getting merged
6. **Target:** API features, UI improvements, tests, architecture improvements

---

## Unclaimed Issue Targets (From Intelligence Analysis)

| Issue | Type | Difficulty | Why It's Good |
|-------|------|-----------|---------------|
| Sort packages/vulnerabilities newest-to-oldest | API/UI | Easy | Nobody has touched this, directly visible |
| Improve "Severities vectors" tab | UI | Easy/Medium | UI work, different from importer crowd |
| Collect data from Anchore NVD overrides | Data source | Easy | Different from vendor importer pattern |
| Add CURL advisories data source | Data source | Easy | Unclaimed, simple pattern |
| Use centralized function for all network access | Architecture | Intermediate | High-value, nobody has claimed this |
| Add tests for Docker | Dev-env | Easy | Testing is always valued |
| Add data in CSAF format from cisagov/CSAF | Data | Medium | Good first issue + GSoC 24 label |
| Ingest github ecosystems | Data | Medium | Medium complexity, different from vendor advisories |

---

## Day 1 — March 19: First 2 PRs

### Setup (07:00–08:00)
```bash
git clone https://github.com/aboutcode-org/vulnerablecode.git
cd vulnerablecode
pip install -r requirements.txt
python manage.py migrate
pytest  # Verify all pass
pip install black isort
black --check .
isort --check .
```

### PR #1 — "Sort packages newest-to-oldest" (08:00–10:00)

**Issue location:** Open issues, `difficulty:easy` + `ui` labels
**What to change:**
- Find the PackageViewSet in the API
- Add default ordering (`-updated_at` or `-created_at`) to the queryset
- Do the same for VulnerabilityViewSet
- Add a test asserting sort order

**Claim comment:**
```
I'd like to work on this as a GSoC 2026 applicant (NLP/ML vulnerability
detection project).

My approach:
1. Add `ordering = ['-updated_at']` to PackageViewSet queryset
2. Same for VulnerabilityViewSet
3. Add API test verifying newest records appear first in response

DCO: I'll sign off all commits with -s flag.
Starting now.
```

```bash
git checkout -b fix/sort-packages-newest-first main
# Make changes
black . && isort .
pytest tests/  # Full suite
git add [specific files only]
git commit -s -m "fix: sort packages and vulnerabilities newest-first in API"
git push origin fix/sort-packages-newest-first
```

### PR #2 — "Use centralized function for all network access" (10:30–12:30)

**Issue location:** `difficulty:intermediate` label
**This is the high-value PR** — shows architectural thinking vs. importer spam

**What to change:**
- Create `utils/network.py` with a `fetch_url(url, timeout=30, retries=3)` function
- Migrate 2–3 importers to use it (don't need to migrate all — establish the pattern)
- Add tests for the utility function with mock responses

```bash
git checkout -b feat/centralized-network-access main
# Create the utility, migrate 2-3 importers
black . && isort .
pytest tests/
git add [specific files]
git commit -s -m "feat: add centralized network access utility with retry logic"
git push origin feat/centralized-network-access
```

---

## Day 2 — March 20: PRs #3 and #4

**08:00–08:30:** Respond to any overnight feedback on PRs #1/#2.

### PR #3 — "Improve Severities vectors tab" (08:30–11:00)

**Issue location:** `difficulty:easy` + `ui` labels
**What to change:** Frontend Django template or API for the Vulnerability detail page

```bash
git checkout -b feat/improve-severities-tab main
```

### PR #4 — "Add tests for Docker" (11:00–13:00)

**Issue location:** `dev-env` label
**What to change:** Add pytest tests verifying Docker development environment setup

```bash
git checkout -b test/docker-dev-environment main
```

---

## Day 3 — March 21: PR #5

### PR #5 — "Add CURL advisories data source" (08:30–10:30)

**Note:** This is different from the importer spam — CURL is a widely-used library with official security advisories. Frame it as completing a data source, not adding another vendor importer.

```bash
git checkout -b feat/curl-advisories-source main
```

**After submitting:** Post proposal outline to Gitter/GitHub Discussions.

---

## Day 4 — March 22: PR #6 + Proposal

### PR #6 — "Ingest GitHub ecosystems" or API endpoint improvement (09:00–11:00)

By now you have 5 PRs in the queue. One or more should be merged or close to it.
Pick the most strategic remaining issue and submit a final PR before switching to full proposal mode.

**13:00–21:00:** Finalize proposal. This is the most important deliverable today.

---

## PR Checklist (Every PR)

- [ ] DCO signed: commit has `-s` flag (adds `Signed-off-by: Zakir Jiwani <jiwzakir@gmail.com>`)
- [ ] `black .` passes
- [ ] `isort .` passes
- [ ] `pytest` passes locally
- [ ] Not an importer — verify your PR is not just "Add [X] importer"
- [ ] Issue commented before starting work
- [ ] PR description: clear what + why + how tested
- [ ] Issue linked: `Closes #NNN`
- [ ] No unrelated changes

---

## Competitor Awareness

| Competitor | Their PRs | Are They a Threat? | Action |
|-----------|----------|-------------------|--------|
| NucleiAv | 6 importer PRs — NONE merged | Low (doing wrong thing) | Don't copy their approach |
| Tednoob17 | 3 importer PRs — NONE merged | Low (doing wrong thing) | Don't copy their approach |
| ziadhany | "Add API/UI for vulnerability rules" — 1 merged | Medium | They're doing the right thing — study their approach |

**Key insight:** The "add an importer" path is saturated AND the core team isn't merging them. Do what ziadhany is doing: API/UI/architecture features.

---

## Target Issue Numbers (From Intelligence)

From REPO_INTELLIGENCE.md — good first issues available:
- UI/API sort order (newest-to-oldest)
- Severities vectors tab improvement
- Anchore NVD overrides
- CSAF format from cisagov/CSAF (labeled GSoC 24 + good first issue)
- CURL advisories
- GitHub ecosystems ingestion
- Centralized network access function
- Docker dev environment tests

**Note:** Always verify these issues are still open and unclaimed before starting. Run:
```bash
gh api "repos/aboutcode-org/vulnerablecode/issues/[number]" | jq '.state, .title'
```

---

## Key Resources

| Resource | URL |
|----------|-----|
| Repository | https://github.com/aboutcode-org/vulnerablecode |
| Issues | https://github.com/aboutcode-org/vulnerablecode/issues |
| CONTRIBUTING.rst | https://github.com/aboutcode-org/vulnerablecode/blob/main/CONTRIBUTING.rst |
| Gitter | https://gitter.im/aboutcode-org/vulnerablecode |

---

**Last Updated:** March 19, 2026 (post-intelligence rewrite)
**Priority:** #1 of 5
