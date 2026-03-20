# GSoC 2026 Proposal — AOSSIE / PictoPy

**Applicant:** Zakir Jiwani | GitHub: JiwaniZakir | jiwzakir@gmail.com
**Organization:** AOSSIE (Australian Open Source Software Innovation and Education)
**Project Title:** PictoPy: Advanced AI-Powered Photo Organization and Discovery Engine
**Duration:** 350 hours (large project)
**Mentors:** TBD — contact gsoc@aossie.org

---

## Synopsis

PictoPy is an AI-powered local photo management system that uses computer vision to automatically organize photos. This project significantly enhances PictoPy's ML capabilities: replacing the current clustering approach with a modern embedding-based similarity search, adding semantic photo search via CLIP, improving face recognition accuracy, adding robust test coverage, and building a comprehensive API documentation layer.

---

## Background and Motivation

PictoPy represents a compelling intersection of computer vision, local-first software, and user privacy. Unlike cloud-based photo services, it runs entirely locally — important for users who don't want their personal photos analyzed by third-party servers.

The current implementation has functional core features but gaps in:
1. **Clustering quality** — basic k-means on raw features misses semantic similarity
2. **Test coverage** — core ML modules are undertested, making refactoring risky
3. **API documentation** — the FastAPI endpoints lack OpenAPI schema detail
4. **Performance** — no caching layer for repeated image processing

---

## Deliverables

### Deliverable 1: Embedding-Based Similarity Search (Weeks 1–5)

Replace k-means clustering with a modern approach using CLIP embeddings and FAISS for approximate nearest-neighbor search:

```python
# Before: k-means on raw pixel features
from sklearn.cluster import KMeans
features = extract_raw_features(images)
kmeans = KMeans(n_clusters=10).fit(features)

# After: CLIP embeddings + FAISS ANN
import torch
import clip
import faiss

model, preprocess = clip.load("ViT-B/32", device="cpu")

def get_clip_embedding(image_path: str) -> np.ndarray:
    image = preprocess(Image.open(image_path)).unsqueeze(0)
    with torch.no_grad():
        embedding = model.encode_image(image)
    return embedding.numpy().astype("float32")

def build_faiss_index(embeddings: np.ndarray) -> faiss.Index:
    index = faiss.IndexFlatL2(embeddings.shape[1])
    index.add(embeddings)
    return index

def find_similar_images(query_path: str, index: faiss.Index, k: int = 10):
    query_embedding = get_clip_embedding(query_path)
    distances, indices = index.search(query_embedding, k)
    return indices[0].tolist()
```

**Benefits:**
- Semantic similarity (cats near cats, landscapes near landscapes) vs. pixel-level k-means
- Sub-millisecond query time for 100k+ image libraries via FAISS

### Deliverable 2: Semantic Text-to-Image Search (Weeks 6–8)

CLIP's multimodal embeddings allow searching photos by text description:

```python
def search_by_text(query: str, index: faiss.Index, image_paths: list[str]) -> list[str]:
    """Find images matching a text description using CLIP."""
    text_tokens = clip.tokenize([query])
    with torch.no_grad():
        text_embedding = model.encode_text(text_tokens)
    text_embedding = text_embedding.numpy().astype("float32")
    _, indices = index.search(text_embedding, k=20)
    return [image_paths[i] for i in indices[0]]

# FastAPI endpoint:
@app.get("/api/search")
def search_photos(query: str = Query(..., description="Text description to search")):
    results = search_by_text(query, faiss_index, image_paths)
    return {"results": results, "query": query}
```

### Deliverable 3: Face Recognition Improvements (Weeks 9–11)

- Replace or augment current face recognition with InsightFace for better accuracy
- Add face clustering to group photos by person
- Add confidence scores to face detection results
- Handle edge cases: partial faces, low-light, multiple face scales

### Deliverable 4: Comprehensive Test Suite (Weeks 12–13)

```python
# tests/test_similarity.py
import pytest
import numpy as np
from pictopy.similarity import get_clip_embedding, find_similar_images, build_faiss_index

@pytest.fixture
def sample_embeddings():
    return np.random.rand(100, 512).astype("float32")

def test_faiss_index_builds(sample_embeddings):
    index = build_faiss_index(sample_embeddings)
    assert index.ntotal == 100

def test_similar_images_returns_k_results(sample_embeddings, tmp_path):
    index = build_faiss_index(sample_embeddings)
    query = sample_embeddings[0:1]
    results = index.search(query, k=5)
    assert len(results[1][0]) == 5

# tests/test_api.py
from fastapi.testclient import TestClient
from pictopy.main import app

client = TestClient(app)

def test_search_endpoint():
    response = client.get("/api/search?query=sunset+beach")
    assert response.status_code == 200
    assert "results" in response.json()

def test_albums_endpoint():
    response = client.get("/api/albums")
    assert response.status_code == 200
```

### Deliverable 5: API Documentation and Performance (Week 14)

- Complete OpenAPI spec for all FastAPI endpoints
- Add response caching for embedding computation (Redis or disk-based)
- Add embedding persistence so the index isn't rebuilt on every startup
- Write contributor documentation for adding new ML models

---

## Timeline

| Week | Milestone |
|------|-----------|
| 1–2 | Community bonding: deep codebase study, performance profiling, design review with mentors |
| 3–4 | Implement CLIP embedding extraction, replace k-means clustering |
| 5–6 | Build FAISS index, integrate with existing photo album structure |
| 7–8 | Semantic text search endpoint + UI integration |
| 9–10 | Face recognition improvements (InsightFace integration) |
| 11–12 | Face clustering, confidence scores, edge case handling |
| 13 | Comprehensive test suite (target: 70%+ coverage) |
| 14 | API docs, embedding persistence, final PRs |

---

## About Me

I'm a Python/ML developer with hands-on experience in computer vision, embedding-based search, and large Python systems.

**Relevant experience:**
- Python ML stack: transformers, LangChain, LangGraph, DSPy — I work in this space daily
- CLIP and embedding-based search: familiar with the API and latency tradeoffs
- FAISS: used for vector similarity search in personal projects
- FastAPI: built API layers in personal projects (aegis intelligence platform)
- pytest: extensive test writing across multiple repos (338 tests in aegis, 209 in sentinel)
- Merged PRs in huggingface/transformers and prowler-cloud/prowler — large codebase navigation

**Why PictoPy:**
Local-first AI tools matter. Cloud photo services are convenient but require trusting your personal photos to third parties. PictoPy represents the right way to do this — powerful ML, running entirely locally, user data never leaves the machine.

---

## References

- [CLIP (Radford et al., 2021)](https://arxiv.org/abs/2103.00020)
- [FAISS documentation](https://faiss.ai/)
- [InsightFace](https://github.com/deepinsight/insightface)
- [PictoPy repo](https://github.com/AOSSIE-Org/PictoPy)
