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
variable "debug_mode" {
  description = "Whether to create the audit bucket in debug mode. (Destructable)"
  type        = bool
  default     = false
}

