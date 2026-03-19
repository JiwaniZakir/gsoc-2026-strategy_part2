# GreedyBear Contribution & GSoC Execution Plan

## CRITICAL RULES (Mandatory - Non-Negotiable)

### Rule 1: Assignment Before Work
**You MUST get assignment/approval from maintainers BEFORE starting any coding work.**

- Do NOT fork and start coding immediately
- Comment on an issue saying "I'd like to work on this"
- Wait for a maintainer to assign you
- **Auto-Unassignment:** If you don't submit a draft PR within 1 week of assignment, you'll be auto-unassigned
- This rule prevents duplicate work and ensures mentorship

### Rule 2: Read All Documentation First
**Read and understand the project COMPLETELY before asking questions.**

- Clone the repo and run `./gbctl init --dev --elastic-local`
- Study `/docs` directory and README files
- Explore the codebase structure
- Run existing tests to understand testing patterns
- Install pre-commit hooks (`pre-commit install -c .github/.pre-commit-config.yaml`)
- **This saves mentors' time and demonstrates you're serious**

### Rule 3: Code Quality is Non-Negotiable
**All code must pass Ruff and tests. AI copy-paste gets instant rejection.**

- **Ruff Usage (MANDATORY):**
  ```bash
  ruff check . --fix
  ruff format .
  ```
- Run tests before committing
- PRs that bypass code quality are automatically rejected
- No exceptions for "I'll fix it later"

### Rule 4: PR Template Completion
**Every PR must have complete template filling or it's rejected.**

- Don't leave any template sections blank
- Include: what changed, why, how to test, screenshots if relevant
- Link related issues
- List breaking changes (if any)

### Rule 5: Early Draft PRs
**Create a DRAFT PR early even if incomplete — use it for tracking.**

- Mark as "Draft" (GitHub feature)
- Shows you're making progress
- Gets async feedback from mentors
- Better than radio silence for a week

---

## Pre-Contribution Checklist

Before contacting maintainers, ensure you have:

- [ ] Cloned repo: `git clone https://github.com/intelowlproject/GreedyBear.git`
- [ ] Set up dev environment: `./gbctl init --dev --elastic-local`
- [ ] Verified Docker: `docker ps` shows greedybear containers
- [ ] Created virtual environment:
  ```bash
  python3 -m venv venv
  source venv/bin/activate
  ```
- [ ] Installed pre-commit:
  ```bash
  pip install pre-commit
  pre-commit install -c .github/.pre-commit-config.yaml
  ```
- [ ] Read `/docs/ARCHITECTURE.md`, `/docs/CONTRIBUTING.md`
- [ ] Explored `/greedybear/api/` directory
- [ ] Read issue #1070, #1089, #1073 carefully
- [ ] Ran tests: `docker exec greedybear_uwsgi python3 manage.py test`
- [ ] Joined Discord and introduced yourself

---

## Phase 1: Onboarding & First Contribution (Weeks 1-2)

### Objectives
1. Prove you can follow process
2. Get familiar with codebase
3. Build confidence with maintainers
4. Fix a small issue or improve something

### Recommended Issues to Start With

**Issue #1083: None session_id Handling**
- **Difficulty:** Low (bug fix)
- **Scope:** Likely affects a few functions
- **Learning:** Cache/session handling in Django
- **Time:** 2-4 hours
- **Why:** Small, scoped, good test case for process

**Issue #1089: Feeds Filter Enhancement**
- **Difficulty:** Low (API feature)
- **Scope:** Add new filter to existing endpoint
- **Learning:** DRF filtering, serializers
- **Time:** 4-6 hours
- **Why:** Touch API code without major refactor

### Step-by-Step Process

1. **Pick Issue & Comment**
   ```
   Comment on issue: "I'd like to work on this for GSoC 2026.
   I've read the code and understand the scope.
   Here's my approach: [brief technical description]"
   ```

2. **Wait for Assignment**
   - Maintainers will reply or assign you
   - If no response in 24h, try Discord
   - Once assigned, the timer starts (1 week to draft PR)

