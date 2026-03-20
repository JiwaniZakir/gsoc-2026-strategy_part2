# AOSSIE PictoPy — Aggressive 5-Day Contribution Plan (Mar 20–24)

**Target: 6–8 PRs in 5 days — ALL in PictoPy (Python ML only)**
**No Agora (Scala). Pure PictoPy focus.**

## Environment Setup (Day 1 Morning)

```bash
git clone https://github.com/AOSSIE-Org/PictoPy
cd PictoPy/backend

# Install dependencies
pip install -e ".[dev]"
# or:
pip install -r requirements.txt

# Start dev server
uvicorn app.main:app --reload --port 8000

# Run tests
pytest tests/ -v --tb=short

# Optional: Rust bindings (only if modifying native/)
# cd native && maturin develop
```

---

## Day 1 — March 20: Setup + First PR

### Find open issues
```bash
gh issue list --repo AOSSIE-Org/PictoPy --state open --limit 20
```

### PR #1: Good-first-issue fix

**High-value targets:**
- Add type hints to untyped functions in core modules
- Fix a failing CI step or missing test dependency
- Add pytest tests for untested API endpoints
- Fix error handling for edge cases (corrupt images, empty albums)

**FastAPI test example (if missing):**
```python
# tests/test_albums_api.py
from fastapi.testclient import TestClient
from app.main import app

client = TestClient(app)

def test_list_albums_returns_200():
    response = client.get("/api/albums/")
    assert response.status_code == 200

def test_get_album_not_found():
    response = client.get("/api/albums/99999")
    assert response.status_code == 404

def test_search_requires_query_param():
    response = client.get("/api/search")
    assert response.status_code == 422  # validation error
```

---

## Day 2 — March 21: PRs #2 and #3 — Deeper Work

### PR #2: Type annotations for core module

```python
# Before (typical PictoPy pattern):
def cluster_images(images, n_clusters):
    pass

# After:
from typing import Union
from pathlib import Path
import numpy as np

def cluster_images(
    images: list[np.ndarray],
    n_clusters: int = 10,
) -> dict[int, list[str]]:
    """
    Cluster images by visual similarity using k-means.

    Args:
        images: List of images as numpy arrays (H, W, C).
        n_clusters: Number of clusters.

    Returns:
        Dict mapping cluster_id to list of image paths.
    """
    ...
```

### PR #3: CLIP embedding improvement (GSoC preview)

Show a draft of the CLIP integration as a proof-of-concept:

```python
# app/ml/clip_embeddings.py (new file — draft PR)

"""
CLIP-based image embedding for semantic similarity search.
Draft for GSoC 2026 PictoPy proposal.
"""

import torch
import clip
import numpy as np
from pathlib import Path
from PIL import Image
from typing import Union


class CLIPEmbedder:
    """Generate CLIP embeddings for images."""

    def __init__(self, model_name: str = "ViT-B/32", device: str = "cpu"):
        self.model, self.preprocess = clip.load(model_name, device=device)
        self.device = device

    @torch.no_grad()
    def embed_image(self, image_path: Union[str, Path]) -> np.ndarray:
        """Return 512-dim CLIP embedding for an image."""
        image = self.preprocess(Image.open(image_path)).unsqueeze(0).to(self.device)
        embedding = self.model.encode_image(image)
        return embedding.cpu().numpy().astype("float32")

    @torch.no_grad()
    def embed_text(self, text: str) -> np.ndarray:
        """Return 512-dim CLIP embedding for a text query."""
        tokens = clip.tokenize([text]).to(self.device)
        embedding = self.model.encode_text(tokens)
        return embedding.cpu().numpy().astype("float32")
```

---

## Day 3 — March 22: FAISS Integration PR

### PR #4: FAISS-based similarity search (draft)

