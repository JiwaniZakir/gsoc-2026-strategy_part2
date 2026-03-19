# GSoC 2026 Proposal: NLP/ML for Vulnerability Detection from Unstructured Data

**Student:** Zakir Jiwani
**GitHub:** github.com/zakirjiwani
**Email:** [your email]
**University:** [Your University]
**Time Zone:** [Your Timezone]
**Availability:** Full-time (40 hours/week)

---

## Executive Summary

This proposal outlines a comprehensive solution for extracting vulnerability information from unstructured data sources using Natural Language Processing (NLP) and Machine Learning (ML). The project will extend VulnerableCode's existing importer framework to automatically identify and structure vulnerability data from mailing lists, changelogs, GitHub issues, and other semi-structured sources, reducing reliance on manual data entry and expanding data coverage.

**Key Outcomes:**
- NLP/ML pipeline extracting CVE IDs, affected packages, and severity levels
- Confidence scoring for ML-extracted data (enabling quality filtering)
- Seamless integration with existing Django ORM and REST API
- 15+ new data sources automated through importers

---

## Background & Motivation

### Problem Statement

VulnerableCode currently aggregates vulnerability data from structured feeds (NVD, Debian advisories, vendor advisories). However, critical security information exists in unstructured sources:

- **Security mailing lists** (full-disclosure, oss-security) — detailed vulnerability discussions, fix links
- **Package changelogs** — "Fixed CVE-XXXX-XXXXX" entries buried in markdown or plain text
- **GitHub issue comments** — security reports and fixes in open discussions
- **CVE description text** — rich contextual information requiring parsing
- **Bug tracker comments** — Mozilla Firefox, Apache projects, etc.

**Current Gap:** These sources require manual data entry, causing:
- Delayed vulnerability data ingestion
- Incomplete coverage (smaller libraries, regional advisories)
- High operational cost (staff time for manual processing)

### Proposed Solution

Design and implement an **NLP/ML pipeline** that:

1. **Ingests** unstructured text from multiple sources (mailing lists, changelogs, etc.)
2. **Extracts** structured vulnerability fields using NLP:
   - CVE IDs and URLs
   - Affected package names and versions
   - Fix information and version ranges
   - Severity and impact description
3. **Scores** confidence for each extraction using ML models
4. **Loads** high-confidence extractions into VulnerableCode database
5. **Integrates** seamlessly with existing aboutcode.pipeline framework

### Why This Matters

- **Expanded Coverage:** Unlock vulnerability data in thousands of changelogs and mailing list archives
- **Automation:** Reduce manual data entry burden on AboutCode team
- **Timeliness:** Faster ingestion of newly disclosed vulnerabilities
- **Community Impact:** Enable researchers and practitioners to identify vulnerabilities faster
- **Research Value:** Demonstrate feasibility of NLP-based vulnerability extraction (publishable findings)

---

## Project Scope

### Objectives (In Priority Order)

#### Primary Objectives (Must-Have)

**O1: NLP Entity Recognition Pipeline**
- Identify CVE IDs from text (regex + rule-based)
- Extract package names (using spaCy NER + knowledge base)
- Identify version numbers and version ranges
- Recognize fix information and affected version ranges
- **Target Accuracy:** >90% on test set

**O2: Relationship Extraction**
- Link extracted packages to CVEs (same sentence/paragraph scope)
- Identify version ranges affected (e.g., "up to 1.2.3")
- Extract fix version information
- **Target Accuracy:** >85% on relation linking

**O3: Confidence Scoring (ML)**
- Train logistic regression model on annotated data
- Score confidence (0.0-1.0) for each extraction
- Enable filtering by confidence threshold in API
- **Target:** >85% precision at 0.7 confidence threshold

**O4: Integration with Importer Framework**
- Create `UnstructuredDataImporter` class
- Implement for at least 2 data sources (changelogs + mailing list)
- Full integration with `aboutcode.pipeline` framework
- API endpoints for querying NLP-extracted vulnerabilities

**O5: Data Model Updates**
- Add `extraction_confidence` field to Vulnerability model
- Add `extraction_method` (manual/imported/nlp) enum
- Update serializers and API filters
- Maintain backwards compatibility