3. **Create Feature Branch**
   ```bash
   git checkout develop
   git pull origin develop
   git checkout -b fix/issue-1083-session-id develop
   ```
   **Naming convention:** `fix/` or `feature/` prefix, reference issue number

4. **Make Changes**
   - Write the code
   - Follow Ruff style (it will auto-fix)
   - Add tests for new functionality
   - Keep commits small and logical

5. **Run Code Quality**
   ```bash
   # Auto-fix style issues
   ruff check . --fix
   ruff format .

   # Run pre-commit hooks
   pre-commit run --all-files

   # Run tests
   docker exec greedybear_uwsgi python3 manage.py test
   npm test  # if frontend changes
   ```

6. **Squash Commits**
   ```bash
   # Get commit count since branching
   git log --oneline develop..HEAD

   # Interactive rebase to squash
   git rebase -i develop
   # Mark all but first as 'squash'
   # Save and write final commit message
   ```

7. **Create Draft PR**
   - Push: `git push origin fix/issue-1083-session-id`
   - Create PR from GitHub UI
   - **Mark as DRAFT** (click "Convert to Draft")
   - Fill PR template **completely**
   - Link issue: "Fixes #1083"
   - Describe changes, testing approach, any edge cases

8. **Address Feedback**
   - Mentors will review
   - Make changes as requested
   - Re-run code quality
   - Push updates (same branch)

9. **Convert to Ready**
   - When satisfied: "Ready for review"
   - Maintainers merge to `develop`

### Checklist for First PR

- [ ] Branch from `develop` (not main)
- [ ] All changes use Ruff formatting
- [ ] Pre-commit hooks installed and passing
- [ ] Tests added and passing
- [ ] PR template filled completely
- [ ] Related issue linked
- [ ] Description explains why (not just what)
- [ ] No unrelated changes in PR

---

## Phase 2: Intermediate Contributions (Weeks 3-4)

### Objectives
1. Demonstrate consistency
2. Tackle slightly larger issues
3. Build influence with team
4. Show you can navigate codebase

### Target Issues

**Issue #1085: Cronjob Exception Handling**
- **Difficulty:** Medium
- **Scope:** Django Q2 task error handling
- **Learning:** Task queue, error patterns, logging
- **Time:** 6-8 hours
- **Touches:** `/cronjobs/` directory

**Issue #1087: Training Data Export**
- **Difficulty:** Medium
- **Scope:** API endpoint for data export
- **Learning:** Serialization, large data handling, CSV/JSON export
- **Time:** 8-10 hours
- **Touches:** `/api/`, database queries

### Approach

Same process as Phase 1, but:
- More complex code changes
- Deeper testing (edge cases)
- Better documentation
- Larger commits (still squashed to 1)

---

## Phase 3: GSoC Project - Event Collector API (Weeks 5-8)

### Project Overview

**Goal:** Design and implement a secure REST API endpoint that allows external applications (with proper authentication and rate limiting) to inject standardized event data into GreedyBear.

**Scope:** 175-350 hours (8-10 weeks full-time)

### Detailed Technical Approach

#### 3.1: API Endpoint Design

**Endpoint:** `POST /api/v1/events/collect/`

**Request Schema:**
```json
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
  "tags": ["brute-force", "ssh", "external-honeypot"],
  "source_identifier": "honeypot-eu-01"
}
```

**Response (Success 201):**
```json
{
  "id": "550e8400-e29b-41d4-a716-446655440000",
  "event_type": "ssh_brute_force",
  "timestamp": "2026-03-18T14:30:00Z",
  "status": "queued",
  "processing_url": "/api/v1/events/550e8400-e29b-41d4-a716-446655440000/status/"
}
```

**Error Response (400 Bad Request):**
```json
{
  "errors": {
    "source_ip": ["Invalid IPv4 address"],
    "severity": ["Must be one of: low, medium, high, critical"]
  }
}
```

#### 3.2: Authentication Implementation

**Token-Based Authentication:**

