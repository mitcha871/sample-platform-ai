module "ecr_backend" {
  source = "../../modules/ecr"
  name   = "sample-platform/backend"

  tags = {
    Environment = "Dev"
  }
}

module "ecr_frontend" {
  source = "../../modules/ecr"
  name   = "sample-platform/frontend"

  tags = {
    Environment = "Dev"
  }
}

output "ecr_backend_url" {
  value = module.ecr_backend.repository_url
}

output "ecr_frontend_url" {
  value = module.ecr_frontend.repository_url
}
