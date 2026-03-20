# AOSSIE Agora — Aggressive 5-Day Contribution Plan (Mar 19–23)

**Target: 6–8 PRs in 5 days**
**Strategy: Split across Agora (Scala—easy issues) + PictoPy (Python ML—deeper work)**

## ⚠️ Key Decision: Agora vs. PictoPy

Agora's open issues are either very stale (issue #20 has open PRs from years ago) or require Scala expertise. **Recommendation:**
- Submit **1–2 easy Agora PRs** to establish presence in the org
- Submit **3–5 PictoPy PRs** as your main technical contribution
- Apply to GSoC under AOSSIE umbrella with PictoPy as your project focus

---

## Day 1 — March 19: Agora Setup + First PR

### Agora Environment Setup
```bash
git clone https://github.com/AOSSIE-Org/Agora
cd Agora

# Requires Scala + sbt
brew install scala sbt  # macOS
sbt compile
sbt test
```

### PR #1 (Agora): Issue #15 — Add Scoverage Coverage Report
**Target:** Add Scoverage sbt plugin for code coverage reporting

**What to do:**
1. Add to `build.sbt`:
```scala
// Add to plugins.sbt
addSbtPlugin("org.scoverage" % "sbt-scoverage" % "2.0.9")

// Add to build.sbt
coverageEnabled := true,
coverageMinimumStmtTotal := 70,
```
2. Add coverage step to `.github/workflows/`:
```yaml
- name: Generate coverage report
  run: sbt coverage test coverageReport
- name: Upload coverage to Codecov
  uses: codecov/codecov-action@v3
```
3. Add badge to README.md

This is a well-understood pattern — no Scala algorithm knowledge required.

### PictoPy Setup
```bash
git clone https://github.com/AOSSIE-Org/PictoPy
cd PictoPy
pip install -e ".[dev]"
pytest tests/ -x -q  # confirm tests pass
```

---

## Day 2 — March 20: PictoPy First PR

### PR #2 (PictoPy): Find and fix a Python/ML issue

**How to find good PictoPy issues:**
```bash
gh api "repos/AOSSIE-Org/PictoPy/issues?state=open&per_page=10" | jq '[.[] | {number, title, html_url}]'
```

**Likely contribution areas in PictoPy:**
1. Add missing type annotations to Python functions
2. Add pytest test cases for untested modules
3. Fix any failing CI or missing dependency
4. Add docstrings to key API functions
5. Fix image processing edge cases

**Example PR: Add type hints to core module**
```python
# Before:
def cluster_images(images, n_clusters):
    ...

# After:
from typing import List
import numpy as np

def cluster_images(
    images: List[np.ndarray],
    n_clusters: int = 10,
) -> dict[int, List[str]]:
    """
    Cluster images by visual similarity using k-means.

    :param images: List of images as numpy arrays.
    :param n_clusters: Number of clusters.
    :return: Dict mapping cluster_id to list of image paths.
    """
    ...
```

---

## Day 3 — March 21: Deeper PictoPy Contribution

### PR #3 (PictoPy): Feature or bug fix

After reading the codebase, identify the highest-value contribution:
- Add a new image processing feature
- Fix a performance bottleneck
- Add integration tests for the FastAPI endpoints
- Improve error handling for corrupt/missing images

**FastAPI test example (if missing):**
```python
# tests/test_api.py
from fastapi.testclient import TestClient
from pictopy.main import app

client = TestClient(app)

def test_get_albums():
    response = client.get("/api/albums")
    assert response.status_code == 200
    assert "albums" in response.json()

def test_get_album_images_not_found():
    response = client.get("/api/albums/nonexistent")
    assert response.status_code == 404
```

### Also Day 3: Post Proposal Outline in Gitter
- Join Gitter: https://gitter.im/AOSSIE/
- Post intro mentioning your contributions to Agora + PictoPy

---

## Day 4 — March 22: More PictoPy + Agora CI Fix

### PR #4 (PictoPy): Second substantial Python contribution

### PR #5 (Agora): Issue #16 — Publish to Sonatype (if achievable) or CI improvement
If issue #16 is too complex, instead:
- Fix any failing CI in Agora
- Add or improve GitHub Actions workflow

---

## Day 5 — March 23: Polish + Final PR

### PR #6 (PictoPy or Agora): Final contribution
- Documentation improvement
- Additional tests
- Any open bug found during development

---

## PR Summary Table

| Day | PR | Repo | Type |
|-----|-----|------|------|
| Mar 19 | #1 | Agora | Scoverage CI coverage |
| Mar 20 | #2 | PictoPy | Type hints / tests |
| Mar 21 | #3 | PictoPy | Feature / bug fix |
| Mar 22 | #4 | PictoPy | Second substantial PR |
| Mar 22 | #5 | Agora | CI improvement |
| Mar 23 | #6 | PictoPy | Final PR |

---

## Important Notes

- **Agora PRs are your foot in the door** — they show presence in the AOSSIE org
- **PictoPy PRs are your technical proof** — they show you can do Python ML work
- GSoC application will be to AOSSIE umbrella — mention both repos
- Check the AOSSIE GitLab wiki for 2026 ideas: https://gitlab.com/aossie/aossie/-/wikis/
- Some years AOSSIE has had Python-specific projects not obvious from GitHub — check the wiki!
