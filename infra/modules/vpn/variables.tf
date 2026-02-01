variable "name" {
  description = "Name of the VPN endpoint"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the VPN will be associated"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID to associate the VPN with"
  type        = string
}

variable "client_cidr_block" {
  description = "Network range for VPN clients"
  type        = string
  default     = "10.100.0.0/22"
}

variable "server_cert_arn" {
  description = "ARN of the server certificate in ACM"
  type        = string
}

variable "client_cert_arn" {
  description = "ARN of the client certificate in ACM"
  type        = string
}

variable "tags" {
  description = "Tags for resources"
  type        = map(string)
  default     = {}
}
