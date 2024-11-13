output "vpc" {
  description = "The VPC ID."
  value       = module.vpc.vpc
}

output "vpc_public_subnets" {
  description = "The public subnet IDs."
  value       = module.vpc.public_subnets
}

output "vpc_private_subnets" {
  description = "The private subnet IDs."
  value       = module.vpc.private_subnets
}

output "s3_access_logs_bucket" {
  description = "The name of the S3 Access Logs bucket."
  value       = module.audit_buckets.s3_access_logs_bucket
}
