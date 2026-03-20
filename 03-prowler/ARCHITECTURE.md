# prowler — Codebase Architecture

**Repo:** https://github.com/prowler-cloud/prowler
**Language:** Python 3.9+
**Stars:** ~11,000+

---

## Directory Structure

```
prowler/
├── prowler/
│   ├── __main__.py             # CLI entry point
│   ├── config/                 # Configuration management
│   ├── lib/                    # Core library
│   │   ├── check/              # Check base classes, models
│   │   │   ├── models.py       # Check, CheckResult, Severity, etc.
│   │   │   └── compliance/     # Compliance framework data
│   │   ├── outputs/            # Output formatters (JSON, CSV, HTML, OCSF)
│   │   ├── scan/               # Scan orchestration
│   │   └── utils/              # Utilities
│   ├── providers/
│   │   ├── aws/
│   │   │   ├── aws_provider.py     # AWS provider setup, credential handling
│   │   │   ├── lib/
│   │   │   │   └── audit_info/     # Account info, region listing
│   │   │   └── services/
│   │   │       ├── ec2/
│   │   │       │   ├── ec2_client.py       # boto3 client
│   │   │       │   ├── ec2_service.py      # API calls, data models
│   │   │       │   └── checks/
│   │   │       │       ├── ec2_instance_imdsv2_enabled.py
│   │   │       │       └── ec2_instance_public_ip.py
│   │   │       ├── iam/
│   │   │       ├── s3/
│   │   │       └── ...
│   │   ├── azure/
│   │   │   ├── azure_provider.py
│   │   │   └── services/
│   │   │       ├── entra/          # Azure AD / Entra ID
│   │   │       ├── keyvault/
│   │   │       ├── monitor/
│   │   │       └── ...
│   │   ├── gcp/
│   │   │   ├── gcp_provider.py
│   │   │   └── services/
│   │   │       ├── compute/
│   │   │       ├── dns/
│   │   │       ├── iam/
│   │   │       ├── logging/
│   │   │       └── ...
│   │   ├── github/
│   │   │   ├── github_provider.py
│   │   │   └── services/
│   │   │       └── repos/
│   │   │           ├── repos_client.py
│   │   │           ├── repos_service.py
│   │   │           └── checks/
│   │   │               ├── repos_dismiss_stale_reviews_on_push.py
│   │   │               └── ...
│   │   └── kubernetes/
│   └── tests/ → see below
├── tests/
│   ├── providers/
│   │   ├── aws/services/        # Mirrors prowler/providers/aws/services/
│   │   ├── azure/services/
│   │   ├── gcp/services/
│   │   └── github/services/
│   └── lib/
├── compliance/                  # CIS, NIST, SOC2 JSON compliance files
├── docs/
├── requirements.txt
├── ruff.toml                    # Ruff linting config (STRICT)
├── pyproject.toml
└── .github/
    └── workflows/
        ├── test.yml             # pytest on Python 3.9–3.12
        └── lint.yml             # ruff check
```

---

## Check Architecture

### Check Base Class

```python
# prowler/lib/check/models.py

class Check:
    """Base class for all Prowler checks."""

    # Metadata (set via class attributes or Pydantic CheckMetadata)
    CheckID: str          # e.g., "ec2_instance_imdsv2_enabled"
    CheckTitle: str       # Human-readable title
    CheckType: list       # e.g., ["Software and Configuration Checks"]
    ServiceName: str      # e.g., "ec2"
    SubServiceName: str
    ResourceIdTemplate: str
    Severity: Severity    # critical, high, medium, low, informational
    ResourceType: str
    Description: str
    Risk: str
    RelatedUrl: str
    Remediation: Remediation

    def execute(self) -> list[CheckResult]:
        """Override this. Return list of CheckResult."""
        raise NotImplementedError


class CheckResult:
    """Result of a single check evaluation."""
    status: str                    # "PASS", "FAIL", "WARNING", "MANUAL"
    status_extended: str           # Human-readable description of finding
    resource_id: str               # Resource identifier
    resource_arn: Optional[str]    # ARN or equivalent
    resource_name: Optional[str]
    resource_type: Optional[str]
    region: Optional[str]
    account_id: Optional[str]
    # ... provider-specific fields
```

