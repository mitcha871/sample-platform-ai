# Leverage the official EKS module to handle the heavy lifting of IAM, 
# security groups, and OIDC configuration.
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  vpc_id     = var.vpc_id
  subnet_ids = var.subnet_ids

  # Cluster endpoint access (Public for now, usually restricted to VPN)
  cluster_endpoint_public_access = true

  # Enable OIDC for IRSA (IAM Roles for Service Accounts)
  enable_irsa = true

  # Managed Node Groups
  eks_managed_node_groups = var.managed_node_groups

  # Give the creator of the cluster admin access in K8s (simplified for demo)
  enable_cluster_creator_admin_permissions = true

  tags = var.tags
}

output "cluster_name" {
  value = module.eks.cluster_name
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "node_security_group_id" {
  value = module.eks.node_security_group_id
}

output "oidc_provider_arn" {
  value = module.eks.oidc_provider_arn
}
