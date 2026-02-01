resource "aws_ec2_client_vpn_endpoint" "this" {
  description            = var.name
  server_certificate_arn = var.server_cert_arn
  client_cidr_block      = var.client_cidr_block

  authentication_options {
    type                       = "certificate-authentication"
    root_certificate_chain_arn = var.client_cert_arn
  }

  connection_log_options {
    enabled = false
  }

  tags = var.tags
}

resource "aws_ec2_client_vpn_network_association" "this" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.this.id
  subnet_id              = var.subnet_id
}

# Authorize all users to access the VPC CIDR
resource "aws_ec2_client_vpn_authorization_rule" "all_vpc" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.this.id
  target_network_cidr    = "10.0.0.0/8"
  authorize_all_groups   = true
}

output "vpn_endpoint_id" {
  value = aws_ec2_client_vpn_endpoint.this.id
}

output "vpn_dns_name" {
  value = aws_ec2_client_vpn_endpoint.this.dns_name
}
