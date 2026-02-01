# VPC Module

This module creates a standard enterprise-grade VPC following AWS best practices for security and high availability.

## Features
*   **Public Subnets:** For Load Balancers and NAT Gateways.
*   **Private Subnets:** For compute resources (EKS nodes) and internal services.
*   **Database Subnets:** Isolated subnets with a dedicated network ACL for database clusters.
*   **NAT Gateway:** Provides outbound internet access for private resources. (Configurable: One per AZ for Production HA, or single for Dev cost-savings).
*   **Standard Tagging:** Includes tags for EKS cluster discovery (`kubernetes.io/role/elb` and `kubernetes.io/role/internal-elb`).

## Usage
```hcl
module "vpc" {
  source = "../../modules/vpc"

  name               = "dev-vpc"
  cidr               = "10.0.0.0/16"
  azs                = ["ap-southeast-2a", "ap-southeast-2b"]
  private_subnets    = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets     = ["10.0.101.0/24", "10.0.102.0/24"]
  database_subnets   = ["10.0.201.0/24", "10.0.202.0/24"]
  single_nat_gateway = true
}
```
