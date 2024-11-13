output "cloudtrail_write_trail" {
  description = "The Write-Only CloudTrail trail."
  value       = aws_cloudtrail.cloudtrail_write
}

output "cloudtrail_read_trail" {
  description = "The Read-Only CloudTrail trail."
  value       = aws_cloudtrail.cloudtrail_read
}
