# GreedyBear Architecture Deep Dive

## System Overview

GreedyBear is a **honeypot intelligence aggregation platform** built on Django and React. It sits at the intersection of honeypot data collection (T-Pot) and intelligence distribution (REST API + frontend dashboard).

### High-Level Data Flow

```
T-Pot Honeypot Infrastructure
           ↓
    Elasticsearch Cluster
           ↓
GreedyBear Django Backend
  (Extract, Transform, Load)
           ↓
  PostgreSQL + Elasticsearch
           ↓
    REST API (DRF)
    ↙        ↖
React UI   External Apps
```

---

## Backend Architecture

### Django Project Structure

**Core Application:** `/greedybear/`
- Main Django app housing all business logic
- Organized into functional modules

### Key Directories

#### 1. `/api` — REST API Implementation (PRIMARY FOR GSoC)
This directory contains the complete REST API surface that external applications interact with.

**Files:**
- **`views.py`** - DRF ViewSets and API views
  - Implement CRUD operations for API resources
  - Use DRF's generic views (ListAPIView, CreateAPIView, etc.)
  - Handle serialization/deserialization
  - For GSoC: Create new Event Collector API viewset here

- **`serializers.py`** - Data validation and transformation
  - DRF Serializers for all API resources
  - Field validation (type, range, required, unique)
  - Custom validation methods
  - Nested serializers for related data
  - For GSoC: Design EventSchema serializer for injected data

- **`urls.py`** - URL routing
  - Register viewsets with DefaultRouter
  - API endpoint paths
  - For GSoC: Register new `/api/events/` or `/api/inject/` endpoint

**Example ViewSet Pattern:**
```python
class EventViewSet(viewsets.ModelViewSet):
    queryset = Event.objects.all()
    serializer_class = EventSerializer
    permission_classes = [IsAuthenticated]
    filter_backends = [DjangoFilterBackend]

    def perform_create(self, serializer):
        serializer.save(created_by=self.request.user)
```

#### 2. `/authentication` — Security & Access Control
Handles user authentication, token management, and permissions.

**Key Components:**
- **Models:** Custom user models, API tokens, API keys
- **Serializers:** User registration, login, token refresh
- **Views:** Authentication endpoints
- **Permissions:** Custom permission classes (IsOwner, IsAdmin, etc.)

**For GSoC Event Collector API:**
- Token-based auth (DRF TokenAuthentication or custom JWT)
- Rate limiting middleware
- API key management for external services
- Implement permissions: `IsEventCollector` (custom permission)

#### 3. `/configuration` — Settings & Feature Flags
Application-wide configuration management.

**Contains:**
- Feature flags (enable/disable features)
- API rate limits
- Elasticsearch connection settings
- Task queue configuration
- Settings per environment (dev, staging, prod)

#### 4. `/cronjobs` — Scheduled Tasks
Implements recurring background jobs using Django Q2.

**Typical Tasks:**
- Data aggregation and enrichment
- Index rotation (Elasticsearch)
- Report generation
- Cleanup operations
- Health checks

**For GSoC:**
- May need cronjob for event processing pipeline
- Monitoring collected events
- Generating summaries of injected data

#### 5. `/management` — Django Management Commands
Custom admin commands for operational tasks.

**Examples:**
- Data import/export
- Database maintenance
- Cache warming
- User/token administration

**For GSoC:**
- May create command for testing Event Collector API
- Data validation utilities

#### 6. `/tests` — Comprehensive Test Suite
- Unit tests for models and utilities
- Integration tests for API endpoints
- Fixture files for test data
- Mocking external services

**Testing Tools:**
- pytest + pytest-django
- Django test client
- Factory Boy (test data generation)
- Mocking/patching

**For GSoC:**
- Write tests for Event Collector API endpoint
- Test authentication and rate limiting
- Test data validation and error handling

#### 7. `/migrations` — Database Schema
- Django migrations tracking schema changes
- Applied sequentially on startup
- Version control for database structure

**For GSoC:**
- May need migration for event_collector model if it doesn't exist
- Add fields to existing models if needed

---

## Data Models (Key Entities)

### Event Model (Core for GSoC)
Represents a single event from any source (honeypot, injected, etc.)

