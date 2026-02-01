module "observability" {
  source = "../../modules/observability"

  cluster_name      = module.eks.cluster_name
  vpc_id            = module.vpc.vpc_id
  oidc_provider_arn = module.eks.oidc_provider_arn

  tags = {
    Environment = "Dev"
  }
}

output "log_bucket" {
  value = module.observability.log_bucket_name
}
