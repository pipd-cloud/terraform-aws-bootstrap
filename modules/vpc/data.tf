data "aws_availability_zones" "az" {
  all_availability_zones = true
}

data "aws_s3_bucket" "flow_logs_bucket" {
  bucket = var.bucket_name
}
