resource "aws_costoptimizationhub_enrollment_status" "enable" {}

resource "aws_computeoptimizer_enrollment_status" "enable" {
  status                  = "Active"
  include_member_accounts = false
}

resource "aws_resourceexplorer2_index" "local" {
  type = "LOCAL"
  tags = var.aws_tags
}

resource "aws_resourceexplorer2_view" "local" {
  name         = "aws-resources"
  tags         = var.aws_tags
  default_view = true
  included_property {
    name = "tag"
  }
}
