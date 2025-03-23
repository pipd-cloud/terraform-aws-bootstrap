resource "aws_costoptimizationhub_enrollment_status" "enable" {}

resource "aws_computeoptimizer_enrollment_status" "enable" {
  status                  = "Active"
  include_member_accounts = false
}

resource "aws_resourceexplorer2_index" "local" {
  type = "AGGREGATOR"
  tags = merge(var.aws_tags,
    {
      Name = "${var.id}-resource-explorer-index"
      TFID = var.id
    }
  )
}

resource "aws_resourceexplorer2_view" "local" {
  depends_on   = [aws_resourceexplorer2_index.local]
  name         = "aws-resources"
  tags         = var.aws_tags
  default_view = true
  included_property {
    name = "tags"
  }
}

resource "aws_accessanalyzer_analyzer" "external" {
  analyzer_name = "${var.id}-external-access-analyzer"
  tags = merge(var.aws_tags,
    {
      Name = "${var.id}-external-access-analyzer"
      TFID = var.id
    }
  )
}