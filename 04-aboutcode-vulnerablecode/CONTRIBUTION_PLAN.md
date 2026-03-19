# Contribution Plan for VulnerableCode GSoC 2026

## Pre-GSoC Preparation (March-April 2026)

### Phase 0: Prerequisites & Environment Setup
**Goal:** Get familiar with the codebase and development workflow.

**Tasks:**
1. **Sign Certificate of Origin (DCO)**
   - Required for all commits to AboutCode projects
   - Link provided in CONTRIBUTING.rst
   - One-time setup; sign with git commit hook

2. **Clone and Set Up Local Environment**
   ```bash
   git clone https://github.com/aboutcode-org/vulnerablecode.git
   cd vulnerablecode
   pip install -r requirements.txt
   python manage.py migrate
   ```

3. **Verify Development Environment**
   - Python 3.8+ (`python --version`)
   - PostgreSQL running (`psql --version`)
   - Docker/Docker Compose (optional but recommended)
   - Run `pytest` to ensure all tests pass locally

4. **Install Code Quality Tools**
   - black (code formatting)
   - isort (import sorting)
   - mypy (type checking)
   - Set up IDE integration (e.g., VSCode pre-commit hooks)

5. **Read Documentation**
   - vulnerablecode.readthedocs.org (start here)
   - `/docs` folder in repo (source RST files)
   - CONTRIBUTING.rst (review project norms)
   - README.rst (project overview)

---

### Phase 1: First Contribution - Documentation & Simple Fixes
**Timeline:** Week 1-2 of pre-GSoC period
**Goal:** Complete 1-2 merged PRs to understand contribution workflow.

**Why Start Here:**
- Low barrier to entry
- Fast feedback cycle from maintainers
- Demonstrates commitment
- Builds familiarity with PR review process and CI/CD

#### 1A. Documentation Improvements

**Pick one of these:**

1. **Improve API Documentation**
   - Location: `/docs/source/api.rst` or docstrings in `/vulnerablecode/api/views.py`
   - Task: Add example API requests/responses for key endpoints
   - Example: "Query vulnerabilities by severity"
   ```rst
   Example Request
   ===============

   .. code-block:: bash

       curl -X GET "http://localhost:8000/api/v1/vulnerabilities/?severity=critical"

   Example Response
   ================

   .. code-block:: json

       {
           "count": 42,
           "results": [...]
       }
   ```
   - Merges: Usually within 1 week

2. **Add Setup Guide for Docker**
   - Location: `/docs/source/installation.rst` or new file
   - Task: Write step-by-step guide for developers preferring Docker
   - Include troubleshooting section
   - Example issues to reference: Check GitHub issues for "docker" or "setup"

3. **Document Importer Pattern**
   - Location: `/docs/source/developers/importers.rst` (may not exist, create it)
   - Task: Write guide for creating new importers (critical for GSoC project)
   - Include code template and real-world example (e.g., Debian Importer)
   - Section topics:
     - What is an importer?
     - Base class structure
     - Fetch → Parse → Validate → Load pattern
     - Testing an importer
     - Submitting as PR

**Submission Checklist:**
- [ ] File edited or created in `/docs`
- [ ] Run `make docs` locally to verify no Sphinx errors
- [ ] Proof-read for typos and clarity
- [ ] Sign DCO in commit message: `-s` flag or manual sign-off
- [ ] Title format: `docs: add [topic] documentation`

#### 1B. Fix Simple Issues

**Find Issues:**
- Go to https://github.com/aboutcode-org/vulnerablecode/issues
- Filter: `label:easy` or `label:good-first-issue`
- Examples: Typos, minor refactoring, dependency updates, docstring fixes

**Example Issues (from typical repo):**
- "Update deprecated Django ORM call in VulnerableRange model"
- "Add missing docstring to Package.purl property"
- "Fix typo in requirements.txt comment"