1. **Create APIToken Model** (in `/authentication/models.py`)
   ```python
   class EventCollectorToken(models.Model):
       key = models.CharField(max_length=40, unique=True)
       user = models.ForeignKey(User, on_delete=models.CASCADE)
       name = models.CharField(max_length=255)
       scopes = models.JSONField(default=list)  # ["events:write", ...]
       rate_limit = models.IntegerField(default=1000)  # per hour
       last_used = models.DateTimeField(null=True)
       created_at = models.DateTimeField(auto_now_add=True)
       expires_at = models.DateTimeField(null=True)
       is_active = models.BooleanField(default=True)

       def __str__(self):
           return f"{self.name} ({self.key[:8]}...)"
   ```

2. **Create Custom Permission** (in `/authentication/permissions.py`)
   ```python
   class IsEventCollector(BasePermission):
       message = "Access denied. Valid event:write scope required."

       def has_permission(self, request, view):
           # Only POST (create) requires special permission
           if request.method != 'POST':
               return True

           token = request.auth
           if not token:
               return False

           if hasattr(token, 'scopes'):
               return 'events:write' in token.scopes
           return False
   ```

3. **Create Custom Authentication Class** (in `/authentication/authentication.py`)
   ```python
   class EventCollectorTokenAuthentication(TokenAuthentication):
       keyword = 'EventToken'

       def authenticate(self, request):
           result = super().authenticate(request)
           if not result:
               return None

           user, token = result

           # Check expiration
           if token.expires_at and token.expires_at < timezone.now():
               raise AuthenticationFailed('Token has expired')

           # Check active status
           if not token.is_active:
               raise AuthenticationFailed('Token is inactive')

           # Update last used
           token.last_used = timezone.now()
           token.save(update_fields=['last_used'])

           return user, token
   ```

#### 3.3: Data Validation with Serializers

**Create EventCollectorSerializer** (in `/api/serializers.py`)
```python
from rest_framework import serializers
from django.core.validators import MinValueValidator, MaxValueValidator
from django.core.exceptions import ValidationError
import ipaddress

class EventCollectorSerializer(serializers.ModelSerializer):
    # Validate IPs
    source_ip = serializers.CharField()
    destination_ip = serializers.CharField()

    class Meta:
        model = Event
        fields = [
            'event_type', 'timestamp', 'source_ip', 'destination_ip',
            'source_port', 'destination_port', 'protocol', 'severity',
            'payload', 'tags', 'source_identifier'
        ]

    def validate_source_ip(self, value):
        try:
            ipaddress.ip_address(value)
        except ValueError:
            raise serializers.ValidationError(f"Invalid IP address: {value}")
        return value

    def validate_destination_ip(self, value):
        try:
            ipaddress.ip_address(value)
        except ValueError:
            raise serializers.ValidationError(f"Invalid IP address: {value}")
        return value

    def validate_event_type(self, value):
        valid_types = ['ssh_brute_force', 'http_scan', 'port_scan', ...]
        if value not in valid_types:
            raise serializers.ValidationError(
                f"Invalid event type. Must be one of: {valid_types}"
            )
        return value

    def validate_severity(self, value):
        if value not in ['low', 'medium', 'high', 'critical']:
            raise serializers.ValidationError("Invalid severity level")
        return value

    def validate(self, data):
        # Cross-field validation
        if data['source_port'] == data['destination_port']:
            raise serializers.ValidationError(
                "Source and destination ports cannot be identical"
            )
        return data
```

#### 3.4: ViewSet Implementation