#### Secondary Objectives (Nice-to-Have)

**O6: Multiple Data Sources**
- Implement importers for 3-5 sources:
  - Python changelogs (PyPI registry)
  - npm changelog metadata
  - Full-disclosure mailing list archive
  - GitHub security advisories
  - Debian changelog XML

**O7: Multilingual Support**
- Support Spanish, French, German vulnerability descriptions
- Use spaCy multilingual models
- Test accuracy on non-English text

**O8: Active Learning / Feedback Loop**
- Allow users to mark AI extractions as correct/incorrect
- Use feedback to improve model over time
- Track feedback metrics in database

**O9: Advanced Features**
- Relationship confidence scoring (package-to-CVE confidence)
- Source-specific tuning (different thresholds for different sources)
- Temporal analysis (when was vulnerability discovered vs. fixed)

---

## Technical Approach

### Architecture Overview

```
┌─────────────────────────────────────────────────────────────┐
│         UNSTRUCTURED DATA SOURCES                           │
│  (Mailing lists, Changelogs, CVE text, Issue comments)    │
└────────────────┬────────────────────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────────────────────────┐
│         NLP PIPELINE                                         │
│  ┌──────────────────────────────────────────────────────┐  │
│  │ 1. PREPROCESSING                                     │  │
│  │    - Clean text (HTML, markdown, whitespace)        │  │
│  │    - Tokenization (sentence/word-level)             │  │
│  └──────────────────────────────────────────────────────┘  │
│  ┌──────────────────────────────────────────────────────┐  │
│  │ 2. ENTITY RECOGNITION                               │  │
│  │    - CVE ID extraction (regex: CVE-YYYY-XXXXX)      │  │
│  │    - Package name extraction (spaCy NER)            │  │
│  │    - Version identification                         │  │
│  │    - Fix information (link/version)                 │  │
│  └──────────────────────────────────────────────────────┘  │
│  ┌──────────────────────────────────────────────────────┐  │
│  │ 3. RELATION EXTRACTION                              │  │
│  │    - Link packages to CVEs (dependency parsing)     │  │
│  │    - Identify affected version ranges              │  │
│  │    - Extract fix information                        │  │
│  └──────────────────────────────────────────────────────┘  │
│  ┌──────────────────────────────────────────────────────┐  │
│  │ 4. CONFIDENCE SCORING (ML)                           │  │
│  │    - Extract features from context                  │  │
│  │    - ML model prediction                            │  │
│  │    - Output confidence score (0.0-1.0)             │  │
│  └──────────────────────────────────────────────────────┘  │
└────────────────┬────────────────────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────────────────────────┐
│    DATA VALIDATION & FILTERING                              │
│  - Cross-check against existing CVE database                │
│  - Filter by confidence threshold (e.g., >= 0.7)            │
│  - Check for duplicates                                     │
└────────────────┬────────────────────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────────────────────────┐
│    DJANGO ORM LOADING                                       │
│  - Create Vulnerability records with confidence field       │
│  - Link to Package records                                  │
│  - Create VulnerableRange entries                           │
│  - Set extraction_method = "nlp"                            │
└────────────────┬────────────────────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────────────────────────┐
│    REST API EXPOSURE                                        │
│  - /api/v1/vulnerabilities?extraction_method=nlp            │
│  - /api/v1/vulnerabilities?confidence_min=0.8              │
│  - Filter, sort, paginate results                           │
└─────────────────────────────────────────────────────────────┘
```

### NLP/ML Technology Stack

| Component | Technology | Rationale |
|-----------|-----------|-----------|
| **Text Processing** | spaCy 3.x | Industry standard, pre-trained models, NER, dependency parsing |
| **Entity Recognition** | spaCy NER + regex | Hybrid for CVE ID (regex) + package names (NER) |
| **ML Models** | scikit-learn (LogReg, RF) | Simple, interpretable, fast training |
| **Feature Engineering** | Custom (context windows, keyword presence) | Domain-specific features for vulnerability extraction |
| **Training Data** | Hand-annotated (200-500 samples) | Ground truth for ML model |
| **Version Control** | GitHub + DVC (optional) | Track model changes, training history |
| **Deployment** | Pickle serialization | Simple model loading in Django; no complex serving needed |

