# prowler — Aggressive 5-Day Contribution Plan (Mar 19–23)

**Target: 8–10 PRs in 5 days | Strategy: New checks (each check = 1 PR)**

## Prowler Check Structure

Every new check follows this exact pattern:

```
prowler/providers/aws/services/<service>/
├── <service>_client.py          # boto3 client setup
├── <service>_service.py         # API calls, data models
└── checks/
    └── <service>_<check_name>.py  # The check logic

tests/providers/aws/services/<service>/
└── checks/
    └── <service>_<check_name>_test.py  # Tests (required)
```

A new check PR typically includes:
1. `checks/<service>_<check_name>.py` — check implementation
2. `tests/.../<service>_<check_name>_test.py` — unit tests
3. `prowler/providers/<provider>/lib/audit_info/audit_info.py` — register check if needed

---

## Day 1 — March 19: Setup + PR #1

### Environment Setup (07:00–09:00)
```bash
git clone https://github.com/prowler-cloud/prowler
cd prowler
pip install -e ".[all]"  # or pip install -r requirements.txt
pytest tests/ -x -q --tb=short  # confirm tests pass
ruff check prowler/  # confirm linting
```

### PR #1 (09:00–13:00): Issue #8660 — GitHub Check: Dismiss Stale Reviews
**Target:** New check ensuring GitHub branch protection dismisses stale reviews on push

**Implementation:**
```python
# prowler/providers/github/services/repos/checks/repos_dismiss_stale_reviews_on_push.py

from prowler.lib.check.models import Check, CheckResult
from prowler.providers.github.services.repos.repos_client import repos_client

class repos_dismiss_stale_reviews_on_push(Check):
    def execute(self):
        findings = []
        for repo in repos_client.repositories.values():
            branch_protection = repo.branch_protection
            report = CheckResult(
                status="PASS" if (
                    branch_protection
                    and branch_protection.dismiss_stale_reviews
                ) else "FAIL",
                status_extended=f"Repository {repo.name} {'dismisses' if ... else 'does not dismiss'} stale reviews on push.",
                resource_id=repo.full_name,
                resource_arn=repo.html_url,
            )
            findings.append(report)
        return findings
```

Write corresponding test with mocked GitHub API responses.

```bash
git checkout -b feat/github-dismiss-stale-reviews-check
# implement + test
ruff check prowler/providers/github/  # lint
pytest tests/providers/github/ -v  # test
gh pr create --title "feat(github): add check for stale review dismissal on branch protection" \
  --body "Closes #8660 — adds check repos_dismiss_stale_reviews_on_push that verifies branch protection policies require dismissal of stale approvals when new commits are pushed."
```

### Community Outreach (13:00–15:00)
- Post in Slack (#gsoc or #contributors) — reference your existing merged PRs
- Join any active GitHub Discussions about GSoC 2026

---

## Day 2 — March 20: PR #2 — GCP DNS Logging Check

**Target:** Issue #7287 — GCP Check: Ensure Cloud DNS Logging is enabled for all VPC Networks

**Implementation:**
```python
# prowler/providers/gcp/services/dns/checks/dns_managed_zone_logging_enabled.py

from prowler.lib.check.models import Check, CheckResult
from prowler.providers.gcp.services.dns.dns_client import dns_client

class dns_managed_zone_logging_enabled(Check):
    def execute(self):
        findings = []
        for zone in dns_client.managed_zones:
            enabled = zone.dns_logging_enabled
            report = CheckResult(
                status="PASS" if enabled else "FAIL",
                status_extended=f"Cloud DNS managed zone {zone.name} {'has' if enabled else 'does not have'} query logging enabled.",
                resource_id=zone.id,
                resource_name=zone.name,
                project_id=zone.project_id,
                location=zone.location,
            )
            findings.append(report)
        return findings
```

---

## Day 3 — March 21: PR #3 — Azure CAE Check

**Target:** Issue #10148 — Azure Check: Continuous Access Evaluation in Conditional Access

**Implementation:**
```python
# prowler/providers/azure/services/entra/checks/entra_conditional_access_cae_enabled.py
# Check that at least one Conditional Access policy enforces CAE

from prowler.lib.check.models import Check, CheckResult
from prowler.providers.azure.services.entra.entra_client import entra_client

class entra_conditional_access_cae_enabled(Check):
    def execute(self):
        findings = []
        for subscription, tenants in entra_client.tenants.items():
            # Check Conditional Access policies for CAE enforcement
            cae_enabled = any(
                policy.session_controls
                and policy.session_controls.get("continuousAccessEvaluation", {}).get("mode") == "strictEnforced"
                for policy in entra_client.conditional_access_policies.get(subscription, [])
            )
            report = CheckResult(
                status="PASS" if cae_enabled else "FAIL",
                status_extended=f"Subscription {subscription} {'has' if cae_enabled else 'does not have'} Continuous Access Evaluation enforced.",
                resource_id=subscription,
            )
            findings.append(report)
        return findings
```

### Also Day 3: Engage Mentors
- Post proposal outline in Slack and GitHub Discussions
- Ask about which checks the team is prioritizing

---

## Day 4 — March 22: PR #4 — Redis Env Var Config

**Target:** Issue #8832 — Allow Redis connection scheme via env var

**Implementation:**
```python
# In prowler/lib/outputs/finding_output.py or wherever Redis is configured
# Add PROWLER_REDIS_SCHEME env var support:

import os

def get_redis_url():
    scheme = os.environ.get("PROWLER_REDIS_SCHEME", "redis")  # supports "redis" or "rediss"
    host = os.environ.get("PROWLER_REDIS_HOST", "localhost")
    port = os.environ.get("PROWLER_REDIS_PORT", "6379")
    return f"{scheme}://{host}:{port}"
```

---

## Day 5 — March 23: PR #5 + Polish

### PR #5: Additional check or test improvements
Pick any remaining good-first-issue or write tests for an existing check that lacks coverage.

### Final Steps
- Address all open PR review feedback
- Ensure all PRs pass CI (ruff, pytest)
- Complete proposal draft to 80%

---

## PR Summary Table

| Day | PR | Issue | Check Type |
|-----|-----|-------|-----------|
| Mar 19 | #1 | #8660 | GitHub: dismiss stale reviews |
| Mar 20 | #2 | #7287 | GCP: DNS logging |
| Mar 21 | #3 | #10148 | Azure: CAE enforcement |
| Mar 22 | #4 | #8832 | Config: Redis SSL env var |
| Mar 23 | #5 | TBD | Additional check or tests |

**Key insight:** Each new check is a self-contained PR with implementation + tests. This is the highest-value contribution type for prowler. With Zakir's existing merge history, reviewers already trust the pattern.

---

## Prowler Check Quality Requirements

Every PR **must** have:
- [ ] Check implementation in correct provider/service path
- [ ] Unit tests with mocked API responses (moto for AWS, unittest.mock for Azure/GCP)
- [ ] `ruff check` passes (zero violations)
- [ ] `pytest tests/providers/<provider>/services/<service>/` passes
- [ ] PR description explains: check name, what it detects, compliance mapping (NIST, CIS, etc.)
- [ ] OCSF-compatible finding output format