**Create EventCollectorViewSet** (in `/api/views.py`)
```python
from rest_framework import viewsets, status
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from rest_framework.throttling import UserRateThrottle

class EventCollectorViewSet(viewsets.ModelViewSet):
    """
    API endpoint for injecting events from external sources.

    POST /api/v1/events/collect/
    """
    queryset = Event.objects.all()
    serializer_class = EventCollectorSerializer
    permission_classes = [IsAuthenticated, IsEventCollector]
    authentication_classes = [EventCollectorTokenAuthentication]
    throttle_classes = [UserRateThrottle]

    def perform_create(self, serializer):
        """
        Create event and queue for processing.
        """
        event = serializer.save(
            injected_by=self.request.user,
            status='pending'
        )

        # Queue for async processing
        from greedybear.cronjobs.tasks import process_collected_event
        queue_event_processing.delay(event.id)

    def create(self, request, *args, **kwargs):
        """Override create to return 202 Accepted instead of 201."""
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        self.perform_create(serializer)

        return Response(
            {
                'id': serializer.data['id'],
                'status': 'processing',
                'message': 'Event queued for processing'
            },
            status=status.HTTP_202_ACCEPTED
        )

    @action(detail=True, methods=['get'])
    def status(self, request, pk=None):
        """Check processing status of injected event."""
        event = self.get_object()
        return Response({
            'id': event.id,
            'status': event.status,  # pending, processing, completed, failed
            'created_at': event.created_at,
            'processed_at': event.processed_at,
            'error_message': event.error_message if event.status == 'failed' else None
        })
```

#### 3.5: URL Registration

**Register in `/api/urls.py`:**
```python
from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import EventCollectorViewSet

router = DefaultRouter()
router.register(r'events/collect', EventCollectorViewSet, basename='event-collect')

urlpatterns = [
    path('', include(router.urls)),
]
```

#### 3.6: Rate Limiting Configuration

**In `/configuration/settings.py`:**
```python
REST_FRAMEWORK = {
    'DEFAULT_THROTTLE_CLASSES': [
        'rest_framework.throttling.UserRateThrottle'
    ],
    'DEFAULT_THROTTLE_RATES': {
        'user': '1000/hour'  # Configurable per token
    }
}
```

#### 3.7: Cronjob for Event Processing

**Create `/cronjobs/event_collector.py`:**
```python
from django_q.tasks import async_task
from greedybear.models import Event

def process_collected_event(event_id):
    """
    Process injected event through enrichment pipeline.
    - Validate data
    - Enrich with threat intelligence
    - Index to Elasticsearch
    - Generate alerts if severity >= high
    """
    try:
        event = Event.objects.get(id=event_id)

        # 1. Data validation (secondary, serializer does primary)
        if not validate_event_schema(event):
            event.status = 'failed'
            event.error_message = 'Invalid schema'
            event.save()
            return

        # 2. Enrichment (threat intel lookups)
        enrich_event_with_threat_intel(event)

        # 3. Index to Elasticsearch
        index_event_to_elasticsearch(event)

        # 4. Generate alerts
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

#### 3.8: Testing Strategy

**Create `/tests/api/test_event_collector.py`:**

```python
from django.test import TestCase
from rest_framework.test import APIClient
from rest_framework import status
from greedybear.models import Event, User
from authentication.models import EventCollectorToken

