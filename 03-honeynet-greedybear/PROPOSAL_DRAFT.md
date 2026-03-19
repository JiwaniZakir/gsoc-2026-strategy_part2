# GSoC 2026 Proposal: GreedyBear Event Collector API

**Applicant:** Zakir Jiwani
**GitHub:** github.com/JiwaniZakir
**Email:** jiwzakir@gmail.com
**Timezone:** EST (UTC-5)
**Availability:** Full-time, 40 hrs/week (May–August)
**Organization:** The Honeynet Project / GreedyBear
**Mentors:** Matteo Lodi (backend), Tim Leonhard (frontend)
**Duration:** 175–350 hours
**Difficulty:** Medium–Large

---

## Synopsis

GreedyBear currently accepts honeypot events only from T-Pot deployments. This limits it to users running exactly one honeypot stack, missing the large population of security teams running Cowrie, Glastopf, or custom honeypots. This project designs and implements a **secure, production-ready Event Collector API** — a REST endpoint that lets any external application inject standardized honeypot events into GreedyBear with token-based authentication, configurable rate limiting, full validation, and asynchronous processing via Django Q2. The result transforms GreedyBear from a single-source platform into a multi-source threat intelligence hub.

---

## Problem Statement

### Current Architecture Limitation

```
T-Pot Honeypot → Elasticsearch → GreedyBear Django → API/Dashboard
```

No standardized ingestion path exists for any other honeypot type. Organizations running:
- Cowrie SSH honeypots
- Glastopf web honeypots
- Custom deception platforms
- Commercial honeypot solutions

...cannot get their data into GreedyBear without custom, one-off integrations that break on every API change.

### Impact

1. **Data gap:** GreedyBear's threat intelligence is incomplete — it only sees T-Pot events
2. **Enterprise blocker:** Security teams with heterogeneous stacks can't adopt GreedyBear
3. **No audit trail:** There's no way to know who injected what data, when, or from where
4. **Scalability concern:** Direct Elasticsearch writes bypass the API layer, removing validation

### Solution

A REST endpoint (`POST /api/v1/events/collect/`) that:
- Authenticates via token with configurable scopes
- Validates incoming event data against a strict schema
- Queues events for async processing via Django Q2
- Provides status tracking for each injected event
- Logs all injections for audit purposes

---

## Technical Design

### Architecture

```
External Honeypot / Platform
          ↓
POST /api/v1/events/collect/
          ↓
DRF ViewSet
  ├── EventCollectorTokenAuthentication (custom)
  ├── IsEventCollector permission (scope check)
  └── EventCollectorThrottle (per-token rate limit)
          ↓
EventCollectorSerializer (validation)
  ├── IP address format
  ├── Port range validation
  ├── Timestamp constraints
  └── Cross-field validation (source_ip ≠ dest_ip)
          ↓
event.save(status='pending')
Return 202 Accepted immediately
          ↓
Django Q2: async_task('process_collected_event', event.id)
          ↓
Processing Task:
  ├── Threat intel enrichment (WHOIS, geolocation)
  ├── Elasticsearch indexing
  ├── Alert generation (severity >= high)
  └── event.status = 'completed'
```

### Token Model

```python
class EventCollectorToken(models.Model):
    key = models.CharField(max_length=40, unique=True, primary_key=True)
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    name = models.CharField(max_length=255)
    scopes = models.JSONField(default=list)       # ["events:write", "events:read"]
    rate_limit = models.IntegerField(default=1000) # requests per hour
    ip_whitelist = models.JSONField(default=list, blank=True)
    last_used = models.DateTimeField(null=True)
    created_at = models.DateTimeField(auto_now_add=True)
    expires_at = models.DateTimeField(null=True)
    is_active = models.BooleanField(default=True)

    def is_valid(self) -> bool:
        if not self.is_active:
            return False
        if self.expires_at and self.expires_at < timezone.now():
            return False
        return True
```

### Custom Authentication Class

