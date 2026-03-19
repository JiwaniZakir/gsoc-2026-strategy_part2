# GreedyBear Event Collector API — GSoC 2026 Proposal

**Applicant:** Zakir Jiwani
**GitHub:** @zakirjiwani
**Email:** [your-email@domain.com]
**Timezone:** [Your Timezone, e.g., US Eastern]
**Expected Availability:** 40+ hours/week (May — August)
**Organization:** The Honeynet Project / GreedyBear
**Mentors:** Tim Leonhard (frontend), Matteo Lodi (backend)
**Project Difficulty:** 175-350 hours (medium-large)

---

## Executive Summary

This proposal outlines the design and implementation of a **secure, scalable Event Collector API** for GreedyBear, enabling external applications to programmatically inject standardized honeypot event data. The API will feature token-based authentication, rate limiting, comprehensive validation, and a fully asynchronous processing pipeline. This transforms GreedyBear from a single-source intelligence platform into a **multi-source threat intelligence hub**, critical for enterprises managing heterogeneous honeypot infrastructure.

---

## Problem Statement

### Current State

GreedyBear currently receives event data from **single-source T-Pot honeypot deployments**. Data flow is:

```
T-Pot Honeypot → Elasticsearch → GreedyBear Django Backend → API/Dashboard
```

**Limitations:**
1. **Single Source:** Only T-Pot data supported natively
2. **Manual Integration:** External honeypot managers (Cowrie, Glastopf, etc.) require custom integrations
3. **No Standard Format:** Each external source needs custom adapters
4. **Scalability Concern:** Direct Elasticsearch writes bypassed API layer; difficult to audit/control
5. **Enterprise Gap:** Organizations running multiple honeypot types can't consolidate intelligence in GreedyBear

### Business Impact

Security teams managing distributed honeypots currently:
- Cannot centralize intelligence across multiple honeypot types
- Lack a unified API for programmatic event injection
- Have no rate limiting/quota system for external sources
- Cannot audit who injected what data, when, and why

This limits GreedyBear's utility in production enterprises where heterogeneous infrastructure is the norm.

### Solution: Event Collector API

A **secure REST endpoint** that:
1. Accepts standardized event JSON from any source
2. Authenticates via token-based credentials with scopes
3. Validates against predefined schema
4. Rates limits per source/token
5. Processes events asynchronously (enrichment, ES indexing)
6. Provides status tracking for injected events
7. Audits all ingestion (who, what, when, IP)

---

## Project Goals

### Primary Goals

1. **Enable Multi-Source Event Ingestion**
   - RESTful endpoint for event injection
   - Support any honeypot manager or threat intel platform
   - Backward compatible with existing APIs

2. **Enterprise-Grade Security**
   - Token-based authentication with scopes
   - Rate limiting (configurable per token)
   - API key rotation support
   - Audit logging of all injections

3. **Data Quality & Validation**
   - Strict schema enforcement (DRF serializers)
   - Field type validation (IPs, ports, timestamps)
   - Cross-field constraint validation
   - Meaningful error responses (not generic 400s)

4. **Reliable Processing**
   - Asynchronous task queue (Django Q2)
   - Idempotent event handling (no duplicates)
   - Error tracking (failed events visible to operator)
   - Retry logic for transient failures

5. **Developer Experience**
   - Clear API documentation (OpenAPI/Swagger)
   - Example code in Python, cURL, JavaScript
   - Postman collection for exploration
   - Comprehensive test coverage (>80%)

### Secondary Goals

1. **Frontend Token Management**
   - Dashboard UI for API token CRUD
   - Copy-to-clipboard for token display
   - Rate limit configuration per token
   - Token usage statistics

2. **Monitoring & Analytics**
   - Events ingested per source/token
   - Error rate tracking
   - Processing latency metrics
   - Dashboard widgets for injection health

