# GSoC 2026 Proposal: NLP/ML for Vulnerability Detection from Unstructured Data

**Applicant:** Zakir Jiwani
**GitHub:** github.com/JiwaniZakir
**Email:** jiwzakir@gmail.com
**Timezone:** EST (UTC-5)
**Availability:** Full-time, 40 hrs/week
**Organization:** AboutCode / VulnerableCode
**Project Title:** NLP/ML Vulnerability Detection from Unstructured Data
**Duration:** Flexible (175–350 hours)
**Difficulty:** Medium
**Mentors:** [To confirm]

---

## Synopsis

VulnerableCode aggregates vulnerability data from structured feeds, but critical security information lives in unstructured sources: security mailing lists, package changelogs, GitHub issue comments, and CVE description text. Manual processing of these sources is slow, incomplete, and unscalable. This project builds an NLP/ML pipeline that automatically extracts CVE IDs, affected packages, version ranges, severity indicators, and fix information from unstructured text — integrated directly into VulnerableCode's existing importer framework — with confidence scoring that lets operators filter results by quality.

---

## Problem Statement

### The Gap

VulnerableCode currently processes structured data from well-defined feeds (NVD, Debian advisories, vendor advisories in standard formats). But high-value vulnerability information exists in:

| Source | Type | Volume | Current Status |
|--------|------|--------|---------------|
| oss-security mailing list | Unstructured email | ~50/day | Manual only |
| Package changelogs (pip, npm, cargo) | Semi-structured markdown | Thousands/day | Manual only |
| GitHub security advisories (issue comments) | Unstructured text | High volume | Partial manual |
| CVE description text | Semi-structured | All existing CVEs | Parsed by regex only |
| Bug tracker comments | Unstructured | High volume | Not processed |

**The cost of the gap:**
1. Smaller libraries with no structured advisory format are invisible to VulnerableCode
2. Fix information in changelogs arrives 24–72 hours before it appears in structured feeds
3. Security teams miss vulnerabilities that were discussed publicly but never filed to NVD
4. Staff time spent on manual curation could be redirected to quality assurance

### Why NLP/ML Is the Right Tool

The extraction patterns are learnable:
- "Fixed CVE-2026-1234" in changelogs → high-confidence CVE reference
- "versions before 2.3.1 are affected" → version range extraction
- "Critical" + "remote code execution" → severity signal
- "package_name >= 1.0, < 2.0" → PURL/version range structuring

Regex alone fails because natural language is too variable. ML models that understand context generalize across formats.

---

## Technical Approach

### Pipeline Architecture

```
Unstructured Text Source
        ↓
TextFetcher (source-specific)
  ├── MailingListFetcher (IMAP/archive)
  ├── ChangelogFetcher (PyPI/npm/crates.io release notes)
  ├── GitHubIssueFetcher (GraphQL API)
  └── CVEDescriptionFetcher (NVD API)
        ↓
TextPreprocessor
  ├── HTML/Markdown stripping
  ├── Sentence boundary detection
  └── Language detection (English filter)
        ↓
NLPExtractor (Core Component)
  ├── CVE ID extraction (regex + NER validation)
  ├── Package name extraction (NER fine-tuned on security text)
  ├── Version range extraction (pattern + ML hybrid)
  ├── Severity classification (text classifier)
  └── Fix URL extraction (regex + heuristics)
        ↓
ConfidenceScorer
  ├── Score 0.0–1.0 per extracted field
  ├── Aggregate record confidence
  └── Threshold filtering (configurable, default 0.7)
        ↓
VulnerableCodeImporter (existing interface)
  ├── Deduplication (merge with existing CVE records)
  ├── Confidence field on new records
  └── Django ORM + REST API
```

### Core Component: NLPExtractor

