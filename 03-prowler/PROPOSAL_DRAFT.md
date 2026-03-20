# GSoC 2026 Proposal — prowler-cloud/prowler

**Applicant:** Zakir Jiwani | GitHub: JiwaniZakir | jiwzakir@gmail.com
**Organization:** Prowler Cloud
**Project Title:** Expanding Multi-Cloud Security Coverage: GitHub, GCP, and Azure Checks
**Duration:** 350 hours (large project)
**Mentors:** TBD — targeting pumasecurity, jfuentesmontes

---

## Synopsis

Prowler's check coverage for GitHub (new provider), GCP, and Azure lags behind its AWS coverage. The open issue backlog contains 20+ requests for new checks across these providers — each one a concrete security control that enterprises need but can't currently verify with prowler. This project delivers 30–35 new checks systematically, along with compliance framework mappings and a programmatic check generator to accelerate future contributions.

---

## Background and Motivation

### Why Check Coverage Matters

Prowler is used by security teams to continuously verify their cloud posture. Every missing check is a blind spot. When a security team runs `prowler -p github` and gets no coverage for branch protection policies, they either (a) miss the risk entirely or (b) have to use a separate tool — defeating the purpose of a unified CSPM.

The open issue backlog (#8660, #7287, #10148, #7630, and dozens more) represents real security controls that users are requesting. These aren't nice-to-have features — they're the core function of the tool.

### Why I'm the Right Contributor

I already have merged PRs in prowler. I've navigated the check structure, understand the code patterns (Check class, CheckResult, provider clients, moto-based tests), and have received positive review feedback from the core team. This isn't a "getting started" project for me — it's a continuation of existing work.

---

## Deliverables

### Deliverable 1: GitHub Provider Checks (Weeks 1–6)
Prowler has a GitHub provider but limited check coverage. New checks:

| Check Name | CIS/NIST Mapping | Issue |
|-----------|-----------------|-------|
| `repos_dismiss_stale_reviews_on_push` | CIS 1.1.2 | #8660 |
| `repos_require_pr_before_merge` | CIS 1.1.1 | — |
| `repos_branch_protection_enabled` | CIS 1.1.3 | — |
| `repos_secret_scanning_enabled` | CIS 1.2.1 | — |
| `repos_code_scanning_enabled` | CIS 1.2.2 | — |
| `org_two_factor_required` | CIS 1.3.1 | — |
| `org_default_permission_read_only` | CIS 1.3.5 | — |
| `org_members_cannot_change_repo_visibility` | CIS 1.3.7 | — |
| `actions_secrets_not_exposed_in_logs` | CIS 1.4.1 | — |
| `actions_allowed_actions_restrict_external` | CIS 1.4.3 | — |

**~10 GitHub checks** with full test coverage.

### Deliverable 2: GCP Checks (Weeks 7–10)

| Check Name | CIS Mapping | Issue |
|-----------|------------|-------|
| `dns_managed_zone_logging_enabled` | CIS GCP 3.3 | #7287 |
| `compute_firewall_no_unrestricted_rdp` | CIS GCP 3.6 | — |
| `compute_firewall_no_unrestricted_ssh` | CIS GCP 3.7 | — |
| `iam_no_service_account_key_user` | CIS GCP 1.8 | — |
| `storage_bucket_uniform_access_enabled` | CIS GCP 5.2 | — |
| `logging_log_metric_filter_audit_config_changes` | CIS GCP 2.5 | — |
| `kms_crypto_key_rotation_period_90_days` | CIS GCP 1.10 | — |
| `sql_database_flag_cross_db_ownership_chaining` | CIS GCP 6.2.1 | — |

**~8 GCP checks** with full test coverage.

### Deliverable 3: Azure Checks (Weeks 11–13)

| Check Name | CIS Mapping | Issue |
|-----------|------------|-------|
| `entra_conditional_access_cae_enabled` | CIS Azure 1.2.x | #10148 |
| `entra_user_mfa_enabled_for_all_admins` | CIS Azure 1.1.2 | — |
| `defender_for_cloud_enabled_all_subscriptions` | CIS Azure 2.1.1 | — |
| `keyvault_key_expiration_set` | CIS Azure 8.4 | — |
| `monitor_activity_log_alert_create_update_nsg` | CIS Azure 5.2.3 | — |
| `storage_infrastructure_encryption_enabled` | CIS Azure 3.1.6 | — |

**~6 Azure checks** with full test coverage.

### Deliverable 4: Check Generator Tool (Week 14)
A CLI tool that scaffolds new check boilerplate:

```bash
# Usage:
prowler generate-check --provider gcp --service compute --name firewall_no_rdp

# Generates:
# prowler/providers/gcp/services/compute/checks/compute_firewall_no_rdp.py (with template)
# tests/providers/gcp/services/compute/checks/compute_firewall_no_rdp_test.py (with template)
```

This dramatically lowers the barrier for future contributors writing new checks.

---

## Technical Approach

### Check Implementation Pattern (Example)

```python
# prowler/providers/gcp/services/dns/checks/dns_managed_zone_logging_enabled.py

from prowler.lib.check.models import Check, CheckResult
from prowler.providers.gcp.services.dns.dns_client import dns_client

class dns_managed_zone_logging_enabled(Check):
    """Ensure Cloud DNS logging is enabled for all VPC networks."""

    def execute(self):
        findings = []
        for managed_zone in dns_client.managed_zones:
            status = "PASS" if managed_zone.dns_logging_enabled else "FAIL"
            report = CheckResult(
                status=status,
                status_extended=(
                    f"Cloud DNS managed zone {managed_zone.name} has query logging enabled."
                    if managed_zone.dns_logging_enabled
                    else f"Cloud DNS managed zone {managed_zone.name} does not have query logging enabled."
                ),
                resource_id=managed_zone.id,
                resource_name=managed_zone.name,
                resource_type="ManagedZone",
                project_id=managed_zone.project_id,
                location=managed_zone.location,
            )
            findings.append(report)
        return findings
```

### Test Pattern (Example)

```python
# tests/providers/gcp/services/dns/checks/dns_managed_zone_logging_enabled_test.py

from unittest.mock import MagicMock, patch
from prowler.providers.gcp.services.dns.checks.dns_managed_zone_logging_enabled import (
    dns_managed_zone_logging_enabled,
)

class Test_dns_managed_zone_logging_enabled:
    def test_managed_zone_logging_enabled(self):
        mock_zone = MagicMock()
        mock_zone.id = "zone-1"
        mock_zone.name = "my-zone"
        mock_zone.dns_logging_enabled = True
        mock_zone.project_id = "my-project"
        mock_zone.location = "global"

        with patch(
            "prowler.providers.gcp.services.dns.checks.dns_managed_zone_logging_enabled.dns_client"
        ) as mock_client:
            mock_client.managed_zones = [mock_zone]
            check = dns_managed_zone_logging_enabled()
            result = check.execute()

        assert len(result) == 1
        assert result[0].status == "PASS"

    def test_managed_zone_logging_disabled(self):
        mock_zone = MagicMock()
        mock_zone.dns_logging_enabled = False
        # ... setup and assertions
        assert result[0].status == "FAIL"
```

---

## Timeline

| Week | Milestone |
|------|-----------|
| 1–2 | Community bonding: audit open issues, plan check list, align with mentors |
| 3–4 | GitHub checks 1–5 (branch protection, secret scanning) |
| 5–6 | GitHub checks 6–10 (org security, Actions) |
| 7–8 | GCP checks 1–4 (DNS, firewall, IAM) |
| 9–10 | GCP checks 5–8 (storage, logging, KMS, SQL) |
| 11–12 | Azure checks (CAE, MFA, Defender, KeyVault, Monitor, Storage) |
| 13 | Check generator tool implementation |
| 14 | Documentation, compliance mappings review, final PRs |

---

## About Me

I have merged PRs in prowler-cloud/prowler already. I understand the check structure, code style, testing patterns, and reviewer expectations. I am not starting from zero here.

**Specific prowler experience:**
- Already navigated the provider/service/check directory structure
- Received and addressed code review feedback from core team
- Understand Ruff linting requirements, pytest + moto testing patterns, CheckResult format

**Broader background:**
- Python/ML engineering with transformers, LangChain, LangGraph
- Cloud security knowledge (AWS, Azure, GCP) directly applicable to writing new checks
- aegis (personal intelligence platform) and spectra (RAG eval toolkit) — demonstrates Python system design

**Why this project:**
Security coverage gaps are not abstract engineering problems — they're real blind spots that security teams live with every day. I want to close them systematically.
