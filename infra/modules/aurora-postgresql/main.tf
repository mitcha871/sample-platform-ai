# Leverage the official Aurora module to handle complex cluster logic
module "aurora" {
  source  = "terraform-aws-modules/rds-aurora/aws"
  version = "~> 9.0"

  name           = var.name
  engine         = "aurora-postgresql"
  engine_version = var.engine_version
  master_username = var.master_username
  database_name   = var.database_name

  vpc_id               = var.vpc_id
  db_subnet_group_name = var.name
  subnets              = var.subnets
  security_group_rules = {
    ingress_access = {
      source_node_security_group_ids = var.allowed_security_group_ids
    }
  }

  monitoring_interval = 60
  apply_immediately   = true
  skip_final_snapshot = true

  serverlessv2_scaling_configuration = var.serverlessv2_scaling_configuration

  instances = var.instances

  # Global cluster settings
  is_primary_cluster        = !var.is_global_cluster # Simplified for now
  global_cluster_identifier = var.global_cluster_identifier

  tags = var.tags
}

output "cluster_endpoint" {
  value = module.aurora.cluster_endpoint
}

output "cluster_resource_id" {
  value = module.aurora.cluster_resource_id
}

output "security_group_id" {
  value = module.aurora.security_group_id
}