### Implementation Strategy

#### Phase 1: Data Preprocessing (Week 1-2)

**Goal:** Reliable text cleaning and tokenization

**Deliverables:**
```python
# vulnerablecode/nlp/preprocessor.py
class TextPreprocessor:
    def clean_text(text: str) -> str:
        """Remove HTML, markdown, normalize whitespace"""

    def segment_sentences(text: str) -> List[str]:
        """Split into sentences for processing"""

    def tokenize(text: str) -> List[str]:
        """Word-level tokenization"""
```

**Testing:** Unit tests for common text formats (HTML emails, markdown changelogs, plain text)

#### Phase 2: Entity Recognition (Week 3-4)

**Goal:** Extract CVE IDs, package names, versions

**Deliverables:**
```python
# vulnerablecode/nlp/entity_recognition.py
def extract_cve_ids(text: str) -> List[str]:
    """Find CVE-YYYY-XXXXX patterns using regex"""
    pattern = r'CVE-\d{4}-\d{4,}'
    return re.findall(pattern, text)

def extract_package_names(text: str) -> List[str]:
    """Use spaCy NER + knowledge base"""
    # Named entity recognition for ORG, PRODUCT entities
    # Cross-reference with known package names (PURL database)

def extract_versions(text: str) -> List[Tuple[str, str]]:
    """Extract version numbers in context"""
    # Pattern: "version 1.2.3", "v1.2.3", ">=1.0", etc.

def extract_fix_info(text: str) -> List[Dict]:
    """Identify fix version/link information"""
    # Find "fixed in X.Y.Z", "patch released", etc.
```

**Testing:**
- Test set: 100+ manually annotated examples
- Target accuracy: >90%

#### Phase 3: Relation Extraction (Week 5-6)

**Goal:** Link packages to CVEs, identify affected versions

**Deliverables:**
```python
# vulnerablecode/nlp/relation_extraction.py
def link_packages_to_cves(text: str, packages: List[str], cves: List[str]):
    """Determine if package affected by CVE in same context"""
    # Dependency parsing: "CVE-XXXX affects OpenSSL 1.0.0"

def extract_affected_range(text: str, package: str, cve: str):
    """Extract "affects versions X to Y" information"""

def extract_fix_version(text: str, package: str, cve: str):
    """Extract "fixed in version Z" information"""
```

**Testing:**
- Test set: 150+ examples with multiple packages/CVEs
- Target accuracy: >85%

#### Phase 4: ML Confidence Scoring (Week 7-8)

**Goal:** Train model to score extraction confidence

**Deliverables:**
```python
# vulnerablecode/ml/confidence_scorer.py
class ConfidenceScorer:
    def extract_features(self, extraction: Dict, context: str):
        """Feature engineering: context length, keyword match, etc."""
        features = {
            'context_length': len(context),
            'has_version': 'version' in context.lower(),
            'sentence_position': position_in_sentence,
            'keyword_count': count_relevant_keywords(context),
            # ... 20+ features
        }
        return features

    def train(self, annotated_data: List[Dict]):
        """Train logistic regression model"""
        X = [self.extract_features(d) for d in annotated_data]
        y = [d['label'] for d in annotated_data]  # correct=1, incorrect=0
        self.model = LogisticRegression().fit(X, y)

    def score(self, extraction: Dict, context: str) -> float:
        """Predict confidence (0.0-1.0)"""
        features = self.extract_features(extraction, context)
        return self.model.predict_proba(features)[0][1]
```

**Training Data Collection:**
- Week 6: Annotate 200-500 samples (correct/incorrect extractions)
- Use web form or CSV format
- Split: 80% train, 20% test

**Evaluation:**
- Precision/Recall/F1 on test set
- Target: >85% precision at 0.7 confidence threshold

#### Phase 5: Importer Integration (Week 9-10)

**Goal:** Integrate NLP/ML into aboutcode.pipeline