```python
class EventCollectorTokenAuthentication(TokenAuthentication):
    keyword = 'EventToken'

    def authenticate(self, request):
        result = super().authenticate(request)
        if result is None:
            return None

        user, token = result

        if not token.is_valid():
            raise AuthenticationFailed('Token is expired or inactive')

        # Update last_used without triggering full model validation
        EventCollectorToken.objects.filter(pk=token.pk).update(
            last_used=timezone.now()
        )

        return user, token
```

### Custom Permission (Scope Check)

```python
class IsEventCollector(BasePermission):
    message = 'Valid events:write scope required.'

    def has_permission(self, request, view):
        if request.method not in ('POST',):
            return True
        token = request.auth
        if not token or not hasattr(token, 'scopes'):
            return False
        return 'events:write' in token.scopes
```

### Per-Token Rate Limiting

```python
class EventCollectorThrottle(UserRateThrottle):
    def get_rate(self):
        token = self.request.auth
        if hasattr(token, 'rate_limit') and token.rate_limit:
            return f'{token.rate_limit}/hour'
        return '1000/hour'  # Default
```

### Event Schema Validation

```python
class EventCollectorSerializer(serializers.ModelSerializer):
    VALID_EVENT_TYPES = [
        'ssh_brute_force', 'http_scan', 'port_scan',
        'telnet_brute_force', 'ftp_brute_force', 'rdp_scan',
        'smtp_spam', 'dns_amplification', 'custom'
    ]

    def validate_source_ip(self, value):
        try:
            ipaddress.ip_address(value)
        except ValueError:
            raise serializers.ValidationError(f'Invalid IP address: {value}')
        return value

    def validate_source_port(self, value):
        if not (1 <= value <= 65535):
            raise serializers.ValidationError('Port must be 1–65535')
        return value

    def validate_timestamp(self, value):
        # Reject future timestamps (with 60s tolerance)
        if value > timezone.now() + timedelta(seconds=60):
            raise serializers.ValidationError('Timestamp cannot be in the future')
        return value

    def validate(self, data):
        if data.get('source_ip') == data.get('destination_ip'):
            raise serializers.ValidationError(
                'source_ip and destination_ip cannot be the same'
            )
        return data
```

### ViewSet

```python
class EventCollectorViewSet(viewsets.GenericViewSet):
    authentication_classes = [EventCollectorTokenAuthentication]
    permission_classes = [IsAuthenticated, IsEventCollector]
    throttle_classes = [EventCollectorThrottle]
    serializer_class = EventCollectorSerializer

    def create(self, request):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        event = serializer.save(
            injected_by=request.user,
            source_token=request.auth,
            status='pending'
        )
        async_task(
            'greedybear.cronjobs.event_collector.process_collected_event',
            event.id
        )
        return Response(
            {'id': str(event.id), 'status': 'processing'},
            status=status.HTTP_202_ACCEPTED
        )

    @action(detail=True, methods=['get'])
    def status(self, request, pk=None):
        event = get_object_or_404(
            Event, id=pk, injected_by=request.user
        )
        return Response({
            'id': str(event.id),
            'status': event.status,
            'created_at': event.created_at,
            'processed_at': event.processed_at,
            'error_message': event.error_message
        })
```

---

## API Specification

### Endpoint 1: Inject Event

```
POST /api/v1/events/collect/
Authorization: EventToken <your-token>
Content-Type: application/json

{
  "event_type": "ssh_brute_force",
  "timestamp": "2026-03-19T14:30:00Z",
  "source_ip": "203.0.113.50",
  "destination_ip": "10.0.0.1",
  "source_port": 54321,
  "destination_port": 22,
  "protocol": "ssh",
  "severity": "high",
  "payload": { "username_attempts": ["admin", "root"] },
  "tags": ["brute-force", "external"],
  "source_identifier": "cowrie-eu-01"
}

→ 202 Accepted
{ "id": "550e8400-...", "status": "processing" }
```

### Endpoint 2: Check Status

```
GET /api/v1/events/collect/{id}/status/
Authorization: EventToken <your-token>

→ 200 OK
{ "id": "550e8400-...", "status": "completed", "processed_at": "..." }
```

### Error Responses

