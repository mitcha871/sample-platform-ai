module "vpc" {
  source = "../../modules/vpc"

  name = "uat-vpc"
  cidr = "10.1.0.0/16"

  azs              = ["ap-southeast-2a", "ap-southeast-2b"]
  private_subnets  = ["10.1.1.0/24", "10.1.2.0/24"]
  public_subnets   = ["10.1.101.0/24", "10.1.102.0/24"]
  database_subnets = ["10.1.201.0/24", "10.1.202.0/24"]

  # UAT optimization: shared NAT Gateway
  single_nat_gateway = true

  tags = {
    "kubernetes.io/cluster/uat-eks" = "shared"
  }
}