**Deliverables:**
```python
# vulnerablecode/importers/unstructured_importer/importer.py
class UnstructuredDataImporter(BaseImporter):
    """Pipeline for mailing lists, changelogs, etc."""

    def fetch_data(self):
        """Download from sources (source-specific)"""

    def nlp_extract(self, text: str):
        """Call NLP + ML pipeline"""
        cves = extract_cve_ids(text)
        packages = extract_package_names(text)
        relations = link_packages_to_cves(text, packages, cves)

        results = []
        for rel in relations:
            confidence = scorer.score(rel, text)
            results.append({
                'cve_id': rel['cve'],
                'package': rel['package'],
                'affected_version': rel['affected_version'],
                'fix_version': rel['fix_version'],
                'confidence': confidence,
                'source_url': self.source_url,
            })
        return results

    def load_to_db(self, nlp_results, confidence_threshold=0.7):
        """Create Django models (standard aboutcode pattern)"""
        for result in nlp_results:
            if result['confidence'] < confidence_threshold:
                continue

            vuln, _ = Vulnerability.objects.get_or_create(
                vulnerability_id=result['cve_id'],
                defaults={
                    'description': f'Extracted from {self.source_name}',
                    'data_source': self.data_source,
                    'extraction_confidence': result['confidence'],
                    'extraction_method': 'nlp',
                }
            )

            pkg, _ = Package.objects.get_or_create(
                purl=to_purl(result['package']),
            )

            VulnerableRange.objects.create(
                vulnerability=vuln,
                package=pkg,
                affected_version_range=result['affected_version'],
                fixed_version=result['fix_version'],
            )
```

**Importer Implementations (Multiple Data Sources):**

1. **Changelog Importer** (Python/npm changelogs)
   ```python
   class ChangelogImporter(UnstructuredDataImporter):
       def fetch_data(self):
           # Download PyPI JSON (all versions + changelogs)
           # Download npm registry data
   ```

2. **Mailing List Importer** (full-disclosure list archive)
   ```python
   class MailingListImporter(UnstructuredDataImporter):
       def fetch_data(self):
           # Download mailing list archives (MBOX format)
           # Parse email structure, extract body text
   ```

#### Phase 6: API & Data Model Updates (Week 11)

**Deliverables:**

```python
# vulnerablecode/models.py
class Vulnerability(models.Model):
    # ... existing fields ...
    extraction_confidence = FloatField(null=True, blank=True)
    extraction_method = CharField(choices=[
        ('manual', 'Manual Entry'),
        ('imported', 'Imported Advisory'),
        ('nlp', 'NLP-Extracted'),
    ], default='imported')
    created_at = DateTimeField(auto_now_add=True)
    updated_at = DateTimeField(auto_now=True)
```

```python
# vulnerablecode/api/serializers.py
class VulnerabilitySerializer(serializers.ModelSerializer):
    confidence = serializers.FloatField(
        source='extraction_confidence',
        read_only=True
    )
    method = serializers.CharField(
        source='extraction_method',
        read_only=True
    )

    class Meta:
        model = Vulnerability
        fields = ['id', 'vulnerability_id', 'description', 'confidence',
                  'method', 'created_at', 'updated_at']
```

```python
# vulnerablecode/api/views.py
class VulnerabilityViewSet(viewsets.ModelViewSet):
    queryset = Vulnerability.objects.all()
    serializer_class = VulnerabilitySerializer
    filter_backends = [DjangoFilterBackend, OrderingFilter]
    filterset_fields = {
        'extraction_method': ['exact'],
        'extraction_confidence': ['gte', 'lte', 'exact'],
        'vulnerability_id': ['icontains'],
    }
    ordering_fields = ['extraction_confidence', 'created_at']
```

**API Endpoints:**
```
GET /api/v1/vulnerabilities/?extraction_method=nlp
GET /api/v1/vulnerabilities/?confidence_min=0.8
GET /api/v1/vulnerabilities/?extraction_method=nlp&confidence_min=0.9&ordering=-extraction_confidence
```

#### Phase 7: Testing & Documentation (Week 12)

**Test Coverage:**
- Unit tests for each NLP component (>85% coverage)
- Integration tests for importer
- End-to-end test: Text → Database → API response
- Edge case testing (HTML entities, unicode, very long documents)