class EventCollectorAPITestCase(TestCase):

    def setUp(self):
        self.client = APIClient()
        self.user = User.objects.create_user(
            username='testuser',
            email='test@example.com'
        )
        self.token = EventCollectorToken.objects.create(
            user=self.user,
            key='test-token-12345',
            name='Test Token',
            scopes=['events:write']
        )
        self.url = '/api/v1/events/collect/'

    def test_create_event_success(self):
        """Valid event creation returns 202 Accepted."""
        data = {
            'event_type': 'ssh_brute_force',
            'timestamp': '2026-03-18T14:30:00Z',
            'source_ip': '192.168.1.100',
            'destination_ip': '10.0.0.1',
            'source_port': 54321,
            'destination_port': 22,
            'protocol': 'ssh',
            'severity': 'high',
            'payload': {},
            'tags': ['ssh']
        }

        self.client.credentials(HTTP_AUTHORIZATION=f'EventToken {self.token.key}')
        response = self.client.post(self.url, data, format='json')

        self.assertEqual(response.status_code, status.HTTP_202_ACCEPTED)
        self.assertEqual(response.data['status'], 'processing')
        self.assertIn('id', response.data)

    def test_create_event_invalid_ip(self):
        """Invalid IP returns 400."""
        data = {
            'event_type': 'ssh_brute_force',
            'source_ip': 'not-an-ip',
            # ... other fields
        }

        self.client.credentials(HTTP_AUTHORIZATION=f'EventToken {self.token.key}')
        response = self.client.post(self.url, data, format='json')

        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        self.assertIn('source_ip', response.data['errors'])

    def test_create_event_no_auth(self):
        """Request without token returns 401."""
        data = {'event_type': 'ssh_brute_force'}
        response = self.client.post(self.url, data, format='json')

        self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)

    def test_create_event_no_write_scope(self):
        """Token without events:write scope returns 403."""
        limited_token = EventCollectorToken.objects.create(
            user=self.user,
            key='limited-token',
            scopes=['events:read']  # No write permission
        )

        data = {'event_type': 'ssh_brute_force'}
        self.client.credentials(HTTP_AUTHORIZATION=f'EventToken {limited_token.key}')
        response = self.client.post(self.url, data, format='json')

        self.assertEqual(response.status_code, status.HTTP_403_FORBIDDEN)

    def test_rate_limiting(self):
        """Rate limiting enforces token's rate_limit value."""
        # Create token with low rate limit
        limited_token = EventCollectorToken.objects.create(
            user=self.user,
            key='limited-rate-token',
            rate_limit=2  # Only 2 requests per hour
        )

        # Generate valid request data
        data = {
            'event_type': 'ssh_brute_force',
            'timestamp': '2026-03-18T14:30:00Z',
            'source_ip': '192.168.1.100',
            'destination_ip': '10.0.0.1',
            'source_port': 54321,
            'destination_port': 22,
            'protocol': 'ssh',
            'severity': 'high'
        }

        self.client.credentials(HTTP_AUTHORIZATION=f'EventToken {limited_token.key}')

        # First 2 requests should succeed
        for i in range(2):
            response = self.client.post(self.url, data, format='json')
            self.assertEqual(response.status_code, status.HTTP_202_ACCEPTED)

        # Third request should be rate limited
        response = self.client.post(self.url, data, format='json')
        self.assertEqual(response.status_code, status.HTTP_429_TOO_MANY_REQUESTS)

    def test_event_status_endpoint(self):
        """Status endpoint shows event processing state."""
        # Create an event
        event = Event.objects.create(
            event_type='ssh_brute_force',
            source_ip='192.168.1.100',
            destination_ip='10.0.0.1',
            status='processing'
        )

        self.client.credentials(HTTP_AUTHORIZATION=f'EventToken {self.token.key}')
        response = self.client.get(f'{self.url}{event.id}/status/')

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data['status'], 'processing')
```

#### 3.9: Documentation

**OpenAPI Schema Auto-Generated by DRF**

Create `/docs/EVENT_COLLECTOR_API.md` for detailed documentation:

```markdown
# Event Collector API

## Overview
Allows external services to inject standardized event data into GreedyBear.

## Authentication
Use token-based authentication. Request an API token from an admin.

```bash
curl -X POST https://api.greedybear.io/api/v1/events/collect/ \
  -H "Authorization: EventToken YOUR_API_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{...event JSON...}'
```

## Request Schema
[Detailed field descriptions]

## Response Status Codes
- 202 Accepted: Event queued for processing
- 400 Bad Request: Invalid data
- 401 Unauthorized: No token
- 403 Forbidden: Invalid scopes
- 429 Too Many Requests: Rate limited

