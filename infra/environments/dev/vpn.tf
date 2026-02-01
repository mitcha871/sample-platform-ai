# Note: VPN requires ACM certificates to be created manually first.
# These variables should be provided via a .tfvars file or env vars.
variable "vpn_server_cert_arn" {
  type    = string
  default = "REPLACE_ME_AFTER_MANUAL_STEP"
}

variable "vpn_client_cert_arn" {
  type    = string
  default = "REPLACE_ME_AFTER_MANUAL_STEP"
}

module "vpn" {
  source = "../../modules/vpn"

  name      = "dev-client-vpn"
  vpc_id    = module.vpc.vpc_id
  subnet_id = module.vpc.private_subnets[0]

  server_cert_arn = var.vpn_server_cert_arn
  client_cert_arn = var.vpn_client_cert_arn

  tags = {
    Environment = "Dev"
  }
}