**Submission Checklist:**
- [ ] Issue referenced in PR: "Fixes #[issue-number]"
- [ ] Code follows black/isort formatting
- [ ] Related tests pass: `pytest tests/test_[module].py`
- [ ] Commit message is descriptive
- [ ] Sign DCO: `-s` flag in git commit

---

### Phase 2: Intermediate Contribution - New Importer
**Timeline:** Week 3-4 of pre-GSoC period
**Goal:** Demonstrate understanding of data pipeline framework.

**Why Build an Importer:**
- Direct practice with aboutcode.pipeline framework
- Reference implementations exist (Debian, Check Point, Grafana)
- Mentors highly value this (shows NLP/ML readiness)
- ~1000-1500 LOC; achievable in 1-2 weeks

#### 2A. Choose a Data Source

**Option 1: Changelog Parser (Easier, Recommended)**
- **Source:** Package changelogs (e.g., from PyPI, npm registry)
- **Format:** Semi-structured text (often markdown or plain text)
- **Example:**
  ```
  # Version 2.5.0 (2024-03-01)
  - Fix: SQL injection vulnerability in query parser (CVE-2024-1234)
  - Security: Update crypto library to v1.9.2
  ```
- **Goal:** Extract vulnerability mentions, link to existing CVEs
- **Difficulty:** Medium (parsing, pattern matching)

**Option 2: GitHub Security Advisories (Moderate)**
- **Source:** GitHub API for public advisories on repos
- **Format:** Structured JSON, but rich semantic info
- **Goal:** Import advisories as Vulnerability records
- **Difficulty:** Moderate (API interaction, data mapping)

**Option 3: NLM MEDLINE for Health/Pharma (Harder)**
- **Source:** NLM vulnerability mentions in medical software
- **Format:** MEDLINE XML
- **Goal:** Extract software vulnerability references
- **Difficulty:** Hard (domain-specific parsing)

**Recommendation:** Start with **Changelog Parser** to build confidence.

#### 2B. Implementation Steps

1. **Study Existing Importers**
   ```bash
   # Read Debian importer as reference
   cat vulnerablecode/importers/debian/importer.py
   cat vulnerablecode/importers/debian/parser.py
   cat vulnerablecode/importers/debian/tests/test_importer.py
   ```

2. **Create Importer Structure**
   ```python
   # vulnerablecode/importers/changelog_importer/importer.py
   from aboutcode.pipeline import importer
   from vulnerablecode.models import Vulnerability, Package

   class ChangelogImporter(importer.BaseImporter):
       """Extract vulnerabilities from package changelogs"""

       def fetch_data(self):
           """Download changelogs from PyPI/npm/etc"""
           pass

       def parse_changelog(self, changelog_text):
           """Extract vulnerability mentions using regex/NLP"""
           # Return: [(package, version, cve_id, description), ...]
           pass

       def load_to_db(self, parsed_data):
           """Create Vulnerability and Package records"""
           pass
   ```

3. **Write Tests**
   ```python
   # vulnerablecode/importers/changelog_importer/tests/test_importer.py
   import pytest
   from vulnerablecode.importers.changelog_importer.importer import ChangelogImporter

   def test_parse_changelog_with_cve():
       text = "# v2.5.0\nFix: CVE-2024-1234"
       importer = ChangelogImporter()
       result = importer.parse_changelog(text)
       assert result[0]['cve_id'] == 'CVE-2024-1234'
   ```

4. **Document the Importer**
   ```rst
   # vulnerablecode/importers/changelog_importer/README.rst
   Changelog Importer
   ==================

   This importer extracts vulnerability information from package changelogs.

   Data Source
   -----------
   - PyPI changelogs
   - npm package histories
   - GitHub releases

   Approach
   --------
   1. Fetch changelog from package registry
   2. Parse for CVE mentions (regex + NLP)
   3. Link to existing Vulnerability records
   4. Create VulnerableRange entries
   ```

