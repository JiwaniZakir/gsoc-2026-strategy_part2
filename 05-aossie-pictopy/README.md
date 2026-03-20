# Project #5: AOSSIE PictoPy

**Rank: #5 | Org: AOSSIE | Size: ~175h (TBC) | Confirmed GSoC 2026**

## Organization Overview

**AOSSIE** (Australian Open Source Software Innovation and Education) is a confirmed
GSoC umbrella organization based at the Australian National University. They have
hosted GSoC consistently and manage multiple Python open-source sub-projects.

**PictoPy** is AOSSIE's local-first AI photo organization app — a Python/FastAPI
backend with CLIP and FAISS for semantic image search, face recognition, and object
detection. Everything runs locally, no cloud required.

- **PictoPy GitHub:** https://github.com/AOSSIE-Org/PictoPy
- **AOSSIE GitHub Org:** https://github.com/AOSSIE-Org
- **GSoC:** Confirmed umbrella org
- **GSoC Ideas:** https://gitlab.com/aossie/aossie/-/wikis/GSoC-2026-Ideas

## ⚠️ NOTE: Agora (Scala) is OUT

The old entry for this project targeted Agora — a Scala library. That's the wrong
language for Zakir's profile. This entry is now 100% focused on **PictoPy** (Python AI).

## GSoC Project Idea: PictoPy AI Backend Enhancement

**Goal:** Extend PictoPy's Python AI backend with new face/object detection models,
improved semantic search, and better image organization features.

**Size:** ~175h (confirm with AOSSIE wiki) | **Difficulty:** Medium

### What Gets Built (likely scope)
- New detection models (YOLOv8, newer CLIP variants)
- Multi-face clustering improvement
- Semantic similarity search improvements (FAISS tuning)
- API performance optimizations (async FastAPI endpoints)
- Test coverage improvements

## Tech Stack

| Component | Technology |
|-----------|-----------|
| Core | Python 3.11, FastAPI |
| ML | CLIP (OpenAI), FAISS, face_recognition, OpenCV |
| Object detection | YOLO, torchvision models |
| Performance | PyO3 (Rust for hot paths) |
| Testing | pytest |
| API | FastAPI, uvicorn |
| Build | Rust toolchain (for PyO3 components) |

## Zakir's Edge

| Proof Point | Relevance |
|-------------|-----------|
| Transformers (merged PRs) | CLIP is a transformer model — direct overlap |
| graphrag (3 PRs) | Graph-based retrieval, similar to FAISS semantic search |
| FastAPI (aegis platform) | PictoPy uses FastAPI — production experience |
| ML eval (spectra) | Image embedding evaluation patterns |

## Open Issues (Check PictoPy Repo)

```
https://github.com/AOSSIE-Org/PictoPy/issues?q=is%3Aopen+label%3A%22good+first+issue%22
```

Look for:
- Model upgrade opportunities (newer CLIP/YOLO versions)
- API performance issues
- Test coverage gaps
- Documentation improvements

## Key PictoPy Modules

| Module | Purpose |
|--------|---------|
| `backend/app/` | FastAPI application |
| `backend/app/routers/` | API endpoints (photos, faces, search) |
| `backend/app/ml/` | CLIP, FAISS, face recognition models |
| `backend/app/utils/` | Image processing utilities |
| `tests/` | pytest test suite |

## Communication Channels

| Channel | Link | Purpose |
|---------|------|---------|
| Gitter | https://gitter.im/AOSSIE/ | PRIMARY community channel |
| GitHub | https://github.com/AOSSIE-Org/PictoPy | Issues, PRs |
| GitLab | https://gitlab.com/aossie | GSoC coordination, 2026 ideas wiki |
| Email | gsoc@aossie.org | Formal GSoC inquiry |

## Key Contacts

- **Thushan Ganegedara** — AOSSIE admin, Google Brain researcher
- Check AOSSIE wiki for 2026 PictoPy mentor assignments

## ⚠️ Action Item: Confirm PictoPy GSoC Slot

Check https://gitlab.com/aossie/aossie/-/wikis/GSoC-2026-Ideas to verify PictoPy
specifically has a 175h idea listed. If only Agora (Scala) ideas are listed and
PictoPy is absent, this project drops from the top 5.

---
*Priority: #5 — Python AI backend, good org. Confirm PictoPy GSoC slot first. Same org contribution to multiple projects if slot confirmed.*
