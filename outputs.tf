# VPC
output "vpc" {
  description = "The VPC."
  value       = aws_vpc.vpc
}

output "vpc_public_subnets" {
  description = "The public subnets."
  value       = aws_subnet.public_subnets
}

output "vpc_private_subnets" {
  description = "The private subnets."
  value       = aws_subnet.private_subnets
}

# Audit Buckets
output "s3_bucket_cloudtrail" {
  description = "The bucket in which the audit data will be stored."
  value       = module.audit_buckets.cloudtrail_bucket
}

output "s3_bucket_flow_logs" {
  description = "The bucket in which the VPC flow logs will be stored."
  value       = module.audit_buckets.flow_logs_bucket
}

output "s3_bucket_access_logs" {
  description = "The bucket in which the bucket access logs will be stored."
  value       = module.audit_buckets.s3_access_logs_bucket
}

# CloudTrail
output "cloudtrail_write_trail" {
  description = "The Write-Only CloudTrail trail."
  value       = module.cloudtrail.cloudtrail_write_trail
}

output "cloudtrail_read_trail" {
  description = "The Read-Only CloudTrail trail."
  value       = module.cloudtrail.cloudtrail_read_trail
}

output "cloudtrail_write_log_group" {
  description = "The Write-Only CloudTrail log group."
  value       = module.cloudtrail.cloudtrail_write_log_group
}

output "cloudtrail_read_log_group" {
  description = "The Read-Only CloudTrail log group."
  value       = module.cloudtrail.cloudtrail_read_log_group
}

