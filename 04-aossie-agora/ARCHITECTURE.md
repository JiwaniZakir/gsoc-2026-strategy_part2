# AOSSIE — Codebase Architecture

---

## Agora (Scala Voting Library)

**Repo:** https://github.com/AOSSIE-Org/Agora
**Language:** Scala 2.13
**Build:** sbt (Scala Build Tool)

### Directory Structure

```
Agora/
├── src/
│   ├── main/scala/
│   │   └── org/aossie/agora/
│   │       ├── algorithm/          # Voting algorithms
│   │       │   ├── SchulzeMethod.scala
│   │       │   ├── InstantRunoff.scala
│   │       │   ├── BordaCount.scala
│   │       │   ├── ApprovalVoting.scala
│   │       │   └── ...
│   │       ├── model/              # Data models
│   │       │   ├── Election.scala
│   │       │   ├── Ballot.scala
│   │       │   └── Winner.scala
│   │       └── util/               # Utilities
│   └── test/scala/
│       └── org/aossie/agora/
│           └── algorithm/          # ScalaTest test specs
├── build.sbt                       # sbt build definition
├── project/
│   ├── build.properties            # sbt version
│   └── plugins.sbt                 # sbt plugins
└── .github/
    └── workflows/
        └── build.yml               # CI: sbt compile + test
```

### Scala Build Commands

```bash
# Compile
sbt compile

# Run tests
sbt test

# Generate test coverage (after adding Scoverage plugin)
sbt coverage test coverageReport

# Generate scaladoc
sbt doc

# Package as JAR
sbt package

# Publish locally
sbt publishLocal
```

### Agora Algorithm Pattern

Each algorithm implements a common interface:
```scala
trait VotingAlgorithm[A <: Election] {
  def winners(election: A, numberOfWinners: Int): Seq[Winner]
}
```

---

## PictoPy (Python ML Photo Manager) — Primary Target

**Repo:** https://github.com/AOSSIE-Org/PictoPy
**Language:** Python 3.10+ (with some Rust via PyO3)

### Directory Structure

```
PictoPy/
├── backend/
│   ├── app/
│   │   ├── main.py                 # FastAPI app entry point
│   │   ├── api/
│   │   │   ├── routes/
│   │   │   │   ├── albums.py       # Album management routes
│   │   │   │   ├── images.py       # Image query routes
│   │   │   │   └── faces.py        # Face recognition routes
│   │   │   └── dependencies.py
│   │   ├── facenet/                # Face recognition module
│   │   │   ├── model.py            # Face detection + embedding
│   │   │   └── clustering.py       # Face clustering
│   │   ├── yolo/                   # Object detection
│   │   │   └── model.py
│   │   ├── database/               # SQLite via SQLAlchemy
│   │   │   ├── models.py
│   │   │   └── crud.py
│   │   └── utils/
│   │       ├── image_processing.py
│   │       └── file_utils.py
│   ├── tests/                      # pytest tests
│   ├── requirements.txt
│   └── pyproject.toml
├── frontend/                       # React/Vue frontend
│   └── src/
├── native/                         # Rust code (PyO3 bindings)
│   └── src/
└── .github/
    └── workflows/
        ├── python.yml
        └── rust.yml
```

### Key Backend Components

| Component | Purpose |
|-----------|---------|
| FastAPI routes | REST API for albums, images, search, faces |
| SQLAlchemy + SQLite | Store metadata, album structure, face groups |
| FaceNet/MTCNN | Face detection and recognition |
| YOLO | Object detection and scene classification |
| scikit-learn | Image clustering (k-means, currently) |
| PIL/OpenCV | Image loading, resizing, preprocessing |

### FastAPI Patterns

```python
# app/api/routes/albums.py
from fastapi import APIRouter, Depends, HTTPException
from app.database.crud import get_album, create_album
from app.database.models import Album

router = APIRouter(prefix="/api/albums", tags=["albums"])

@router.get("/", response_model=list[Album])
async def list_albums(db = Depends(get_db)):
    return get_all_albums(db)

@router.get("/{album_id}", response_model=Album)
async def get_album_by_id(album_id: int, db = Depends(get_db)):
    album = get_album(db, album_id)
    if not album:
        raise HTTPException(status_code=404, detail="Album not found")
    return album
```

### Python Build and Test Commands

```bash
# Backend setup
cd backend
pip install -e ".[dev]"
# or:
pip install -r requirements.txt

# Run FastAPI dev server
uvicorn app.main:app --reload --port 8000

# Run tests
pytest tests/ -v

# Type checking
mypy app/

# Lint
ruff check app/ tests/

# Rust build (if modifying native/)
cd native && maturin develop
```

---

## Understanding AOSSIE's Multi-Repo Structure

| Repo | Language | Status | GSoC Fit |
|------|---------|--------|---------|
| Agora | Scala | Active | Poor for Python devs |
| Agora-Web | Scala/Play + Vue | Active | Partial |
| PictoPy | Python + Rust | Active | **Excellent** |
| CarbonFootprint | Python/JS | Moderate | Good |
| Scavenger | Scala | Less active | Poor |
| SocialCops | ? | Check | Check |

**For GSoC 2026:** Check https://gitlab.com/aossie/aossie/-/wikis/ for the official 2026 project list — not all projects appear on GitHub.
