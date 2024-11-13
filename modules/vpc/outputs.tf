## VPC
output "vpc" {
  description = "The VPC ID."
  value       = aws_vpc.vpc.id
}

output "public_subnets" {
  description = "The public subnet IDs."
  value       = aws_subnet.public_subnets[*].id
}

output "private_subnets" {
  description = "The private subnet IDs."
  value       = aws_subnet.private_subnets[*].id
}