## Examples
[cURL, Python, JavaScript examples]
```

### Timeline: Phase 3 (8-10 weeks)

- **Week 1:** API design, models, serializers
- **Week 2:** Authentication, permissions, token management
- **Week 3:** ViewSet implementation, URL routing
- **Week 4:** Cronjob for processing, enrichment pipeline
- **Week 5:** Comprehensive testing (unit + integration)
- **Week 6:** Rate limiting, error handling, edge cases
- **Week 7:** Documentation, OpenAPI schema, examples
- **Week 8:** Code review, refinements, deployment
- **Week 9:** Performance testing, optimization
- **Week 10:** Final integration, demo, submission

### Milestones & Deliverables

1. **Milestone 1 (Week 2):** Draft PR with API design + models
   - Design document
   - Models and migrations
   - Serializers with validation
   - Unit tests for serializers

2. **Milestone 2 (Week 4):** Authentication & ViewSet
   - Token authentication class
   - Permission classes
   - EventCollectorViewSet
   - Integration tests
   - Draft PR

3. **Milestone 3 (Week 6):** Processing Pipeline
   - Cronjob tasks
   - Rate limiting
   - Error handling
   - Status endpoint
   - Tests for all scenarios
   - Draft PR

4. **Milestone 4 (Week 8):** Documentation & Polish
   - OpenAPI schema (auto)
   - Usage documentation
   - Example scripts
   - Performance optimization
   - Final PR for review

5. **Milestone 5 (Week 10):** Deployment & Demo
   - Integration into production
   - Monitoring/alerting
   - Demo script
   - Blog post / announcement

---

## Code Style Reminders

### Ruff Usage (Every Commit)

```bash
# Before committing, ALWAYS run:
ruff check . --fix        # Fix formatting issues
ruff format .             # Format code
pre-commit run --all-files # Validate hooks

# Commit
git add .
git commit -m "Add event collector API endpoint"
```

### Git Workflow Recap

```bash
# Start new feature
git checkout develop
git pull origin develop
git checkout -b feature/event-collector-api develop

# Make changes, test, format...

# Squash commits
git rebase -i develop
# Mark all but first as 'squash'

# Push
git push origin feature/event-collector-api

# Open PR on GitHub
# Mark as DRAFT until ready
# Fill template completely
```

### PR Template Checklist

- [ ] **What changed:** Clear description of modifications
- [ ] **Why:** Context and rationale
- [ ] **How tested:** Manual and automated test results
- [ ] **Breaking changes:** List any, if applicable
- [ ] **Related issues:** Link with "Fixes #XXX"
- [ ] **Screenshots:** If UI changes
- [ ] **Checklist:**
  - Tests pass
  - Ruff passes
  - No hardcoded values
  - Documentation updated
  - PR is not too large (aim <500 lines)

---

## Mentorship & Communication

### Discord Channel
- **Where:** Honeynet GSoC 2026 channel
- **When:** Async, but expect ~24h response
- **What:** Questions, blockers, progress updates
- **Tone:** Professional, detailed, respectful

### Regular Check-ins
- **Weekly:** Brief status (what done, what next, blockers)
- **As-needed:** Deeper technical discussions
- **PR Reviews:** Usually 2-3 days turnaround

### Best Practices for Communication

1. **Ask Good Questions**
   - "I read X, tried Y, got Z error. What am I missing?"
   - NOT: "How do I make an API?"

2. **Share Context**
   - Link to code you're looking at
   - Describe what you've tried
   - Paste error messages

3. **Show Work**
   - Push draft PR early
   - Use GitHub comments for detailed discussions
   - Reference commits

4. **Respect Time**
   - Mentors are volunteers
   - Batch questions if possible
   - Do research first

---

## Avoiding Auto-Rejection

### Code Quality

- [ ] Ruff passes (no style violations)
- [ ] Tests pass (all new code tested)
- [ ] No AI copy-paste (manual code review)
- [ ] No commented-out code
- [ ] No debugging prints

### PR Standards

- [ ] Template filled completely
- [ ] Linked to issue
- [ ] Description explains intent, not just changes
- [ ] Commits squashed (1 commit = 1 logical change)
- [ ] Branch from `develop` (not main)
- [ ] No unrelated changes

### Process Adherence

- [ ] Got assignment before starting
- [ ] Draft PR within 1 week
- [ ] Responded to review feedback
- [ ] Pulled latest develop before submitting
- [ ] Read all relevant docs first

---

## Success Metrics

By end of GSoC, you should have:

1. **Merged 8-12 PRs** across phases 1-3
2. **Event Collector API fully implemented** with:
   - Secure token authentication
   - Rate limiting
   - Comprehensive validation
   - >80% test coverage
   - Full documentation
3. **Demonstrated ownership** (mentors trust your judgment)
4. **Contributed beyond GSoC scope** (extra features, optimizations)
5. **Left codebase in better state** than found it

---

**Document Version:** 1.0
**Created:** March 18, 2026