**Typical Fields:**
```
Event
  - id (UUID primary key)
  - timestamp (DateTime)
  - source (ForeignKey to Source/Honeypot)
  - event_type (CharField: "connection", "attack", "reconnaissance")
  - protocol (CharField: "ssh", "http", "ftp", etc.)
  - source_ip (GenericIPAddressField)
  - destination_ip (GenericIPAddressField)
  - source_port (IntegerField)
  - destination_port (IntegerField)
  - payload (TextField, JSONField for structured data)
  - severity (CharField: "low", "medium", "high", "critical")
  - tags (ManyToManyField or JSONField)
  - extracted_artifacts (JSONField for IOCs)
  - created_at (DateTimeField auto_now_add)
  - updated_at (DateTimeField auto_now)
```

### User Model
Custom user with roles and API access management

**Fields:**
```
User
  - id (UUID)
  - username (CharField unique)
  - email (EmailField)
  - is_staff (Boolean)
  - is_active (Boolean)
  - created_at (DateTime)
  - api_tokens (reverse ForeignKey)
```

### APIToken Model (For Event Collector Authentication)
```
APIToken
  - id (UUID)
  - key (CharField unique, auto-generated)
  - user (ForeignKey to User)
  - name (CharField, for identification)
  - scopes (JSONField: ["events:write", "events:read"])
  - rate_limit (IntegerField: requests per minute)
  - last_used (DateTime)
  - created_at (DateTime)
  - expires_at (DateTime, nullable for indefinite)
  - is_active (Boolean)
```

### EventSource Model
Metadata about where events originate

**Fields:**
```
EventSource
  - id (UUID)
  - name (CharField: "T-Pot", "External Service X")
  - source_type (CharField: "honeypot", "api", "feed")
  - description (TextField)
  - is_active (Boolean)
  - metadata (JSONField: config, API endpoints, credentials)
```

---

## Frontend Architecture

### React + Vite Stack

**Build Configuration:**
- Vite 7.3.1+ (lightning-fast dev server, optimized build)
- React 18+ (latest hooks, concurrent features)
- Certego-UI library (custom Honeynet component library)

**Directory Structure:**
```
/frontend/
  /src/
    /components/       # Reusable React components
    /pages/           # Page-level components
    /hooks/           # Custom React hooks
    /services/        # API client, Elasticsearch queries
    /context/         # React Context for state
    /utils/           # Helper functions
    /styles/          # Global styles, theme
    App.jsx
    main.jsx
  /public/           # Static assets (images, fonts)
  package.json
  vite.config.js
```

**Key Frontend Features:**
- Dashboard with event statistics
- Real-time search via Elasticsearch
- Event filtering and aggregation
- Alert and notification system
- User settings and API token management

**For GSoC:**
- May add Event Collector monitoring dashboard
- API token management UI
- Event injection status/logs viewer

---

## Database Architecture

### Primary Database: PostgreSQL

**Purpose:** Transactional data, user management, configuration

**Key Tables:**
- `greedybear_user` - User accounts
- `greedybear_event` - Core event records
- `greedybear_eventsource` - Event source metadata
- `authentication_apitoken` - API tokens for external access
- `configuration_settings` - Feature flags and config
- `cronjobs_task` - Django Q2 scheduled tasks

**Characteristics:**
- ACID compliance
- Strong schema validation
- Transactional integrity
- User/auth data security

### Secondary Search Engine: Elasticsearch

**Purpose:** Full-text search, aggregations, analytics

**Key Indexes:**
- `events-*` - Time-series indices for events
- `artifacts-*` - Extracted indicators of compromise
- `stats-*` - Aggregated statistics

**Advantages over PostgreSQL:**
- Sub-second full-text search
- Complex aggregations (date histograms, top IPs, etc.)
- Time-series optimization
- Horizontal scalability

**Data Flow to Elasticsearch:**
1. Event created in PostgreSQL
2. Celery/Django Q2 job picks up event
3. Transform to ES-friendly format
4. Index into Elasticsearch
5. Frontend queries ES for search/analytics

---

## Task Queue Architecture: Django Q2

**Recently Migrated From:** Celery (Redis-based)
**Current Solution:** Django Q2 (database-backed, simpler)

### Why Django Q2?
- No external broker dependency (uses PostgreSQL)
- Simpler configuration than Celery
- Built-in admin interface
- Works well at GreedyBear's scale

### Task Flow

