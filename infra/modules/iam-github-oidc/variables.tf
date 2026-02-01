variable "github_repo" {
  description = "The GitHub repository allowed to assume this role (e.g., owner/repo)"
  type        = string
}

variable "role_name" {
  description = "The name of the IAM role to create"
  type        = string
  default     = "github-actions-deployer"
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
