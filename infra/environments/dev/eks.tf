module "eks" {
  source = "../../modules/eks"

  cluster_name    = "dev-eks"
  cluster_version = "1.31"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  managed_node_groups = {
    general = {
      # For Dev, we use small Burstable instances
      instance_types = ["t3.medium"]
      
      min_size     = 1
      max_size     = 2
      desired_size = 1
    }
  }

  tags = {
    Environment = "Dev"
  }
}

# Now we can update the DB security group to allow access from EKS nodes
# We add this to the database module or as a standalone rule
resource "aws_security_group_rule" "eks_to_db" {
  description              = "Allow EKS nodes to access the database"
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  security_group_id        = module.db.security_group_id
  source_security_group_id = module.eks.node_security_group_id
}
