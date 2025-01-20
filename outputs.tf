# Audit Buckets
output "logs_bucket" {
  description = "The bucket in which all logs are stored for this deployment."
  value       = module.logging.logs_bucket
}

# CloudTrail
output "cloudtrail_write_trail" {
  description = "The Write-Only CloudTrail trail."
  value       = var.cloudtrail_enabled ? module.cloudtrail[0].cloudtrail_write_trail : null
}

output "cloudtrail_read_trail" {
  description = "The Read-Only CloudTrail trail."
  value       = var.cloudtrail_enabled ? module.cloudtrail[0].cloudtrail_read_trail : null
}

output "cloudtrail_write_log_group" {
  description = "The Write-Only CloudTrail log group."
  value       = var.cloudtrail_enabled ? module.cloudtrail[0].cloudtrail_write_log_group : null
}

output "cloudtrail_read_log_group" {
  description = "The Read-Only CloudTrail log group."
  value       = var.cloudtrail_enabled ? module.cloudtrail[0].cloudtrail_read_log_group : null
}