5. **Submit PR**
   - Title: "Add changelog importer for [source]"
   - Description: Explain data source, approach, challenges
   - Include: Code, tests (>80% coverage), documentation
   - Reference: Issue #251 ("Process unstructured data sources")

**Timeline:** 1-2 weeks
**Expected Feedback:** Mentors will suggest improvements; iterate 1-2 rounds

---

## GSoC Official Period (May-August 2026)

### Phase 3: GSoC Project - NLP/ML for Vulnerability Detection

This phase builds on Phase 1-2 work, now with full-time focus.

#### 3A. Project Definition (Week 1)

**Goal:** Finalize technical approach with mentors.

**Discussions with Mentors:**
1. **Data Sources to Target**
   - Mailing lists (e.g., full-disclosure mailing list)
   - GitHub security advisories and issue comments
   - Package changelogs (continued from Phase 2)
   - CVE description text enrichment
   - Bug tracker discussions (Mozilla Firefox Security Tracker, etc.)

2. **NLP/ML Approach**
   - **Option A (Hybrid):** Regex + rule-based extraction + ML confidence scoring
     - Simpler, easier to debug, aligns with aboutcode philosophy
   - **Option B (Pure ML):** Fine-tuned transformer model (BERT, RoBERTa)
     - More powerful, harder to maintain, requires training data
   - **Option C (Ensemble):** Combine rule-based + ML for robustness
     - Best of both worlds, more complex

3. **Confidence Scoring**
   - ML model outputs confidence (0.0-1.0) for each extracted field
   - Data scientists can filter by confidence threshold
   - Example: `{"cve_id": "CVE-2024-1234", "confidence": 0.87}`

4. **Integration Plan**
   - New importer: `UnstructuredDataImporter` (inherits BaseImporter)
   - New API endpoint: `/api/v1/vulnerabilities?source=nlp&confidence_min=0.8`
   - New model field: `Vulnerability.extraction_confidence`

#### 3B. Architecture & Design (Week 2)

**Deliverables:**
1. **Technical Design Document** (2-3 pages)
   - Data sources and access methods
   - NLP/ML pipeline diagram
   - Data transformation examples
   - Integration with existing importer framework

2. **Data Collection Plan**
   - Which mailing lists/sources to sample
   - Sample size for training/validation
   - Annotation scheme (how to label data as ground truth)

3. **Model Selection**
   - Chosen NLP/ML approach (regex + ML vs. pure ML)
   - Libraries (spacy, transformers, sklearn, etc.)
   - Training strategy (if applicable)

**Example Architecture:**
```
Unstructured Text (Mailing list message)
    ↓
[NLP Pipeline]
    - Tokenization
    - Named Entity Recognition (identify package names)
    - Relation Extraction (link packages to vulnerabilities)
    ↓
[ML Confidence Scoring]
    - Logistic regression or neural network
    - Input: extracted field + context
    - Output: confidence score (0.0-1.0)
    ↓
[Validation]
    - Cross-reference with existing CVE database
    - Threshold filtering (only confidence > 0.7)
    ↓
[Django Models]
    - Create Vulnerability records
    - Link to extracted Packages
    - Store confidence score
```

**Mentor Sign-Off:** Mentors approve design before heavy implementation

#### 3C. Core Implementation (Weeks 3-8)

**Sprint 1: NLP Pipeline (Weeks 3-4)**

**Goal:** Reliable extraction of vulnerability information.

**Tasks:**
1. **Implement Text Preprocessing**
   ```python
   # vulnerablecode/nlp/preprocessor.py
   def clean_text(raw_text):
       """Remove markup, normalize whitespace"""
       pass

   def segment_sentences(text):
       """Split into sentences for processing"""
       pass
   ```

2. **Implement Entity Recognition**
   ```python
   # vulnerablecode/nlp/entity_recognition.py
   def extract_cve_ids(text):
       """Find CVE-XXXX-XXXXX patterns"""
       return re.findall(r'CVE-\d{4}-\d{4,}', text)

   def extract_package_names(text):
       """Identify package names (harder: context-dependent)"""
       # Use spaCy NER or custom rules
       pass

   def extract_versions(text):
       """Find version numbers in context"""
       pass
   ```