**Documentation:**
- `/docs/developers/nlp-pipeline.rst` (1500+ words)
- Data model schema documentation
- API usage examples
- Troubleshooting guide
- Architecture decision records (ADR)

---

## Timeline & Milestones

### GSoC Timeline (May 1 - August 31, 2026)

**Week 1 (May 1-5): Community Bonding & Setup**
- Attend intro meetings with mentors
- Finalize architecture with Pombredanne
- Set up project repository, development environment
- **Deliverable:** Architecture design document approved

**Week 2-3 (May 8-22): Data Collection & Preprocessing**
- Identify and download sample data from sources
- Implement text preprocessing pipeline
- Write unit tests for preprocessing
- **Deliverable:** PR: Text preprocessing module

**Week 4-5 (May 29-June 12): Entity Recognition**
- Implement CVE ID extraction (regex)
- Implement package name extraction (spaCy NER)
- Collect and annotate 200 test examples
- **Deliverable:** PR: Entity recognition module + tests

**Week 6 (June 19-23): Relation Extraction**
- Implement linking packages to CVEs
- Implement affected/fixed version extraction
- Dependency parsing experimentation
- **Deliverable:** PR: Relation extraction module

**Week 7-8 (June 26 - July 10): ML Confidence Scoring**
- Annotate 300 additional examples for ML training
- Feature engineering and model training
- Evaluate on test set, iterate
- **Deliverable:** PR: ML confidence scorer module

**Midterm Evaluation (July 15):** Code review checkpoint

**Week 9 (July 17-24): Importer Framework Integration**
- Create `UnstructuredDataImporter` base class
- Implement changelog importer
- **Deliverable:** PR: Unstructured importer framework

**Week 10 (July 31-Aug 7): Data Source Importers**
- Implement mailing list importer
- Implement GitHub advisories importer
- Test on real data, debug
- **Deliverable:** PR: Multi-source importers

**Week 11 (Aug 14-21): API & Data Models**
- Update Vulnerability model with confidence field
- Update serializers and API filters
- Write API documentation
- **Deliverable:** PR: Data model + API updates

**Week 12 (Aug 28-31): Final Documentation & Testing**
- Final test coverage pass (target >85%)
- Write comprehensive docs
- Blog post/summary of work
- **Deliverable:** Documentation PR + blog post

**Final Submission (Aug 31):** All code merged, documented, tested

### Checkpoint Milestones

| Date | Milestone | Deliverable |
|------|-----------|------------|
| May 15 | Architecture approved | Design doc signed off by Pombredanne |
| June 5 | Entity recognition working | >90% accuracy on test set |
| June 26 | Relation extraction working | >85% accuracy on linking |
| July 15 | **Midterm evaluation** | All PRs passing CI/CD |
| July 31 | ML models trained & integrated | >85% precision at 0.7 threshold |
| Aug 15 | API integration complete | Endpoints working, documented |
| Aug 31 | **Final submission** | All tests passing, docs complete |

---

## Expected Outcomes & Deliverables

### Code Deliverables

1. **NLP/ML Pipeline Module** (vulnerablecode/nlp/)
   - 1500+ lines of code
   - Preprocessing, entity recognition, relation extraction
   - Unit tests with >85% coverage

2. **ML Confidence Scoring** (vulnerablecode/ml/)
   - 400+ lines of code
   - Feature engineering, model training/inference
   - Model serialization and versioning

3. **Unstructured Data Importer** (vulnerablecode/importers/unstructured/)
   - 800+ lines of code
   - Base class, 2-3 source implementations
   - Integration tests

4. **Data Model Updates** (vulnerablecode/models.py)
   - New fields: extraction_confidence, extraction_method
   - Backward-compatible migrations
   - Updated serializers

5. **API Endpoints** (vulnerablecode/api/)
   - New filtering options
   - Documentation in API schema
   - Example queries

### Documentation Deliverables

1. **Developer Guide** (docs/developers/nlp-pipeline.rst)
   - 1500+ words
   - Architecture overview, component descriptions
   - Extension points for future work

2. **API Documentation**
   - Updated OpenAPI schema with new fields
   - Usage examples for confidence filtering