**CVE ID Extraction:**
```python
import re
import spacy

class CVEExtractor:
    CVE_PATTERN = re.compile(r'CVE-\d{4}-\d{4,7}', re.IGNORECASE)

    def extract(self, text: str) -> list[dict]:
        """Extract CVE IDs with context and confidence."""
        results = []
        for match in self.CVE_PATTERN.finditer(text):
            cve_id = match.group(0).upper()
            context = text[max(0, match.start()-50):match.end()+50]
            confidence = self._compute_confidence(cve_id, context)
            results.append({
                'cve_id': cve_id,
                'context': context,
                'confidence': confidence
            })
        return results

    def _compute_confidence(self, cve_id: str, context: str) -> float:
        """
        Higher confidence if:
        - CVE appears in a "fixing" context
        - CVE appears near a package name we recognize
        - Context mentions severity or affected versions
        """
        score = 0.5  # Base confidence for a valid CVE pattern
        if any(kw in context.lower() for kw in ['fix', 'patch', 'resolve', 'address']):
            score += 0.2
        if any(kw in context.lower() for kw in ['critical', 'high', 'rce', 'cve']):
            score += 0.1
        if re.search(r'\d+\.\d+\.\d+', context):
            score += 0.2  # Version number present
        return min(score, 1.0)
```

**Package Name Extraction (NER):**
```python
from transformers import pipeline

class PackageNERExtractor:
    """Fine-tuned NER model for software package names."""

    def __init__(self, model_path: str = 'model/package-ner'):
        self.ner = pipeline('ner', model=model_path, aggregation_strategy='simple')

    def extract(self, text: str) -> list[dict]:
        entities = self.ner(text)
        packages = [e for e in entities if e['entity_group'] == 'PACKAGE']
        return [
            {
                'name': p['word'],
                'confidence': float(p['score']),
                'start': p['start'],
                'end': p['end']
            }
            for p in packages
        ]
```

**Version Range Extraction:**
```python
class VersionRangeExtractor:
    """
    Extract version constraints from natural language.
    "versions before 2.3.1" → {"type": "lt", "version": "2.3.1"}
    "affects 1.0 through 2.5" → {"type": "range", "from": "1.0", "to": "2.5"}
    """

    PATTERNS = [
        (r'(?:before|prior to|up to)\s+(\d+[\d.]+)', 'lt'),
        (r'(?:through|to)\s+(\d+[\d.]+)', 'lte'),
        (r'(?:fixed in|from)\s+(\d+[\d.]+)', 'gte'),
        (r'>?=?\s*(\d+[\d.]+)\s*,\s*<?=?\s*(\d+[\d.]+)', 'range'),
    ]

    def extract(self, text: str) -> list[dict]:
        results = []
        for pattern, constraint_type in self.PATTERNS:
            for match in re.finditer(pattern, text, re.IGNORECASE):
                results.append({
                    'type': constraint_type,
                    'version': match.group(1),
                    'raw': match.group(0)
                })
        return results
```

### Confidence Scoring

Every extracted record gets a confidence score (0.0–1.0):

```python
@dataclass
class ExtractionResult:
    text_source: str
    raw_text: str
    cve_ids: list[dict]          # [{cve_id, confidence}]
    packages: list[dict]          # [{name, confidence}]
    version_ranges: list[dict]    # [{type, version, confidence}]
    severity: str | None          # "critical", "high", "medium", "low"
    fix_urls: list[str]
    aggregate_confidence: float   # Weighted average

    def is_actionable(self, threshold: float = 0.7) -> bool:
        return self.aggregate_confidence >= threshold
```

**Operator Interface:**
```python
# In Django admin or settings
NLP_CONFIDENCE_THRESHOLD = 0.7   # Only import records above this confidence
NLP_REVIEW_QUEUE_THRESHOLD = 0.4  # Records between 0.4–0.7 go to review queue
```

### Integration with Existing Importer Framework

```python
class NLPImporter(BaseImporter):
    """
    Importer that processes text sources through NLP pipeline.
    Follows the same interface as existing importers.
    """
    spdx_license_expression = 'Apache-2.0'
    importer_name = 'nlp_importer'

    def fetch(self) -> Iterator[str]:
        """Yield raw text from configured sources."""
        for source in self.configured_sources:
            yield from source.fetch()

    def to_advisory(self, text: str) -> Advisory | None:
        result = self.extractor.extract(text)
        if not result.is_actionable(threshold=settings.NLP_CONFIDENCE_THRESHOLD):
            return None
        return Advisory(
            aliases=result.cve_ids,
            affected_packages=result.packages,
            summary=self._summarize(text),
            confidence_score=result.aggregate_confidence,
        )
```

### New Data Sources (15+ target)