3. **Implement Relation Extraction**
   ```python
   # vulnerablecode/nlp/relation_extraction.py
   def link_package_to_cve(text, package_name, cve_id):
       """Determine if package CVE vulnerability relationship exists"""
       # Check: Does text mention both package and CVE in same sentence/paragraph?
       pass
   ```

4. **Write Unit Tests**
   ```python
   # tests/test_nlp_entity_recognition.py
   def test_extract_cve_ids():
       text = "This affects CVE-2021-44228 and CVE-2024-1234"
       result = extract_cve_ids(text)
       assert result == ['CVE-2021-44228', 'CVE-2024-1234']
   ```

**Sprint 2: ML Confidence Scoring (Weeks 5-6)**

**Goal:** Filter low-confidence extractions.

**Tasks:**
1. **Collect Training Data**
   - Manually annotate 100-200 samples (mailing list messages)
   - Labels: CVE ID (correct/incorrect), Package (correct/incorrect), Relationship (correct/incorrect)
   - Tool: Use Prodigy or simple CSV with annotations

2. **Train Classification Models**
   ```python
   # vulnerablecode/ml/confidence_scorer.py
   from sklearn.ensemble import RandomForestClassifier
   from sklearn.feature_extraction.text import TfidfVectorizer

   def train_confidence_scorer(annotated_data):
       """Train model on labeled extraction examples"""
       # Feature engineering: context length, keyword presence, etc.
       # Output: sklearn model saved to disk
       pass

   def score_extraction(extracted_cve, context_text):
       """Return confidence (0.0-1.0) for extraction"""
       # Input model features → Output confidence
       pass
   ```

3. **Validate on Test Set**
   - Precision, Recall, F1-Score metrics
   - Target: >85% precision at threshold of 0.7 confidence

**Sprint 3: Importer Integration (Weeks 7-8)**

**Goal:** Integrate NLP/ML into aboutcode pipeline framework.

**Tasks:**
1. **Create UnstructuredDataImporter Class**
   ```python
   # vulnerablecode/importers/unstructured_importer.py
   class UnstructuredDataImporter(BaseImporter):
       """Pipeline for mailing lists, changelogs, etc."""

       def fetch_data(self):
           """Download from sources (mailing lists, GitHub, etc.)"""
           pass

       def nlp_extract(self, text):
           """Call NLP + ML pipeline"""
           cves = extract_cve_ids(text)
           packages = extract_package_names(text)
           relations = link_packages_to_cves(text, packages, cves)

           results = []
           for rel in relations:
               confidence = score_extraction(rel['cve'], text)
               results.append({
                   'cve_id': rel['cve'],
                   'package': rel['package'],
                   'confidence': confidence,
                   'source_url': rel['source_url'],
               })
           return results

       def load_to_db(self, nlp_results, confidence_threshold=0.7):
           """Create Django models for high-confidence extractions"""
           for result in nlp_results:
               if result['confidence'] < confidence_threshold:
                   continue

               vuln, created = Vulnerability.objects.get_or_create(
                   vulnerability_id=result['cve_id'],
                   defaults={'data_source': self.data_source}
               )
               # ... link to packages, etc.
   ```

2. **Create Data Models**
   ```python
   # vulnerablecode/models.py (add fields)
   class Vulnerability(models.Model):
       # ... existing fields ...
       extraction_confidence = FloatField(null=True, blank=True)
       extraction_method = CharField(choices=[
           ('manual', 'Manual'),
           ('imported', 'Imported Advisory'),
           ('nlp', 'NLP-Extracted'),
       ])
   ```

