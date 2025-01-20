output "logs_bucket" {
  description = "The bucket in which the audit data will be stored."
  value       = aws_s3_bucket.logs
}