```python
# app/ml/similarity_search.py (new file — draft PR)

import faiss
import numpy as np
from pathlib import Path
from typing import Union
from app.ml.clip_embeddings import CLIPEmbedder


class ImageSimilaritySearch:
    """FAISS-based approximate nearest-neighbor search over image embeddings."""

    def __init__(self, embedding_dim: int = 512):
        self.embedding_dim = embedding_dim
        self.index = faiss.IndexFlatL2(embedding_dim)
        self.image_paths: list[str] = []
        self.embedder = CLIPEmbedder()

    def add_images(self, image_paths: list[Union[str, Path]]) -> None:
        """Add images to the search index."""
        embeddings = np.vstack([
            self.embedder.embed_image(p) for p in image_paths
        ])
        self.index.add(embeddings)
        self.image_paths.extend([str(p) for p in image_paths])

    def search_by_image(self, query_path: Union[str, Path], k: int = 10) -> list[str]:
        """Find k most similar images to query image."""
        query_embedding = self.embedder.embed_image(query_path)
        _, indices = self.index.search(query_embedding, k)
        return [self.image_paths[i] for i in indices[0] if i < len(self.image_paths)]

    def search_by_text(self, query: str, k: int = 10) -> list[str]:
        """Find k images most similar to a text description."""
        query_embedding = self.embedder.embed_text(query)
        _, indices = self.index.search(query_embedding, k)
        return [self.image_paths[i] for i in indices[0] if i < len(self.image_paths)]
```

---

## Day 4 — March 23: Tests + FastAPI Endpoint

### PR #5: Tests for CLIP + FAISS modules

```python
# tests/test_clip_embeddings.py

import pytest
import numpy as np
from unittest.mock import patch, MagicMock
from app.ml.clip_embeddings import CLIPEmbedder


@patch("app.ml.clip_embeddings.clip.load")
def test_clip_embedder_init(mock_load):
    mock_load.return_value = (MagicMock(), MagicMock())
    embedder = CLIPEmbedder()
    assert embedder.device == "cpu"


# tests/test_similarity_search.py

def test_add_and_search_returns_k_results(tmp_path):
    """Similarity search should return k results after adding images."""
    # Use synthetic embeddings to avoid loading real CLIP model
    search = ImageSimilaritySearch(embedding_dim=512)
    # Manually inject fake embeddings
    search.index.add(np.random.rand(20, 512).astype("float32"))
    search.image_paths = [f"img_{i}.jpg" for i in range(20)]

    query = np.random.rand(1, 512).astype("float32")
    _, indices = search.index.search(query, k=5)
    assert len(indices[0]) == 5
```

### PR #6: FastAPI endpoint for text search

```python
# app/api/routes/search.py (new or update existing)

from fastapi import APIRouter, Query
from app.ml.similarity_search import ImageSimilaritySearch

router = APIRouter(prefix="/api/search", tags=["search"])

# In-memory index (would be initialized on startup in real impl)
_search_index: ImageSimilaritySearch | None = None

@router.get("/text")
async def search_by_text(
    query: str = Query(..., description="Text description of images to find"),
    limit: int = Query(default=10, ge=1, le=100),
):
    """Search photos by text description using CLIP embeddings."""
    if _search_index is None:
        return {"results": [], "message": "Index not initialized"}
    results = _search_index.search_by_text(query, k=limit)
    return {"results": results, "query": query, "count": len(results)}
```

---

## Day 5 — March 24: Documentation + Final Polish

### PR #7: Documentation for new ML modules

Add docstrings, update README with new features:
```
docs/
└── clip_semantic_search.md    # How to use CLIP + FAISS
```

### PR #8: Additional tests

Cover edge cases:
- Empty image index
- Query with no matching images
- Invalid image path handling

---

## PR Summary Table

| Day | PR | Type | Repo |
|-----|-----|------|------|
| Mar 20 | #1 | Good-first-issue: tests / type hints | PictoPy |
| Mar 21 | #2 | Type annotations: core module | PictoPy |
| Mar 21 | #3 | Draft: CLIP embedder (GSoC preview) | PictoPy |
| Mar 22 | #4 | Draft: FAISS similarity search | PictoPy |
| Mar 23 | #5 | Tests: CLIP + FAISS modules | PictoPy |
| Mar 23 | #6 | Feature: text search FastAPI endpoint | PictoPy |
| Mar 24 | #7 | Docs: ML module documentation | PictoPy |
| Mar 24 | #8 | Tests: edge cases | PictoPy |
