module "github_oidc" {
  source = "../../modules/iam-github-oidc"

  github_repo = "mitcha871/sample-platform-ai"
  role_name   = "github-actions-deployer-dev"

  tags = {
    Environment = "Dev"
  }
}

output "github_actions_role_arn" {
  value = module.github_oidc.role_arn
}
