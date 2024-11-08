data "aws_availability_zones" "az" {
  state = "available"
}

data "aws_s3_bucket" "flow_logs_bucket" {
  bucket = var.bucket_name
}
