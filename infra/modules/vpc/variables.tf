variable "name" {
  description = "Name of the VPC"
  type        = "string"
}

variable "cidr" {
  description = "CIDR block for the VPC"
  type        = "string"
}

variable "azs" {
  description = "Availability zones"
  type        = "list(string)"
}

variable "private_subnets" {
  description = "CIDR blocks for private subnets"
  type        = "list(string)"
}

variable "public_subnets" {
  description = "CIDR blocks for public subnets"
  type        = "list(string)"
}

variable "database_subnets" {
  description = "CIDR blocks for database subnets"
  type        = "list(string)"
}

variable "single_nat_gateway" {
  description = "Should be true if you want to provision a single shared NAT Gateway across all of your private networks"
  type        = "bool"
  default     = false
}

variable "tags" {
  description = "Additional tags for all resources"
  type        = "map(string)"
  default     = {}
}