3. **Create API Endpoint**
   ```python
   # vulnerablecode/api/views.py
   class VulnerabilityViewSet(viewsets.ModelViewSet):
       queryset = Vulnerability.objects.all()
       serializer_class = VulnerabilitySerializer
       filter_backends = [DjangoFilterBackend]
       filterset_fields = ['extraction_method', 'extraction_confidence']

       # Now: /api/v1/vulnerabilities?extraction_method=nlp&confidence_min=0.7
   ```

4. **Comprehensive Testing**
   - Unit tests for each NLP component
   - Integration tests for importer
   - End-to-end test: Input text → Database records → API response

**Checkpoint (End of Week 8):**
- Mentors review code quality, test coverage, documentation
- Merged into main branch (pending review feedback)

#### 3D. Refinement & Documentation (Weeks 9-12)

**Sprint 4: Performance & Optimization (Week 9)**

**Tasks:**
1. **Profile NLP Pipeline**
   - Measure time per message: target <500ms per item
   - Optimize bottlenecks (e.g., model loading, feature extraction)

2. **Implement Caching**
   - Cache trained ML model in Redis
   - Cache parsed changelogs to avoid re-parsing

3. **Batch Processing**
   - Process mailing list archives in batches (e.g., 100 messages/job)
   - Use RQ job queue for long-running imports

**Sprint 5: Advanced Features (Week 10)**

**Pick one or more based on progress:**

1. **Multilingual Support**
   - Support vulnerability descriptions in Spanish, French, German
   - Use spaCy multilingual models

2. **Relationship Confidence**
   - Confidence score for package-to-CVE links (in addition to field confidence)
   - Example: "We extracted CVE-2024-1234 (confidence: 0.92) affecting lodash (confidence: 0.88), link confidence: 0.85"

3. **Feedback Loop**
   - Allow users to mark AI extractions as correct/incorrect
   - Use feedback to improve model (active learning)

4. **Source-Specific Tuning**
   - Different confidence thresholds for different sources
   - E.g., Higher threshold for noisy mailing lists, lower for structured advisories

**Sprint 6: Documentation & Outreach (Weeks 11-12)**

**Deliverables:**
1. **Technical Documentation**
   - `/docs/source/developers/nlp-ml-pipeline.rst` (1000+ words)
   - Components: Preprocessing, entity recognition, relation extraction, confidence scoring
   - Usage examples
   - Troubleshooting guide

2. **User Guide**
   - How to query NLP-extracted vulnerabilities via API
   - Interpreting confidence scores
   - Best practices for different use cases

3. **Architecture Decision Records (ADR)**
   - Document why certain NLP/ML approaches were chosen
   - Trade-offs considered
   - Future improvements

4. **Blog Post / Write-Up**
   - Share on AboutCode blog or Medium
   - "Extracting Vulnerabilities from Unstructured Sources using NLP"
   - Reach: Attract contributors, users, security community

5. **Video Walkthrough** (Optional)
   - 10-min demo of NLP pipeline in action
   - Record and link in documentation

---

## Code Quality Standards (Throughout All Phases)

### Required for Every Commit

**1. DCO Sign-Off**
```bash
git commit -s -m "Fix: improve vulnerability extraction"
# Or add manually:
# Co-Authored-By: Your Name <your.email@example.com>
```

**2. Code Formatting (black)**
```bash
black vulnerablecode/ tests/
```

**3. Import Ordering (isort)**
```bash
isort vulnerablecode/ tests/
```

**4. Type Checking (mypy)**
```bash
mypy vulnerablecode/ --ignore-missing-imports
```

**5. Testing (pytest)**
```bash
pytest tests/ -v --cov=vulnerablecode --cov-report=html
```
- Target: >85% code coverage
- All tests pass locally before pushing

**6. Linting (Optional but Encouraged)**
```bash
flake8 vulnerablecode/ --max-line-length=88
pylint vulnerablecode/
```

### PR Submission Checklist