| HTTP | Code | Meaning |
|------|------|---------|
| 400 | VALIDATION_ERROR | Invalid schema |
| 401 | AUTH_FAILED | Missing/expired token |
| 403 | PERMISSION_DENIED | Token lacks events:write |
| 429 | THROTTLED | Rate limit exceeded |

---

## Implementation Timeline

| Week | Focus | Deliverables |
|------|-------|-------------|
| 1 | Pre-GSoC contributions (now) | 2+ PRs merged, environment running |
| 2 | Event model + Token model | Migrations, model tests |
| 3 | Serializer + validation | All field validators, cross-field checks |
| 4 | Auth class + permissions | Token auth, scope check, throttle |
| 5 | ViewSet + URL routing | POST endpoint, status endpoint |
| 6 | Django Q2 processing task | Async event processing, error tracking |
| 7 | Rate limiting + edge cases | Per-token rate limiting, error scenarios |
| 8 | Test coverage ≥80% | Unit + integration + E2E tests |
| 9 | Documentation | OpenAPI schema, Markdown guide, examples |
| 10 | Frontend token management UI | CRUD for tokens, copy-to-clipboard |
| 11 | Dashboard statistics widget | Events per source, error rates |
| 12 | Final review + polish | Performance optimization, deployment docs |

---

## Testing Strategy

### Test Coverage Target: ≥80% on new code

```python
# Key test cases
class EventCollectorAPITests(TestCase):

    def test_valid_event_returns_202(self): pass
    def test_invalid_ip_returns_400(self): pass
    def test_future_timestamp_returns_400(self): pass
    def test_same_source_dest_ip_returns_400(self): pass
    def test_missing_auth_returns_401(self): pass
    def test_expired_token_returns_401(self): pass
    def test_no_write_scope_returns_403(self): pass
    def test_rate_limit_exceeded_returns_429(self): pass
    def test_async_processing_triggered(self): pass
    def test_status_endpoint_shows_completed(self): pass
    def test_injected_event_indexed_to_elasticsearch(self): pass
```

---

## About the Applicant

**Zakir Jiwani** | GitHub: [JiwaniZakir](https://github.com/JiwaniZakir) | EST

My background for this project:

**Django/DRF (The Core Stack):**
- Built **aegis**, a personal intelligence platform using FastAPI/Celery — same async task queue pattern as Django Q2
- Built **evictionchatbot**, an AI legal chatbot with React/Vite frontend — full-stack experience relevant to the frontend token management UI
- Deep familiarity with REST API design, token auth, and input validation

**Security-Adjacent Context:**
- **Prowler** in my DevOps stack — AWS/GCP security scanning. I understand the threat intelligence domain at a systems level.
- **aegis** is explicitly a security/intelligence platform — I understand the value of multi-source threat data aggregation

**Testing Discipline:**
- 338 tests on aegis. 209 tests on sentinel. I write high-coverage test suites by default.
- My approach: every serializer field gets a test, every auth edge case gets a test, every async task gets a test.

**Why Event Collector Specifically:**
The core insight — that GreedyBear becomes dramatically more useful when it accepts data from any honeypot, not just T-Pot — is the right insight. Building a clean ingestion API that enterprises can rely on is exactly the kind of foundational infrastructure work I want to do. The combination of auth design, rate limiting, async processing, and data validation is technically interesting, not just mechanically repetitive.

---

## Questions for Mentors

1. **Auth approach:** Custom EventCollectorToken (as proposed) vs. extending DRF's built-in TokenAuthentication — any preference or existing precedent?
2. **Rate limiting:** Per-token (as proposed) or global? Is 1000/hour a reasonable default?
3. **Elasticsearch indexing:** Separate index for injected events, or merge with T-Pot events?
4. **Frontend scope:** Token management UI in GSoC scope, or defer and focus entirely on backend?
5. **Event enrichment:** What threat intelligence lookups should be included in the processing task for v1? (IP geolocation only, or also WHOIS?)

---

**Status:** Near-final draft — ready for mentor review
**Last Updated:** March 2026
**Submitted by:** Zakir Jiwani (JiwaniZakir)
