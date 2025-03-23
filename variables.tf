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
  default     = false
}

## Opt-in
variable "opt_in_services_enabled" {
  description = "Whether to enable opt-in services."
  type        = bool
  default     = false
}

## OIDC
variable "oidc_github_enabled" {
  description = "Whether to enable GitHub OIDC integration."
  type        = bool
  default     = false
}

variable "oidc_github_organization" {
  description = "The GitHub organization that owns the repositories of interest."
  type        = string
  nullable    = true
  default     = null
  validation {
    condition     = !var.oidc_github_enabled || (var.oidc_github_enabled && var.oidc_github_organization != null)
    error_message = "oidc_github_organization must be set when oidc_enabled is true."
  }
}

variable "oidc_github_repo" {
  description = "The GitHub repository that may be used in automated deployments."
  type        = string
  default     = "*"
}

variable "oidc_github_branches" {
  description = "The branches from which GitHub Actions may assume a role on AWS."
  type        = string
  default     = "*"
}

variable "oidc_github_managed_iam_policies" {
  description = "List of managed IAM policies that the GitHub Actions agent is granted."
  type        = list(string)
  default     = ["PowerUserAccess"]
}

variable "oidc_github_custom_iam_policies" {
  description = "List of custom IAM policy statements to grant the GitHub Actions agent."
  type = list(
    object(
      {
        actions       = list(string)
        resources     = list(string)
        effect        = optional(string)
        not_actions   = optional(list(string))
        not_resources = optional(list(string))
        conditions = optional(
          list(
            object(
              {
                test     = string
                values   = list(string)
                variable = string
              }
            )
          )
        )
      }
    )
  )
  default = [
    {
      actions   = ["iam:PassRole"]
      resources = ["*"]
      conditions = [
        {
          test     = "StringEquals"
          variable = "iam:PassedToService"
          values   = ["batch.amazonaws.com", "ecs-tasks.amazonaws.com", "ecs.amazonaws.com"]
        }
      ]
    }
  ]
}

variable "oidc_hcp_terraform_enabled" {
  description = "Whether to enable HCP Terraform OIDC integration."
  type        = bool
  default     = false
}

variable "oidc_hcp_terraform_organization" {
  description = "The HCP Terraform organization that may be used in automated deployments."
  type        = string
  nullable    = true
  default     = null
  validation {
    condition     = !var.oidc_hcp_terraform_enabled || (var.oidc_hcp_terraform_enabled && var.oidc_hcp_terraform_organization != null)
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

variable "oidc_hcp_terraform_managed_iam_policies" {
  description = "List of managed IAM policies that the HCP TF agent is granted."
  type        = list(string)
  default     = ["AdministratorAccess"]
}

variable "oidc_hcp_terraform_custom_iam_policies" {
  description = "List of custom IAM policy statements to grant the HCP TF agent."
  type = list(
    object(
      {
        actions       = list(string)
        resources     = list(string)
        effect        = optional(string)
        not_actions   = optional(list(string))
        not_resources = optional(list(string))
        conditions = optional(
          list(
            object(
              {
                test     = string
                values   = list(string)
                variable = string
              }
            )
          )
        )
      }
    )
  )
  default = []
}