3. **Operational Features**
   - Token expiration & revocation
   - IP whitelisting per token
   - Scopes management (read, write, admin)
   - Bulk event validation endpoint

---

## Scope & Deliverables

### Scope: In

**Backend API Implementation (Primary Focus)**
- [x] Event model enhancements (if needed)
- [x] DRF serializers with validation
- [x] Authentication (token + custom class)
- [x] Permission classes (scopes-based)
- [x] ViewSet implementation (POST, GET status)
- [x] Rate limiting middleware
- [x] Cronjob for event processing
- [x] Error handling & logging
- [x] Comprehensive unit & integration tests
- [x] OpenAPI schema (auto-generated)
- [x] API documentation (Markdown guide)
- [x] Example scripts (cURL, Python, JavaScript)

**Frontend Integration (Supporting)**
- [x] Token management UI (CRUD)
- [x] Token display with copy-to-clipboard
- [x] Basic statistics dashboard
- [x] Error messages for injected events

**DevOps & Infrastructure**
- [x] Database migrations
- [x] Docker configuration (if needed)
- [x] CI/CD pipeline updates

### Scope: Out

**Out of Scope (Future Work)**
- [ ] Bulk import endpoints (CSV/JSON file upload)
- [ ] Event filtering by source in API (search/list improvements are separate issues)
- [ ] Custom field mappings per source
- [ ] Multi-tenancy support
- [ ] gRPC endpoints (REST sufficient for MVP)
- [ ] Kafka/Message Queue integration (Django Q2 sufficient)
- [ ] Advanced threat intelligence enrichment pipeline
- [ ] ML-based anomaly detection

---

## Technical Approach

### Architecture Overview

```
External Service
      ↓
[POST /api/v1/events/collect/]
      ↓
DRF ViewSet
  - Authenticate (token)
  - Check scopes (events:write)
  - Check rate limit
      ↓
EventCollectorSerializer
  - Validate schema
  - Type checking
  - Cross-field validation
      ↓
Django Q2 Task Queue
      ↓
Processing Task
  - Enrich (threat intel lookups)
  - Index to Elasticsearch
  - Update statistics
  - Generate alerts (if high severity)
      ↓
Event stored with status=completed
      ↓
Frontend displays in dashboard
```

### Technology Decisions & Rationale

#### 1. REST API (vs GraphQL, gRPC)

**Decision:** REST (HTTP POST) for event injection

**Rationale:**
- Existing DRF codebase uses REST exclusively
- Simplest for external clients (no special libraries)
- Better for rate limiting (HTTP headers)
- OpenAPI schema auto-generated
- GraphQL overkill for linear write operation

#### 2. Token-Based Authentication (vs OAuth2)

**Decision:** Custom token authentication (DRF TokenAuthentication + custom class)

**Rationale:**
- OAuth2 overhead not justified for service-to-service communication
- Token per service/honeypot manager is clearer model
- Easier to rotate, revoke, audit individual tokens
- Matches existing GreedyBear auth patterns
- Scopes can be added without full OAuth2 framework

**Implementation:**
```python
# Request
POST /api/v1/events/collect/
Authorization: EventToken abc123def456...

# Token lookup
token = EventCollectorToken.objects.get(key='abc123...')
if token.expires_at < now():
    raise AuthenticationFailed('Token expired')
```

#### 3. Django Q2 for Processing (vs Celery)

**Decision:** Use existing Django Q2 task queue

