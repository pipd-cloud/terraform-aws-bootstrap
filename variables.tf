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
## CloudTrail
variable "cloudtrail_enabled" {
  description = "Whether to enable CloudTrail logging."
  type        = bool
  default     = true
}

## Opt-in
variable "opt_in_services_enabled" {
  description = "Whether to enable opt-in services."
  type        = bool
  default     = true
}

## OIDC
variable "oidc_enabled" {
  description = "Whether to enable OIDC integration."
  type        = bool
  default     = true
}

variable "oidc_github_organization" {
  description = "The GitHub organization that owns the repositories of interest."
  type        = string
  nullable    = true
  default     = null
  validation {
    condition     = !var.oidc_enabled || (var.oidc_enabled && var.oidc_github_organization != null)
    error_message = "oidc_github_organization must be set when oidc_enabled is true."
  }
}

variable "oidc_github_repo" {
  description = "The GitHub repository that may be used in automated deployments."
  type        = string
  default     = "*"
}

variable "oidc_hcp_terraform_organization" {
  description = "The HCP Terraform organization that may be used in automated deployments."
  type        = string
  nullable    = true
  default     = null
  validation {
    condition     = !var.oidc_enabled || (var.oidc_enabled && var.oidc_hcp_terraform_organization != null)
    error_message = "oidc_hcp_terraform_organization must be set when oidc_enabled is true."
  }
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