### Provider Client Pattern

```python
# prowler/providers/aws/services/ec2/ec2_client.py
from prowler.providers.aws.services.ec2.ec2_service import EC2
from prowler.providers.common.provider import Provider

ec2_client = EC2(Provider.get_global_provider())
```

```python
# prowler/providers/aws/services/ec2/ec2_service.py
import boto3
from pydantic import BaseModel

class EC2:
    def __init__(self, provider):
        self.session = provider.session.current_session
        self.instances = {}
        self.__threading_call__(self.__describe_instances__)

    def __describe_instances__(self, regional_client):
        response = regional_client.describe_instances()
        # parse response, populate self.instances
```

---

## Adding a New Check — Step by Step

1. **Create check file:**
```bash
touch prowler/providers/<provider>/services/<service>/checks/<service>_<check_name>.py
```

2. **Implement the Check class** (extend Check, implement `execute()`)

3. **Create test file:**
```bash
touch tests/providers/<provider>/services/<service>/checks/<service>_<check_name>_test.py
```

4. **Write tests** with mocked clients (moto for AWS, unittest.mock for Azure/GCP)

5. **Register the check** if there's a registry (check existing checks in the service for pattern)

---

## Build and Test Commands

```bash
# Install (development)
pip install -e ".[all]"
# or:
pip install -r requirements.txt

# Run all tests
pytest tests/ -v -q

# Run tests for specific provider
pytest tests/providers/gcp/ -v
pytest tests/providers/aws/services/ec2/ -v

# Run tests matching a pattern
pytest tests/ -k "dns" -v

# Lint (MUST PASS before PR)
ruff check prowler/
ruff check tests/

# Format
ruff format prowler/ tests/

# Run prowler CLI (requires valid cloud credentials)
prowler aws --check ec2_instance_imdsv2_enabled
prowler gcp --check dns_managed_zone_logging_enabled
prowler github --check repos_dismiss_stale_reviews_on_push
```

---

## AWS Testing with Moto

```python
import boto3
from moto import mock_aws
from unittest.mock import patch
from prowler.providers.aws.services.ec2.ec2_service import EC2

@mock_aws
def test_ec2_instance():
    # Set up mock AWS resources
    ec2_resource = boto3.resource("ec2", region_name="us-east-1")
    ec2_resource.create_instances(ImageId="ami-12345", MinCount=1, MaxCount=1)

    # Run service
    from prowler.providers.aws.lib.audit_info.models import AWSAuditInfo
    aws_provider = ... # mock provider
    ec2 = EC2(aws_provider)

    assert len(ec2.instances) == 1
```

## Azure/GCP Testing with unittest.mock

```python
from unittest.mock import MagicMock, patch
from prowler.providers.gcp.services.dns.checks.dns_managed_zone_logging_enabled import (
    dns_managed_zone_logging_enabled,
)

class Test_dns_managed_zone_logging_enabled:
    def test_zone_logging_enabled(self):
        mock_zone = MagicMock()
        mock_zone.id = "zone-1"
        mock_zone.dns_logging_enabled = True

        with patch(
            "prowler.providers.gcp.services.dns.checks."
            "dns_managed_zone_logging_enabled.dns_client"
        ) as mock_client:
            mock_client.managed_zones = [mock_zone]
            check = dns_managed_zone_logging_enabled()
            result = check.execute()

        assert result[0].status == "PASS"
```

---

## Compliance Framework Files

Located in `compliance/` directory. JSON format. Each check maps to compliance controls:
```json
{
  "Framework": "CIS-GCP",
  "Version": "1.3.0",
  "Requirements": [
    {
      "Id": "3.3",
      "Description": "Ensure that DNS logging is enabled for all VPC Networks",
      "Checks": ["dns_managed_zone_logging_enabled"]
    }
  ]
}
```