```
Event Created
     ↓
Django Q2 Task Enqueued
     ↓
Worker Process Dequeues Task
     ↓
Task Executes:
  - Extract indicators (IPs, domains, hashes)
  - Enrich with threat intel
  - Index to Elasticsearch
  - Update statistics
     ↓
Task Marked Complete
```

### Common Tasks

1. **Event Processing**
   - Extract IOCs from raw payload
   - Normalize IP formats, domain names
   - Geolocate IPs

2. **Enrichment**
   - Query threat feeds
   - Check IP reputation
   - Domain WHOIS lookup

3. **Index Maintenance**
   - Rotate indices
   - Delete old data per retention policy

4. **Reporting**
   - Generate daily/weekly summaries
   - Email alerts for critical events

### For GSoC Event Collector API

Create queue tasks for:
- Validating injected events
- Processing them through enrichment pipeline
- Indexing to Elasticsearch
- Generating injection status reports

---

## Authentication & Authorization

### User Authentication
- **Django Auth:** Standard Django authentication for web UI
- **Token Auth:** DRF TokenAuthentication for API clients

### API Access Control

**Three-Tier Authorization:**

1. **Resource-Level Permissions**
   ```python
   permission_classes = [IsAuthenticated, IsEventCollector]
   ```

2. **Object-Level Permissions**
   ```python
   def has_object_permission(self, request, view, obj):
       return obj.created_by == request.user
   ```

3. **Rate Limiting**
   ```python
   throttle_classes = [UserRateThrottle]
   THROTTLE_RATES = {'user': '1000/hour'}
   ```

### For GSoC Event Collector API

Implement custom permission class:
```python
class IsEventCollector(BasePermission):
    """Only users/services with event:write scope can inject"""

    def has_permission(self, request, view):
        if request.method == 'POST':
            token = get_token_from_request(request)
            return 'events:write' in token.scopes
        return True
```

---

## API Design Patterns

### DRF ViewSet Pattern

**Standard CRUD ViewSet:**
```python
class EventViewSet(viewsets.ModelViewSet):
    queryset = Event.objects.all()
    serializer_class = EventSerializer
    permission_classes = [IsAuthenticated]
    filter_backends = [DjangoFilterBackend, SearchFilter]
    filterset_fields = ['severity', 'event_type', 'source_ip']
    search_fields = ['payload', 'source_ip']
```

**Router Registration:**
```python
router = DefaultRouter()
router.register(r'events', EventViewSet)
urlpatterns = router.urls
```

**Results in Endpoints:**
- `GET /api/events/` - List all events
- `POST /api/events/` - Create event
- `GET /api/events/{id}/` - Retrieve single event
- `PUT /api/events/{id}/` - Update event
- `DELETE /api/events/{id}/` - Delete event

### For GSoC Event Collector API

Design similar pattern for event injection:
```python
class EventCollectorViewSet(viewsets.ModelViewSet):
    queryset = CollectedEvent.objects.all()
    serializer_class = EventCollectorSerializer
    permission_classes = [IsAuthenticated, IsEventCollector]

    def perform_create(self, serializer):
        # Validate, process, queue for enrichment
        serializer.save(injected_by=self.request.user)
        # Trigger processing task
        queue_event_processing(serializer.instance)
```

---

## Code Quality & Development Tools

### Ruff: All-in-One Python Linter/Formatter

**Replaces:** black (formatter) + isort (import sorter) + flake8 (linter)

**Usage:**
```bash
# Check code
ruff check . --show-fixes

# Auto-fix fixable issues
ruff check . --fix

# Format code
ruff format .

# Check specific rule set
ruff check . --select E,W  # PEP 8 errors/warnings only
```

**Configuration:** `pyproject.toml` or `ruff.toml`

### Pre-Commit Hooks

**Purpose:** Prevent committing code that violates standards

**Installation:**
```bash
pip install pre-commit
pre-commit install -c .github/.pre-commit-config.yaml
```

**Hooks Run Automatically:**
1. Ruff check
2. Ruff format
3. Import sort validation
4. Whitespace cleanup
5. YAML validation

### Testing Framework

**Tools:**
- pytest (modern test runner)
- pytest-django (Django integration)
- Factory Boy (test data generation)
- responses or unittest.mock (API mocking)

**Commands:**
```bash
# Run all tests
pytest

# Run specific test file
pytest tests/api/test_events.py

# Run with coverage
pytest --cov=greedybear

# Run only new changes
pytest --lf (last failed)
```

---

