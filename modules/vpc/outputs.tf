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
