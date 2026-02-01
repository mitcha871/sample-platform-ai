module "vpc" {
  source = "../../modules/vpc"

  name = "prod-vpc"
  cidr = "10.2.0.0/16"

  # Production: 3 AZs for high availability
  azs              = ["ap-southeast-2a", "ap-southeast-2b", "ap-southeast-2c"]
  private_subnets  = ["10.2.1.0/24", "10.2.2.0/24", "10.2.3.0/24"]
  public_subnets   = ["10.2.101.0/24", "10.2.102.0/24", "10.2.103.0/24"]
  database_subnets = ["10.2.201.0/24", "10.2.202.0/24", "10.2.203.0/24"]

  # Production: One NAT Gateway per AZ for maximum resilience
  single_nat_gateway = false
  one_nat_gateway_per_az = true

  tags = {
    "kubernetes.io/cluster/prod-eks" = "shared"
  }
}
