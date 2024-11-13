output "cloudtrail_write_trail" {
  description = "The Write-Only CloudTrail trail."
  value       = aws_cloudtrail.cloudtrail_write
}

output "cloudtrail_read_trail" {
  description = "The Read-Only CloudTrail trail."
  value       = aws_cloudtrail.cloudtrail_read
}

output "cloudtrail_write_log_group" {
  description = "The Write-Only CloudTrail log group."
  value       = aws_cloudwatch_log_group.cloudtrail_write_log_group
}

output "cloudtrail_read_log_group" {
  description = "The Read-Only CloudTrail log group."
  value       = aws_cloudwatch_log_group.cloudtrail_read_log_group
}
