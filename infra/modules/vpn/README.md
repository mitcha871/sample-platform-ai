# AWS Client VPN Module

This module provisions an AWS Client VPN endpoint to allow secure, encrypted access to resources in private subnets (e.g., EKS API, Aurora DB, internal Grafana).

## Security Note
This module uses **Mutual Authentication** (Certificates) for simplicity in this demo. In a production environment, you would typically integrate this with **SAML 2.0 (Azure AD, Okta)** for identity-based access.

## Manual Steps Required
Before applying this module, you must generate and upload certificates to AWS Certificate Manager (ACM):
1. Generate a CA, Server Certificate, and Client Certificate (using `easyrsa`).
2. Upload the Server Certificate to ACM.
3. Upload the Client Certificate to ACM.

The ARNs for these certificates are passed into this module.

## Usage
```hcl
module "vpn" {
  source = "../../modules/eks"

  name               = "dev-vpn"
  vpc_id             = module.vpc.vpc_id
  subnet_id          = module.vpc.private_subnets[0]
  client_cidr_block  = "10.100.0.0/22"
  server_cert_arn    = "arn:aws:acm:..."
  client_cert_arn    = "arn:aws:acm:..."
}
```
