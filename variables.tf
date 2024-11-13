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
## VPC
variable "vpc_network_address" {
  type        = string
  default     = "10.0.0.0"
  description = "The private IP network address to use for the VPC CIDR block."
}

variable "vpc_network_mask" {
  type        = number
  default     = 16
  description = "The network mask to use for the VPC CIDR block. Must be between 16 and 28."
  validation {
    condition     = (var.vpc_network_mask >= 16) && (var.vpc_network_mask <= 28)
    error_message = "The VPC network mask must be between 16 and 28"
  }
}
variable "vpc_subnet_new_bits" {
  type        = number
  default     = 6
  description = "The adjustment to make to the VPC network mask (in bits) to define the subnets."
}

variable "vpc_subnets" {
  type        = number
  nullable    = true
  default     = null
  description = "The number of public-private subnet pairs to create. Cannot be greater than the number of AZ in this region."
}

variable "vpc_nat" {
  type        = bool
  default     = false
  description = "Whether to create a NAT gateway."
}

variable "vpc_nat_multi_az" {
  type        = bool
  default     = false
  description = "Whether to create only a single NAT gateway for all private subnets to use, or to create a NAT gateway in each AZ."
  validation {
    condition     = !var.vpc_nat_multi_az || (var.vpc_nat && var.vpc_nat_multi_az)
    error_message = "You must enable NAT if you want to set multi AZ for NAT gateways."
  }
}

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