- [ ] All tests pass: `pytest tests/`
- [ ] Code formatted: `black . && isort .`
- [ ] Type checked: `mypy vulnerablecode/`
- [ ] DCO signed: `git commit -s`
- [ ] PR title is descriptive (e.g., "feat: add NLP entity recognition for CVE IDs")
- [ ] PR description includes: What/Why/How, related issue(s), testing notes
- [ ] Screenshots/examples if UI changes
- [ ] Documentation updated if applicable
- [ ] Backwards compatible (or breaking change justified)

---

## Communication & Collaboration

### Weekly Engagement

**Monday-Wednesday: Async Work**
- Implement features
- Write tests
- Push branches for feedback

**Thursday: Mentor Sync**
- 30-min video call with mentors (Pombredanne + Keshav-space)
- Progress update
- Design questions, blockers
- Next week planning

**Friday: Gitter Check-in**
- Post weekly update to gitter.im/aboutcode-org/vulnerablecode
- Example format:
  ```
  **Week 4 Update**
  - Completed: NLP entity recognition for CVE IDs (87% test coverage)
  - In Progress: ML confidence scoring, collecting training data
  - Blockers: Need clarification on version range format
  - Next: Submit PR for entity recognition by Wednesday
  ```

### Issue Discussion

- Comment on related GitHub issues with progress
- Ask questions early (don't wait until stuck for days)
- Share partial work for feedback (WIP PRs)

### Documentation of Decisions

- Keep ADR (Architecture Decision Record) file updated
- Explain rationale for technical choices
- Helps future maintainers and contributors

---

## Timeline Summary

| Phase | Weeks | Focus | Deliverables |
|-------|-------|-------|--------------|
| **Phase 0** | -4 to -2 | Setup & Prerequisites | Local env working, DCO signed |
| **Phase 1** | -2 to -1 | Docs + Simple Fixes | 1-2 merged PRs (docs/easy issues) |
| **Phase 2** | -1 | Intermediate Importer | Merged importer PR (changelog or similar) |
| **Phase 3A** | 1 | Project Definition | Design doc approved by mentors |
| **Phase 3B** | 2 | Architecture & Design | Architecture ADR, data plan finalized |
| **Phase 3C-Sprint1** | 3-4 | NLP Pipeline | Entity recognition, relation extraction implemented |
| **Phase 3C-Sprint2** | 5-6 | ML Scoring | Confidence models trained, >85% precision |
| **Phase 3C-Sprint3** | 7-8 | Importer Integration | Merged into main, API endpoints working |
| **Phase 3D-Sprint4** | 9 | Performance | Optimizations, caching, batch processing |
| **Phase 3D-Sprint5** | 10 | Advanced Features | Optional: multilingual, feedback loop, etc. |
| **Phase 3D-Sprint6** | 11-12 | Documentation | Guides, blog post, video walkthrough |

---

## Success Metrics

By end of GSoC, you will have:

✅ **Code Contributions**
- 15-20 merged PRs across all phases
- 3000+ lines of production code (NLP/ML pipeline + importer)
- >85% test coverage

✅ **Skills Gained**
- Deep Django/DRF expertise
- NLP/ML pipeline design and implementation
- Open-source collaboration (DCO, PR reviews, mentorship)

✅ **Community Impact**
- VulnerableCode gains NLP-powered data extraction
- New importer(s) integrated for unstructured sources
- Documentation and examples for future contributors

✅ **Mentorship Quality**
- Regular feedback from Pombredanne and Keshav-space
- Clear communication of blockers and progress
- Professional code quality standards

---

## Resources & References

- **Official Docs:** vulnerablecode.readthedocs.org
- **CONTRIBUTING.rst:** github.com/aboutcode-org/vulnerablecode/blob/develop/CONTRIBUTING.rst
- **Issue #251:** "Process unstructured data sources" (core GSoC challenge)
- **Gitter Channel:** gitter.im/aboutcode-org/vulnerablecode
- **Weekly Meetings:** Details in welcome message upon joining Gitter

**Good luck! 🚀**
