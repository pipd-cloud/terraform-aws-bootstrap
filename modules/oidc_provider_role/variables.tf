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
variable "create_provider" {
  type    = bool
  default = true
}

variable "provider_name" {
  type = string
}

variable "iam_policies" {
  type = list(string)
}

variable "custom_iam_policy" {
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
}

variable "url" {
  type = string
}

variable "trust_policy_conditions" {
  type = list(object({
    test     = string
    values   = list(string)
    variable = string
  }))
}

variable "client_ids" {
  type = list(string)
}
