module "db" {
  source = "../../modules/aurora-postgresql"

  name           = "dev-aurora-db"
  vpc_id         = module.vpc.vpc_id
  subnets        = module.vpc.database_subnets
  
  # For now, we'll allow VPC-wide access. 
  # Later we'll restrict this to just the EKS node security group.
  allowed_security_group_ids = [] 

  engine_version = "16.1"
  instances = {
    one = {
      instance_class = "db.serverless"
    }
  }

  serverlessv2_scaling_configuration = {
    min_capacity = 0.5
    max_capacity = 1.0
  }

  tags = {
    Environment = "Dev"
  }
}

output "db_endpoint" {
  value = module.db.cluster_endpoint
}