**Rationale:**
- Already migrated to Django Q2 (PR #789 merged)
- No additional infrastructure (uses PostgreSQL)
- Sufficient for event processing volumes
- Fits architectural direction

#### 4. Asynchronous Processing (vs Synchronous)

**Decision:** Queue injection for async processing, return 202 Accepted immediately

**Rationale:**
- Event enrichment (IP geolocation, threat intel lookup) is slow
- Elasticsearch indexing is I/O bound
- Return immediately so client isn't blocked
- Provide `/status/` endpoint for tracking

**HTTP Status Codes:**
- **202 Accepted:** Event queued, processing started
- **400 Bad Request:** Validation error (fix request)
- **401 Unauthorized:** Missing/invalid token
- **403 Forbidden:** Token lacks `events:write` scope
- **429 Too Many Requests:** Rate limit exceeded
- **500 Server Error:** Unexpected error (shouldn't happen)

#### 5. Database-Level Constraints (vs Application Logic)

**Decision:** Validation in DRF serializer + database constraints

**Rationale:**
- Serializer provides immediate feedback (good UX for API clients)
- Database constraints prevent inconsistency (data integrity)
- Error messages from serializer are API-friendly
- Application logic handles business rules

**Example:**
```python
# Serializer validation
source_ip = serializers.CharField(
    validators=[IPAddressValidator()]
)

# Database constraint
class Event(models.Model):
    source_ip = models.GenericIPAddressField()
    destination_ip = models.GenericIPAddressField()

    class Meta:
        constraints = [
            CheckConstraint(
                check=~Q(source_ip=F('destination_ip')),
                name='source_dest_different'
            )
        ]
```

### API Endpoint Specification

#### Endpoint 1: Create Event (Inject)

```
POST /api/v1/events/collect/

Headers:
  Authorization: EventToken YOUR_API_TOKEN
  Content-Type: application/json

Request Body (JSON):
{
  "event_type": "ssh_brute_force",
  "timestamp": "2026-03-18T14:30:00Z",
  "source_ip": "192.168.1.100",
  "destination_ip": "10.0.0.1",
  "source_port": 54321,
  "destination_port": 22,
  "protocol": "ssh",
  "severity": "high",
  "payload": {
    "username_attempts": ["admin", "root"],
    "password_attempts": 1000
  },
  "tags": ["brute-force", "ssh", "external"],
  "source_identifier": "honeypot-eu-01"
}

Response (202 Accepted):
{
  "id": "550e8400-e29b-41d4-a716-446655440000",
  "event_type": "ssh_brute_force",
  "timestamp": "2026-03-18T14:30:00Z",
  "status": "processing",
  "message": "Event queued for processing",
  "processing_url": "/api/v1/events/550e8400.../status/"
}
```

#### Endpoint 2: Check Event Status

```
GET /api/v1/events/{event_id}/status/

Headers:
  Authorization: EventToken YOUR_API_TOKEN

Response:
{
  "id": "550e8400-e29b-41d4-a716-446655440000",
  "status": "completed",  // or "pending", "processing", "failed"
  "created_at": "2026-03-18T14:30:00Z",
  "processed_at": "2026-03-18T14:30:05Z",
  "error_message": null,
  "artifacts": {
    "extracted_ips": ["192.168.1.100"],
    "extracted_domains": [],
    "extracted_hashes": []
  }
}
```

#### Endpoint 3: List Injected Events (Optional, but useful)

```
GET /api/v1/events/collect/?source_identifier=honeypot-eu-01&status=failed

Response:
{
  "count": 5,
  "next": null,
  "previous": null,
  "results": [
    {
      "id": "...",
      "event_type": "...",
      "status": "failed",
      "error_message": "Invalid payload structure",
      ...
    }
  ]
}
```

### Data Validation Schema

**EventCollectorSerializer fields:**

| Field | Type | Required | Constraints | Example |
|-------|------|----------|-------------|---------|
| `event_type` | String | Yes | Valid enum | "ssh_brute_force" |
| `timestamp` | DateTime | Yes | ISO 8601, not future | "2026-03-18T14:30:00Z" |
| `source_ip` | IPv4/IPv6 | Yes | Valid IP format | "192.168.1.100" |
| `destination_ip` | IPv4/IPv6 | Yes | Valid IP format, ≠ source_ip | "10.0.0.1" |
| `source_port` | Integer | Yes | 1-65535 | 54321 |
| `destination_port` | Integer | Yes | 1-65535 | 22 |
| `protocol` | String | Yes | Valid enum | "ssh", "http", "ftp" |
| `severity` | String | Yes | low/medium/high/critical | "high" |
| `payload` | JSON | Optional | No size limit > 10MB | {} |
| `tags` | Array | Optional | Max 20 tags | ["ssh", "brute-force"] |
| `source_identifier` | String | Optional | Max 255 chars | "honeypot-eu-01" |

**Validation Rules:**
```
1. All required fields present
2. source_ip ≠ destination_ip (cannot be same)
3. source_port and destination_port in valid range
4. timestamp not in future (tolerance: 1 minute)
5. payload size < 10MB (prevent abuse)
6. tags array < 20 items
7. event_type in predefined list (whitelist)
```

### Authentication & Authorization

#### Token Model

```python
class EventCollectorToken(models.Model):
    key = models.CharField(max_length=40, unique=True, primary_key=True)
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    name = models.CharField(max_length=255)
    scopes = models.JSONField(default=list)  # ["events:write", ...]
    rate_limit = models.IntegerField(default=1000)  # per hour
    ip_whitelist = models.JSONField(default=list, blank=True)  # ["192.168.1.0/24", ...]
    last_used = models.DateTimeField(null=True)
    created_at = models.DateTimeField(auto_now_add=True)
    expires_at = models.DateTimeField(null=True)
    is_active = models.BooleanField(default=True)
```

#### Scopes

- `events:write` — Permission to inject events
- `events:read` — Permission to query injected events
- `tokens:admin` — Permission to manage tokens (for ops)

#### Rate Limiting Strategy

```python
class EventCollectorThrottle(UserRateThrottle):
    def get_rate(self):
        token = self.request.auth
        if hasattr(token, 'rate_limit'):
            return f"{token.rate_limit}/hour"
        return "1000/hour"  # Default

# Django setting
REST_FRAMEWORK = {
    'DEFAULT_THROTTLE_CLASSES': [
        'greedybear.api.throttles.EventCollectorThrottle'
    ]
}
```

**Rate Limit Response:**
```
HTTP 429 Too Many Requests

{
  "detail": "Request was throttled. Expected available in 3600 seconds."
}
```

### Testing Strategy

**Test Coverage Goal:** >80% on new code

#### Unit Tests

```python
# tests/api/test_event_collector_serializer.py
class EventCollectorSerializerTestCase(TestCase):
    def test_valid_event(self): pass
    def test_invalid_source_ip(self): pass
    def test_same_source_dest_ip(self): pass
    def test_future_timestamp(self): pass
    def test_payload_too_large(self): pass
    def test_invalid_severity(self): pass
    def test_tags_limit(self): pass
```

#### Integration Tests

```python
# tests/api/test_event_collector_api.py
class EventCollectorAPITestCase(TestCase):
    def test_create_event_success_returns_202(self): pass
    def test_create_event_no_auth_returns_401(self): pass
    def test_create_event_no_write_scope_returns_403(self): pass
    def test_rate_limiting_enforced(self): pass
    def test_event_status_endpoint(self): pass
    def test_error_response_format(self): pass
    def test_async_processing_triggered(self): pass
```

#### End-to-End Tests

```python
# tests/integration/test_event_collection_workflow.py
class EventCollectionWorkflowTestCase(TestCase):
    def test_full_workflow_inject_to_completion(self):
        # 1. Create token
        # 2. Inject event
        # 3. Task processes async
        # 4. Check status
        # 5. Verify ES indexed
        # 6. Verify in dashboard
        pass
```

### Processing Pipeline

#### Step 1: Receive & Validate

```python
# ViewSet.create()
serializer = EventCollectorSerializer(data=request.data)
serializer.is_valid(raise_exception=True)  # Raises 400 if invalid
```

#### Step 2: Create Event Object

```python
event = serializer.save(
    injected_by=request.user,
    status='pending'
)
# Returns 202 immediately
```

#### Step 3: Queue Processing Task

```python
from django_q.tasks import async_task

async_task('greedybear.cronjobs.event_collector.process_collected_event',
           event.id)
# Non-blocking, returns immediately
```

#### Step 4: Processing Task Executes (Async)

```python
def process_collected_event(event_id):
    """
    1. Fetch event
    2. Enrich (WHOIS, threat intel, geolocation)
    3. Index to Elasticsearch
    4. Generate alerts (if severity >= high)
    5. Mark as completed
    """
    event = Event.objects.get(id=event_id)

    try:
        # Enrich
        event.extracted_artifacts = enrich_event(event)

        # Index to ES
        index_to_elasticsearch(event)

        # Alerts
        if event.severity in ['high', 'critical']:
            generate_alert(event)

        event.status = 'completed'
        event.processed_at = timezone.now()
        event.save()

    except Exception as e:
        event.status = 'failed'
        event.error_message = str(e)
        event.save()
        logger.exception(f"Failed to process event {event_id}")
```

#### Step 5: Status Available

```python
# Client polls /api/v1/events/{id}/status/
GET /api/v1/events/550e8400.../status/

Response:
{
  "status": "completed",
  "processed_at": "2026-03-18T14:30:05Z",
  "error_message": null
}
```

### Error Handling

#### Schema Validation Errors (400)

```json
{
  "errors": {
    "source_ip": ["Invalid IPv4 address"],
    "source_port": ["Ensure this value is less than or equal to 65535"],
    "event_type": ["Not a valid choice. Valid choices are: ssh_brute_force, ..."]
  }
}
```

#### Authentication Errors (401/403)

```json
{
  "detail": "Invalid token." // 401
}

{
  "detail": "Access denied. Missing required scope: events:write" // 403
}
```

#### Rate Limit Errors (429)

```json
{
  "detail": "Request was throttled. Expected available in 3600 seconds."
}
```

#### Processing Errors (visible in status endpoint)

```json
{
  "status": "failed",
  "error_message": "Elasticsearch connection failed. Retry later.",
  "created_at": "2026-03-18T14:30:00Z"
}
```

---

## Implementation Timeline

### Pre-GSoC (April, ~2 weeks)

- [ ] Set up Discord and engage with mentors
- [ ] Fix small issues (#1083, #1089) to build reputation
- [ ] Get PR feedback process down
- [ ] Review architecture with mentors
- [ ] Finalize proposal based on feedback

### GSoC Phase 1: Foundation (Weeks 1-2)

**Deliverables:**
- Event model migration (if needed)
- EventCollectorToken model
- EventCollectorSerializer with validation
- Basic unit tests for serializer

**PR:** Draft PR with models and serializers

### GSoC Phase 2: API Implementation (Weeks 3-4)

**Deliverables:**
- Custom authentication class
- Permission classes (IsEventCollector)
- EventCollectorViewSet (POST endpoint)
- Integration tests
- Error response formatting

**PR:** Draft PR with viewset and auth

### GSoC Phase 3: Processing Pipeline (Weeks 5-6)

**Deliverables:**
- Django Q2 task for event processing
- Enrichment pipeline (threat intel lookups)
- Status endpoint implementation
- Error tracking

**PR:** Draft PR with cronjob and status

### GSoC Phase 4: Quality & Testing (Weeks 7-8)

**Deliverables:**
- Comprehensive test coverage (>80%)
- Rate limiting implementation
- Edge case handling
- Integration tests (end-to-end)

**PR:** Draft PR with tests

### GSoC Phase 5: Documentation & Polish (Weeks 9-10)

**Deliverables:**
- OpenAPI schema (auto-generated)
- API documentation (Markdown guide)
- Example scripts (cURL, Python, JavaScript)
- Postman collection
- Deployment documentation
- Code review and refinements

**PR:** Final PR ready for merge

### Stretch Goals (If Ahead of Schedule)

- [ ] Frontend token management UI
- [ ] Dashboard statistics widget
- [ ] Bulk event validation endpoint
- [ ] Event filtering enhancements
- [ ] Performance optimization (N+1 queries)

---

## Success Criteria

### Must-Have Deliverables

- [x] Event Collector API endpoint (`POST /api/v1/events/collect/`)
- [x] Token-based authentication with scopes
- [x] DRF serializer with comprehensive validation
- [x] Rate limiting per token
- [x] Asynchronous processing via Django Q2
- [x] Status endpoint to track event processing
- [x] Error handling and meaningful error responses
- [x] >80% test coverage
- [x] OpenAPI schema documentation
- [x] Markdown API guide with examples
- [x] Database migrations
- [x] Code follows Ruff style (100% pass)

### Nice-to-Have Deliverables

- [ ] Frontend token management UI
- [ ] Dashboard statistics widget
- [ ] Postman collection
- [ ] Example scripts in multiple languages
- [ ] Performance optimization (N+1 queries)
- [ ] Monitoring/alerting for failed events

### Quality Metrics

- **Code Coverage:** >80% for new code
- **Test Pass Rate:** 100%
- **Ruff Compliance:** 0 warnings/errors
- **PR Reviews:** All feedback addressed within 24 hours
- **Deployment:** Zero regressions in existing APIs

---

## Why This Project?

### Personal Motivation

I've been working with Django and REST APIs for 3+ years, primarily in backend infrastructure. The Event Collector API project appeals because it combines:

1. **Architectural Challenge:** Designing a secure, scalable API from scratch requires deep understanding of authentication, validation, async processing, and error handling.

2. **Real-World Impact:** Honeypot intelligence directly improves security posture across organizations. Being part of that pipeline is meaningful.

3. **Mentorship Opportunity:** Learning from Matteo Lodi (Django architect) and Tim Leonhard (frontend) directly accelerates my growth in scalable system design.

4. **Open Source Contribution:** Contributing to Honeynet (respected in cybersecurity) builds credibility and gives back to the community.

### Why GreedyBear Specifically

- **Active Community:** 432 merged PRs, 29 contributors — healthy, engaged project
- **Clear Scope:** Event Collector API is well-defined with clear boundaries (no scope creep risk)
- **Modern Stack:** Django 5.x, DRF, PostgreSQL, Elasticsearch — current best practices
- **Production-Ready:** Not an experimental project; real organizations depend on GreedyBear
- **Mentorship Quality:** Tim and Matteo are active, responsive mentors with deep expertise

---

## About the Applicant

**Name:** Zakir Jiwani
**GitHub:** @zakirjiwani
**Email:** [your-email@domain.com]
**Location:** [Your City/Country]
**Timezone:** [e.g., US Eastern UTC-5]

### Experience

**Backend Development (3+ years)**
- Python/Django: Built REST APIs, microservices, data pipelines
- Databases: PostgreSQL, MongoDB, Elasticsearch
- Async Tasks: Celery, RQ, now learning Django Q2
- Testing: pytest, coverage, TDD practices

**Projects**
- [GitHub project 1]: [Brief description]
- [GitHub project 2]: [Brief description]

**Relevant Skills for GSoC**
- [x] Django/DRF expertise (REST API design)
- [x] PostgreSQL (data modeling, migrations)
- [x] Authentication/security patterns
- [x] Testing (unit, integration, E2E)
- [x] Git/GitHub workflow (commit messages, PR discipline)
- [x] Async task queues (Celery, now Django Q2)
- [x] API design (validation, error handling)

**Communication**
- Available 40+ hours/week during GSoC
- Responsive to feedback (target: <24 hours)
- Proactive status updates (weekly)
- Comfortable with async (Discord, GitHub) and sync (video calls) communication

---

## Risks & Mitigation

### Risk 1: Elasticsearch Integration Complexity

**Risk:** Event indexing to Elasticsearch might be more complex than anticipated

**Mitigation:**
- Study existing ES integration in codebase (PR #882, etc.)
- Get help from mentors early if blocked
- Fall back to PostgreSQL-only mode if ES issues arise (still functional)
- Well-scoped: ES is secondary to core API

### Risk 2: Django Q2 Learning Curve

**Risk:** Recent migration to Django Q2; less familiar than Celery

**Mitigation:**
- Read PR #789 (Django Q2 migration) carefully
- Review existing Django Q2 tasks in `/cronjobs/`
- Ask Matteo for guidance on best practices
- Simple task pattern (fetch, process, save) well-supported by Q2

### Risk 3: Scope Creep

**Risk:** Temptation to add frontend features beyond scope

**Mitigation:**
- Strict scope definition upfront (documented above)
- Mentors will review scope during planning
- If ahead of schedule, discuss stretch goals with mentors
- API-focused: frontend is nice-to-have, not critical

### Risk 4: Timeline Slippage

**Risk:** Unexpected complications delay deliverables

**Mitigation:**
- Buffer in timeline (10-week schedule for 8-week GSoC)
- Weekly check-ins with mentors to catch issues early
- Deliver in phases (incremental PRs) rather than monolithic PR
- Prioritize must-haves; scope down if needed

---

## References & Inspiration

### Related GreedyBear Features

- **Authentication System:** `/authentication/` directory, existing token patterns
- **DRF ViewSets:** `/api/views.py` — existing CRUD patterns
- **Django Q2 Tasks:** `/cronjobs/` directory — task queue examples
- **Elasticsearch Integration:** `indexing.py`, recent PRs

### External Resources

- Django REST Framework: https://www.django-rest-framework.org/
- Django Q2 Documentation: https://django-q.readthedocs.io/
- API Design Best Practices: RESTful API guidelines
- OpenAPI Specification: https://spec.openapis.org/

---

## Conclusion

The Event Collector API is a strategic feature that transforms GreedyBear from a single-source intelligence platform into a multi-source threat intelligence hub. It addresses a real need in the community (centralized honeypot intelligence collection) and demonstrates solid engineering fundamentals (authentication, validation, async processing, testing).

I'm excited about the opportunity to contribute meaningfully to Honeynet's mission while learning from expert mentors. The project scope is well-defined, achievable within 10 weeks, and has clear success criteria.

I'm committed to following GreedyBear's contribution guidelines, maintaining code quality, and being responsive to feedback throughout the GSoC period.

---

**Proposal Version:** 1.0
**Last Updated:** March 18, 2026
**Status:** Ready for mentor feedback

---

## Appendix: Questions for Mentors

Before finalizing this proposal, I have these questions for Tim and Matteo:

1. **Authentication Scope:** Would you prefer custom token implementation (as proposed) or DRF's built-in TokenAuthentication? Any precedent in codebase?

2. **Rate Limiting:** Should rate limits be configurable per token, or global? Proposed per-token, but want to confirm.

3. **Event Enrichment:** What threat intelligence sources should I integrate? (IP geolocation, reputation lookups, domain WHOIS?) Or keep it minimal initially?

4. **Frontend:** Should token management UI be part of GSoC scope, or can I defer to Phase 2/3 and focus on backend API first?

5. **Elasticsearch Indexing:** Should injected events go to separate indices (e.g., `events-injected-*`) or mix with T-Pot events? Implications for querying?

6. **Backward Compatibility:** Any existing APIs that might conflict with new `/api/v1/events/collect/` endpoint? Or should I use different path?

7. **Documentation:** Any preferred format/tool for API docs? (Swagger UI, Postman, Markdown guides, etc.)

These clarifications will help refine the proposal before GSoC officially starts.

---