3. **Architecture Decision Records**
   - Why spaCy over NLTK?
   - Why logistic regression over neural networks?
   - Trade-offs and future improvements

4. **Blog Post / Summary**
   - "Extracting Vulnerabilities from Unstructured Data using NLP"
   - Technical approach, challenges, lessons learned
   - Target: AboutCode blog or Medium

### Testing & Quality

- **Code Coverage:** >85% across all modules
- **Linting:** 0 issues (black, isort, mypy)
- **Test Types:** Unit, integration, end-to-end
- **Performance:** <500ms per document processing

### Impact Metrics

By project end:
- **2-3 new data sources** automated (vs. manual)
- **10,000+ vulnerabilities** potentially available from unstructured sources
- **50+ new importer patterns** for future community contributions
- **Open-source knowledge** shared through documentation and blog

---

## Technical Rationale

### Why spaCy?

- **Industry standard** for NLP in Python
- **Pre-trained models** for entity recognition
- **Dependency parsing** for relation extraction
- **Production-ready** (used at scale in industry)
- **Active maintenance** (releases ~every 3 months)
- **Alternatives considered:**
  - NLTK: Older, less maintained
  - Transformers (BERT): More powerful but harder to maintain, requires GPU
  - Custom regex: Limited accuracy, hard to scale

### Why Logistic Regression for ML?

- **Interpretability:** Easy to understand which features matter
- **Speed:** Fast training and inference (<1ms per prediction)
- **Simplicity:** Easy to debug and maintain
- **Data efficiency:** Works well with 200-500 labeled examples
- **Baselines:** Can upgrade to Random Forest or neural networks later
- **Alternatives considered:**
  - Neural networks: Overkill for this task, need more data
  - Gradient boosting: Higher complexity, slower training
  - Rule-based: Less flexible, harder to tune

### Why aboutcode.pipeline Framework?

- **Existing pattern:** Reuses Debian, NVD importers
- **Consistency:** Fits project architecture perfectly
- **Extensibility:** Makes future importers easier
- **Maintainability:** One framework to learn, update
- **Community:** Familiar to existing contributors

---

## Challenges & Mitigation

| Challenge | Impact | Mitigation |
|-----------|--------|-----------|
| **Text variability** | Hard to parse changelogs with different formats | Handle top 5 formats (markdown, plain text, reStructuredText, XML, YAML) |
| **Low training data** | ML model accuracy plateaus | Use data augmentation, transfer learning from existing CVE data |
| **False positives** | API returns incorrect extractions | High confidence threshold (0.7-0.8), manual review before release |
| **Package name ambiguity** | "Python" could be the language or package | Cross-reference with known PURL database, context-based disambiguation |
| **Version range complexity** | ">=1.0,<2.0" is hard to parse | Use semantic versioning library (packaging), handle common formats |
| **Multilingual support** | Limited training data for non-English | Phase 2 feature, use spaCy multilingual models if time permits |
| **Dependency parsing** | Slow for long documents | Limit to sentence/paragraph context windows |

**Overall Risk Level:** Low-Medium
- NLP is feasible, proven at scale
- Confidence scoring mitigates quality concerns
- Existing importer framework de-risks integration
- Phase 1-2 fallback: Rule-based extraction (no ML) still valuable

---

## About the Applicant

**Name:** Zakir Jiwani
**GitHub:** github.com/zakirjiwani
**Location:** [Your Location]
**Timezone:** [UTC +/- X]

### Background

- **Education:** [Year, Major] at [University]
- **Python Experience:** [Years]; proficient with Django, REST APIs
- **NLP/ML Experience:** [Your experience with spaCy, scikit-learn, or similar]
- **Open Source:** [Previous contributions, if any]
- **Security Interest:** [Motivation for vulnerability/security work]

### Why VulnerableCode?

I'm passionate about security automation and believe vulnerability data accessibility is critical for the industry. VulnerableCode's open-source approach resonates with me, and the NLP/ML project is an ideal blend of:
- **Technical challenge:** Real-world NLP application
- **Community impact:** Helps security researchers and practitioners globally
- **Learning opportunity:** Deep dive into scalable systems and ML ops
- **Mentorship:** Learning from Pombredanne's expertise in open-source governance and security

