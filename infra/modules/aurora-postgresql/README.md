# Aurora PostgreSQL Module

This module provisions an Amazon Aurora PostgreSQL-compatible cluster.

## Features
*   **Aurora Serverless v2 Support:** Scales compute up and down based on demand (perfect for Dev/UAT cost savings).
*   **Global Database Support:** Enables cross-region replication for high availability and low-latency reads.
*   **Encrypted by Default:** Uses AWS KMS for data at rest.
*   **Network Isolation:** Placed in dedicated database subnets with restricted access via Security Groups.

## Usage
```hcl
module "aurora" {
  source = "../../modules/aurora-postgresql"

  name           = "dev-db"
  vpc_id         = module.vpc.vpc_id
  subnets        = module.vpc.database_subnets
  allowed_cidr   = "10.0.0.0/16" # Usually the VPC CIDR
  
  engine_version = "16.1"
  instances      = {
    one = {
      instance_class = "db.serverless"
    }
  }
}
```
