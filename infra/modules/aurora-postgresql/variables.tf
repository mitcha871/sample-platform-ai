variable "name" {
  description = "Name of the Aurora cluster"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "subnets" {
  description = "List of subnet IDs for the DB subnet group"
  type        = list(string)
}

variable "allowed_security_group_ids" {
  description = "List of security group IDs allowed to access the database"
  type        = list(string)
  default     = []
}

variable "engine_version" {
  description = "Aurora PostgreSQL engine version"
  type        = string
  default     = "16.1"
}

variable "master_username" {
  description = "Master username for the database"
  type        = string
  default     = "postgres"
}

variable "database_name" {
  description = "Name of the default database"
  type        = string
  default     = "sampledb"
}

variable "instances" {
  description = "Map of cluster instances and their configurations"
  type        = any
  default     = {}
}

variable "serverlessv2_scaling_configuration" {
  description = "Scaling configuration for Serverless v2"
  type        = map(number)
  default = {
    min_capacity = 0.5
    max_capacity = 2.0
  }
}

variable "is_global_cluster" {
  description = "Whether this is a member of a global cluster"
  type        = bool
  default     = false
}

variable "global_cluster_identifier" {
  description = "The global cluster identifier"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags for resources"
  type        = map(string)
  default     = {}
}