| Source | Type | Extraction Target |
|--------|------|------------------|
| oss-security mailing list | Email text | CVE IDs, packages, severity |
| PyPI release notes | Markdown | Fixed CVEs, version ranges |
| npm security advisories | Markdown | Affected packages, fix versions |
| crates.io changelogs | Markdown | Fixed CVEs in Rust crates |
| GitHub Security Advisories | Markdown | Full advisory extraction |
| Debian LTS announcements | Email | CVE IDs, affected packages |
| OpenBSD errata | HTML | CVE IDs, patches |
| Alpine Linux advisories | HTML | CVE IDs, affected versions |
| Arch Linux CVE tracker | Web | CVE status, fixed versions |
| FreeBSD security advisories | HTML | CVE IDs, versions |

---

## Week-by-Week Timeline

| Week | Focus | Deliverables |
|------|-------|-------------|
| 1 | Architecture + design alignment | Pipeline design reviewed by mentors |
| 2 | CVE ID extractor + confidence scoring | `CVEExtractor` with tests |
| 3 | Package NER model + version range extractor | NER working, `VersionRangeExtractor` |
| 4 | TextFetchers: mailing list + PyPI | 2 source fetchers with tests |
| 5 | TextFetchers: npm + GitHub | 2 more sources |
| 6 | *MIDTERM* NLP importer integration | `NLPImporter` working end-to-end, 5+ sources |
| 7 | Confidence scoring calibration | Precision/recall metrics on test set |
| 8 | 5+ more sources | 10 total sources integrated |
| 9 | Review queue + operator UI | Django admin review workflow |
| 10 | 5 more sources | 15 total sources |
| 11 | Performance optimization | Batch processing, async fetching |
| 12 | Documentation + final polish | User guide, model card, all tests |

**Midterm (Week 6):** NLPImporter working with 5+ sources, extracting CVE IDs and packages with confidence scoring.

**Final (Week 12):** 15+ sources, all four extraction types (CVE, package, version, severity), review queue, documentation.

---

## About the Applicant

**Zakir Jiwani** | GitHub: [JiwaniZakir](https://github.com/JiwaniZakir) | EST

My background for this project is unusually direct:

**NLP/ML Pipeline Engineering:**
- Built **spectra**, a RAG evaluation toolkit using LangChain, LangGraph, and GraphRAG — the core problem (extract structured data from unstructured text, score quality) is exactly the NLP vulnerability detection problem
- Deep experience with HuggingFace transformers, spaCy, and DSPy for structured extraction tasks
- Ray for distributed ML pipeline processing (relevant for scaling the text fetching)

**The Lattice Connection:**
**lattice** is my multi-agent framework that uses safety guarantees — I've built agents that extract structured information from documents and reason about confidence. The architecture of the NLP pipeline I'm proposing maps directly to what I've built in lattice.

**Information Extraction (Core Skill):**
- My work on **aegis** (personal intelligence platform) involves extracting structured entities from unstructured intelligence reports — very similar to CVE extraction from mailing lists
- I've implemented custom NER models and evaluated them against precision/recall benchmarks

**Python/Django:**
- **evictionchatbot**: Django backend with REST API
- **aegis**: FastAPI + Celery (very similar architecture to VulnerableCode's Django + task queue)
- Familiar with the importer pattern; I'll extend it, not replace it

**Why This Project Specifically:**
Vulnerability data quality is a genuine security problem. Organizations relying on VulnerableCode to know what's in their dependencies need complete data. The NLP extraction project directly improves security posture at scale. As someone who builds with LLMs and ML pipelines, making those pipelines *auditable* and *confidence-scored* is exactly the right engineering approach — not a black box.

---

## Questions for Mentors

1. **Model approach:** Fine-tune a small transformer for NER, or use spaCy's existing models + rule-based augmentation? What's the compute budget for the pipeline?
2. **Confidence thresholds:** Is 0.7 a reasonable default, or do you want lower recall but higher precision?
3. **Review queue:** Should low-confidence extractions go into a Django admin review queue, or just be discarded? (I'd prefer review queue for operator visibility)
4. **Source priorities:** Of the 15 target sources, which 3–5 are highest priority for mentors?
5. **Model storage:** Fine-tuned models — shipped in the repo, or downloaded at runtime via Hugging Face Hub?

---

**Status:** Near-final draft — ready for mentor review
**Last Updated:** March 2026
**Submitted by:** Zakir Jiwani (JiwaniZakir)
