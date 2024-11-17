data "aws_availability_zones" "az" {}

data "aws_s3_bucket" "flow_logs_bucket" {
  bucket = var.bucket_name
}
