output "cloudtrail_bucket" {
  description = "The bucket in which the audit data will be stored."
  value       = aws_s3_bucket.cloudtrail
}

output "flow_logs_bucket" {
  description = "The bucket in which the VPC flow logs will be stored."
  value       = aws_s3_bucket.flow_logs
}

output "s3_access_logs_bucket" {
  description = "The bucket in which the bucket access logs will be stored."
  value       = aws_s3_bucket.s3_access_logs
}
