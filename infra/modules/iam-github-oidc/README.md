# GitHub OIDC IAM Module

This module establishes a trust relationship between GitHub Actions and AWS using OpenID Connect (OIDC).

## Why OIDC?
Traditional CI/CD setups require storing long-lived AWS Access Keys in GitHub Secrets. If these keys are leaked, they can be used from anywhere. OIDC is a **Zero-Trust** approach:
1. GitHub provides a short-lived token to the runner.
2. The runner exchanges this token for temporary AWS credentials.
3. AWS validates that the request is coming from the specific GitHub repository and branch we've allowed.

## Usage
```hcl
module "github_oidc" {
  source = "../../modules/iam-github-oidc"

  github_repo = "mitcha871/sample-platform-ai"
  role_name   = "github-actions-deployer"
}
```
