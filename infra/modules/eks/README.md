# EKS Module

This module provisions an Amazon EKS (Elastic Kubernetes Service) cluster.

## Features
*   **Private Nodes:** Worker nodes are placed in private subnets with no direct internet access.
*   **Managed Node Groups:** AWS manages the lifecycle of the EC2 instances.
*   **IAM OIDC Provider:** Enables "IAM Roles for Service Accounts" (IRSA), allowing Kubernetes pods to have fine-grained AWS permissions.
*   **Karpenter-Ready:** Tagged to support future implementation of Karpenter for efficient autoscaling.

## Usage
```hcl
module "eks" {
  source = "../../modules/eks"

  cluster_name    = "dev-eks"
  cluster_version = "1.31"
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.private_subnets

  managed_node_groups = {
    general = {
      min_size     = 1
      max_size     = 3
      desired_size = 1
      instance_types = ["t3.medium"]
    }
  }
}
```