I'm committed to:
- Contributing beyond GSoC
- Writing quality, documented, tested code
- Engaging actively with the community
- Sharing knowledge back through blog posts/documentation

---

## Commitment & Availability

- **Full-time availability:** May 1 - August 31, 2026 (40+ hours/week)
- **Communication:** Daily async (Gitter), weekly sync with mentors
- **Timezone:** [Your timezone] (compatible with mentors' schedules)
- **Post-GSoC:** Committed to maintaining code and supporting community

---

## References

- **GitHub Contributions:** github.com/zakirjiwani (see recent commits)
- **Writing Sample:** [Link to any blog post, README, or documentation]
- **Recommender 1:** [Mentor name] (will provide letter)
- **Recommender 2:** [Professor/colleague name] (will provide letter)

---

## Appendices

### A. Data Sources Identified

1. **Python Changelogs** (PyPI JSON API)
   - 400,000+ package versions
   - Semi-structured metadata

2. **npm Package Registry** (npm API)
   - 3M+ packages
   - Changelog in package.json

3. **Full-Disclosure Mailing List** (Archive MBOX)
   - 30+ years of archives
   - Detailed vulnerability discussions

4. **GitHub Security Advisories** (GitHub API)
   - 50,000+ advisories
   - Structured JSON

5. **Debian Changelog XML** (Debian API)
   - 50,000+ packages
   - Semi-structured format

### B. Training Data Annotation Scheme

```
[CVE ID]: CVE-XXXX-XXXXX (or "UNKNOWN")
[PACKAGE]: lodash (or "UNKNOWN")
[AFFECTED VERSION]: ">=1.0,<1.2.3"
[FIX VERSION]: "1.2.3" (or "UNKNOWN")
[CONFIDENCE LABEL]: Correct / Incorrect / Partially Correct
[NOTES]: Any observations or edge cases
```

Example annotated record:
```
Text: "Lodash 1.2.0 has XSS vulnerability CVE-2021-23337. Fixed in 1.2.3"
[CVE ID]: CVE-2021-23337 ✓
[PACKAGE]: lodash ✓
[AFFECTED VERSION]: 1.2.0 (could be >=1.0,<1.2.3)
[FIX VERSION]: 1.2.3 ✓
[CONFIDENCE LABEL]: Mostly Correct (version range uncertain)
```

### C. Performance Targets

| Component | Metric | Target |
|-----------|--------|--------|
| Entity Recognition | Precision | >90% |
| Entity Recognition | Recall | >85% |
| Relation Extraction | Accuracy | >85% |
| ML Confidence Scoring | Precision @ 0.7 threshold | >85% |
| ML Confidence Scoring | Recall @ 0.7 threshold | >75% |
| Processing Speed | Time per document | <500ms |
| Code Quality | Test Coverage | >85% |
| API Response | Latency | <200ms for typical query |

---

## Conclusion

This proposal outlines a comprehensive, achievable plan to extend VulnerableCode's capabilities with NLP/ML-powered vulnerability extraction from unstructured data. The project:

1. **Addresses a real need:** Thousands of unstructured vulnerability sources remain untapped
2. **Leverages existing infrastructure:** Builds on aboutcode.pipeline framework
3. **Delivers measurable impact:** Automating data for 2-3 new sources
4. **Follows best practices:** Testing, documentation, open-source norms
5. **Is achievable in 12 weeks:** Realistic timeline with clear milestones

The mentorship of Pombredanne and Keshav-space, combined with the welcoming AboutCode community, provides an ideal environment for success. I'm excited to contribute and grow as an engineer through this project.

---

**Proposal Version:** 1.0
**Last Updated:** [Date]
**Status:** Draft (ready for mentor feedback)

---

## Appendix D: Next Steps

1. **Submit draft to Pombredanne** for initial feedback (Gitter or email)
2. **Schedule design discussion** to refine approach
3. **Identify training data sources** (annotated examples)
4. **Refine timeline based on** mentor feedback
5. **Finalize and submit** to GSoC portal by application deadline
