# VulnerableCode: 5-Day Blitz Contribution Plan

**Project:** NLP/ML Vulnerability Detection from Unstructured Data
**Organization:** AboutCode
**Proposal deadline:** March 24, 2026
**Stack:** Python, Django, DRF, NLP/ML, spaCy/HuggingFace, PostgreSQL

---

## CRITICAL RULES

1. **Sign the DCO** before your first commit: `git commit -s`
2. **Comment on issue first** — "I'd like to work on this" before starting any code
3. **Run `black` and `isort`** before every commit
4. **Run `pytest`** locally before submitting any PR
5. **All tests must pass** — open issues for failures you find, don't just work around them

---

## Day 1 — March 19: Setup + DCO + First Issue

### Hour-by-Hour

**08:00–09:30 — Environment Setup**
```bash
git clone https://github.com/aboutcode-org/vulnerablecode.git
cd vulnerablecode
# Install dependencies
pip install -r requirements.txt
python manage.py migrate
# Verify tests pass
pytest
# Setup code quality tools
pip install black isort
black --check .
isort --check .
```

**09:30–10:00 — DCO Setup**
```bash
# Configure git for signed commits (required by AboutCode)
git config --global user.name "Zakir Jiwani"
git config --global user.email "jiwzakir@gmail.com"

# Add sign-off hook (auto-signs future commits)
# All commits need -s: git commit -s -m "message"
```

**10:00–11:30 — Issue Hunt**

Browse: `https://github.com/aboutcode-org/vulnerablecode/issues`

Best first targets:
- `good-first-issue` label
- Documentation improvements
- Missing tests for existing importers
- Small bug fixes in importers

Ideal first PR: Add a test for an existing importer function that lacks coverage. This is directly relevant to the NLP project (you'll need to write similar tests for the NLP pipeline).

**11:30–12:00 — Claim Issue**
```
I'd like to work on this as a GSoC 2026 applicant (NLP/ML vulnerability
detection project).

I've reviewed the codebase and understand the scope. My approach:
1. [Step 1]
2. [Step 2]
3. Test: [specific test behavior]

Starting now.
```

**12:00–14:00 — First PR**
```bash
git checkout -b fix/issue-NNN-description main
# Make the change
black .
isort .
pytest tests/  # Run relevant tests
git add [specific files]
git commit -s -m "fix: [clear description]"
git push origin fix/issue-NNN-description
```

Open PR. Use conventional commit format. Explain what and why.

**14:00–15:00 — Community Intro**

Post in AboutCode community (IRC/Matrix or GitHub Discussions):
```
Hi AboutCode team! I'm Zakir, ML/AI developer (LangChain, LangGraph,
transformers, spaCy). Applying for GSoC 2026 on NLP/ML vulnerability
detection.

I've contributed to RAG evaluation systems (spectra) and multi-agent
frameworks (lattice) — both involve similar extraction + confidence
scoring problems to what the VulnerableCode NLP project needs.

Just submitted PR #NNN on [issue]. Working through the codebase.

GitHub: JiwaniZakir
```

**15:00–17:00 — NLP Research**

Study the existing importer framework:
- Read `/vulnerabilities/importers/` — how are importers structured?
- Read `/vulnerabilities/models.py` — what fields matter?
- Understand the existing data pipeline

Note: What text fields exist that could be used for NLP extraction? (CVE descriptions, advisory text, etc.)

**17:00–19:00 — Proposal Skeleton**

Write in PROPOSAL_DRAFT.md: synopsis, problem statement, NLP pipeline architecture outline.

---

## Day 2 — March 20: Second PR + NLP Design Thinking

**Target:** Second PR submitted. Technical NLP architecture question asked.

### Tasks

**08:00–09:00** — Address Day 1 PR feedback immediately.

**09:00–12:00** — **PR #2: Importer Test or Small Feature**

Best targets:
- Add tests for an existing importer that has low coverage
- Fix a small validation bug in an existing importer
- Improve error handling in one importer

This doubles as NLP prep — understanding importer structure is essential for designing the NLP importer.

**12:00–14:00** — Post a technical question to the community:
```
Hi — working on my GSoC proposal for NLP vulnerability detection.

I've been studying the importer framework and noticed that importers
follow a pattern of: [your observation about the pattern].

For the NLP importer I'm designing, the key question is:
Should NLP-extracted vulnerabilities go through the same importer
interface, or does the confidence scoring require a separate pipeline
with a different status field?

My instinct: same importer interface but with a new `confidence_score`
field on the output, so NLP-extracted data is visually distinct
but uses the same deduplication logic.

Does this align with how the team is thinking about it?
```

**14:00–17:00** — Study NLP requirements:
- What fields need to be extracted? (CVE ID, package name, version range, severity)
- What models are suitable? (spaCy NER, HuggingFace transformers, regex + ML hybrid)
- What does "confidence scoring" look like in practice?

**17:00–21:00** — Write full Technical Approach in proposal.

---

## Day 3 — March 21: More Substance

**Target:** Third PR + proposal 80% complete.

### Tasks

**09:00–12:00** — **PR #3: More substantial contribution**

Options:
- Improve an existing importer to handle more edge cases
- Add a new small importer for a data source you've researched
- Add comprehensive tests to an undertested module

**12:00–14:00** — Community: review 2 open PRs. Leave substantive comments.

**14:00–16:00** — Mentor outreach: ask a specific question about the NLP pipeline design.

**16:00–21:00** — Complete Timeline + Deliverables + About Me in proposal.

---

## Day 4 — March 22: Polish

**Target:** Proposal review-ready.

### Tasks

**09:00–11:00** — Address all PR feedback.

**11:00–13:00** — Post proposal outline to community for feedback.

**13:00–21:00** — Final proposal polish.

---

## Day 5 — March 23: Submit

**Target:** Proposal submitted. All PRs in clean state.

---

## PR Checklist

- [ ] DCO signed: commit has `-s` flag (adds `Signed-off-by: Name <email>`)
- [ ] `black .` passes
- [ ] `isort .` passes
- [ ] `pytest` passes
- [ ] PR description: clear what + why
- [ ] Issue linked
- [ ] No unrelated changes

---

## Key VulnerableCode Resources

| Resource | URL |
|----------|-----|
| Repository | https://github.com/aboutcode-org/vulnerablecode |
| Issues | https://github.com/aboutcode-org/vulnerablecode/issues |
| NVD feed | Starting point for understanding data formats |
| spaCy docs | https://spacy.io/usage/linguistic-features |

---

**Last Updated:** March 19, 2026
**Mode:** 5-day blitz
