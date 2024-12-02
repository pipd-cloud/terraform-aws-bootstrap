# Common Variables
## Required
variable "id" {
  description = "The unique identifier for this deployment."
  type        = string
}

## Optional
variable "aws_tags" {
  description = "Additional AWS tags to apply to resources in this module."
  type        = map(string)
  default     = {}
}

# Module Variables
## OIDC
variable "oidc_github_organization" {
  description = "The GitHub organization that owns the repositories of interest."
  type        = string
}

variable "oidc_github_repo" {
  description = "The GitHub repository that may be used in automated deployments."
  type        = string
  default     = "*"
}

variable "oidc_hcp_terraform_organization" {
  description = "The HCP Terraform organization that may be used in automated deployments."
  type        = string
}

variable "oidc_hcp_terraform_project" {
  description = "The HCP Terraform project that may be used in automated deployments."
  type        = string
  default     = "*"
}

variable "oidc_hcp_terraform_workspace" {
  description = "The HCP Terraform workspace that may be used in automated deployments."
  type        = string
  default     = "*"
}