## Deployment & Infrastructure

### Docker Containerization

**Services in docker-compose.yml:**
```yaml
services:
  postgres:       # Database
  elasticsearch:  # Search engine
  redis:         # Cache/broker (if still used)
  uwsgi:         # Django app server
  nginx:         # Reverse proxy, static files
  frontend:      # Node.js for Vite dev server
  q2-worker:     # Django Q2 background tasks
```

### Development Setup

**Single Command:**
```bash
./gbctl init --dev --elastic-local
```

**What it does:**
1. Pulls latest images
2. Starts all services
3. Runs migrations
4. Creates superuser
5. Seeds initial data
6. Starts local Elasticsearch

### Nginx Configuration

**Typical Setup:**
- Reverse proxy for Django backend (port 8000)
- Static file serving (CSS, JS, images)
- Compression (gzip)
- SSL/TLS termination (production)

### uWSGI Application Server

**Configuration:**
- Worker processes scaled to CPU count
- Master process monitoring
- Automatic respawn on crash
- Memory limits

---

## Elasticsearch Integration

### Purpose in GreedyBear

1. **Full-Text Search** - Search events by payload content
2. **Analytics** - Aggregate events by source IP, country, time period
3. **Real-Time Dashboards** - Live statistics and heatmaps
4. **Scalability** - Handle millions of events efficiently

### Index Structure

**Time-Series Indices:**
```
events-2026-03-01
events-2026-03-02
events-2026-03-03
...
```

Benefits:
- Easy retention (delete old indices)
- Index rotation (new index daily)
- Better performance (smaller shards)

### Querying from Django

**Via Elasticsearch DSL library:**
```python
from elasticsearch_dsl import Search

def search_events(query_str, source_ip=None):
    s = Search(index='events-*')
    s = s.query('match', payload=query_str)
    if source_ip:
        s = s.filter('term', source_ip=source_ip)
    return s.execute()
```

---

## Extension Points for GSoC

### 1. Event Collector API Endpoint
- **Location:** `/api/events/collector/` (or `/api/inject/`)
- **Method:** POST
- **Auth:** Token-based with `events:write` scope
- **Rate Limit:** Configurable (e.g., 1000 req/hour)

### 2. Serializer for Injected Events
- **Location:** `/api/serializers.py`
- **Schema:** Define expected fields, types, validation
- **Example Fields:** timestamp, event_type, source_ip, payload, etc.

### 3. Processing Pipeline
- **Location:** `/cronjobs/`
- **Task:** Post-injection processing (enrichment, ES indexing)
- **Queue:** Django Q2

### 4. Permissions & Authentication
- **Location:** `/authentication/`
- **New Classes:** `IsEventCollector`, scope checking
- **Token Management:** API key generation for external services

### 5. Tests
- **Location:** `/tests/api/test_event_collector.py`
- **Coverage:** Authentication, validation, rate limiting, error cases

### 6. Documentation
- **Location:** `/docs/` or inline docstrings
- **Format:** OpenAPI/Swagger (auto-generated from DRF)
- **Content:** Endpoint description, request/response examples, error codes

---

## Performance Considerations

### N+1 Query Prevention
- Use `select_related()` for ForeignKey
- Use `prefetch_related()` for reverse relations
- Issue #1073 is open for optimization

### Caching Strategy
- Redis cache for frequently accessed data
- Elasticsearch for search result caching
- HTTP caching headers on API responses

### Rate Limiting
- Per-user rate limits (default: 1000 req/hour)
- Per-IP rate limits for anonymous
- Configurable via settings

### Database Indexing
- Indexes on frequently filtered fields (source_ip, event_type)
- Composite indexes for common filter combinations
- Regular ANALYZE/VACUUM on PostgreSQL

---

## Summary for GSoC Contributors

When implementing the **Event Collector API**:

1. **Start in `/api/`** - Create viewset, serializer, URL registration
2. **Implement in `/authentication/`** - Token validation, permissions
3. **Add to `/cronjobs/`** - Processing task for injected events
4. **Test thoroughly in `/tests/`** - Unit + integration tests
5. **Follow code style** - Use `ruff check . --fix && ruff format .`
6. **Document via docstrings** - DRF auto-generates OpenAPI

The architecture is modular and extensible — adding a new API endpoint follows established patterns and minimal ceremony.

---

**Document Version:** 1.0
**Created:** March 18, 2026
