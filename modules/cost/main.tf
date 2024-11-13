resource "aws_costoptimizationhub_enrollment_status" "enable" {}

resource "aws_computeoptimizer_enrollment_status" "enable" {
  status = "Active"
}

resource "aws_resourceexplorer2_index" "local" {
  type = "LOCAL"
  tags = var.aws_tags
}
