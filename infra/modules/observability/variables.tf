variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "oidc_provider_arn" {
  description = "OIDC Provider ARN for the EKS cluster"
  type        = string
}

variable "tags" {
  description = "Tags for resources"
  type        = map(string)
  default     = {}
}
