locals {
  bucket_id = length(var.id) <= 14 ? var.id : substr(var.id, 0, 14)
}
resource "aws_s3_bucket" "cloudtrail" {
  bucket_prefix = "${local.bucket_id}-cloudtrail-bucket-"
  lifecycle {
    prevent_destroy = true
  }
  tags = merge(
    {
      Name = "${local.bucket_id}-cloudtrail-bucket"
      TFID = "${var.id}"
    },
    var.aws_tags
  )
}

resource "aws_s3_bucket" "flow_logs" {
  bucket_prefix = "${local.bucket_id}-flow-logs-bucket-"
  lifecycle {
    prevent_destroy = true
  }
  tags = merge(
    {
      Name = "${local.bucket_id}-flow-logs-bucket"
      TFID = "${var.id}"
    },
    var.aws_tags
  )
}

resource "aws_s3_bucket" "s3_access_logs" {
  bucket_prefix = "${local.bucket_id}-s3-access-logs-bucket-"
  lifecycle {
    prevent_destroy = true
  }
  tags = merge(
    {
      Name = "${local.bucket_id}-s3-access-logs-bucket"
      TFID = "${var.id}"
    },
    var.aws_tags
  )
}

resource "aws_s3_bucket_logging" "logs" {
  for_each      = { cloudtrail = aws_s3_bucket.cloudtrail, flow_logs = aws_s3_bucket.flow_logs, s3_access_logs = aws_s3_bucket.s3_access_logs }
  bucket        = each.value.id
  target_bucket = aws_s3_bucket.s3_access_logs.id
  target_prefix = each.value.id
}

resource "aws_s3_bucket_policy" "cloudtrail_bucket_policy" {
  bucket = aws_s3_bucket.cloudtrail.id
  policy = data.aws_iam_policy_document.cloudtrail_bucket_policy.json
}

resource "aws_s3_bucket_policy" "flow_logs_bucket_policy" {
  bucket = aws_s3_bucket.flow_logs.id
  policy = data.aws_iam_policy_document.flow_logs_bucket_policy.json
}

resource "aws_s3_bucket_policy" "s3_access_logs_bucket_policy" {
  bucket = aws_s3_bucket.s3_access_logs.id
  policy = data.aws_iam_policy_document.s3_access_logs_bucket_policy.json
}

resource "aws_s3_bucket_versioning" "audit_versioning_config" {
  for_each = { cloudtrail = aws_s3_bucket.cloudtrail, flow_logs = aws_s3_bucket.flow_logs, s3_access_logs = aws_s3_bucket.s3_access_logs }
  bucket   = each.value.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "audit_lifecycle_config" {
  for_each = { cloudtrail = aws_s3_bucket.cloudtrail, flow_logs = aws_s3_bucket.flow_logs, s3_access_logs = aws_s3_bucket.s3_access_logs }
  bucket   = each.value.id
  rule {
    id     = "expire"
    status = "Enabled"
    expiration {
      days = 2556
    }
    abort_incomplete_multipart_upload {
      days_after_initiation = 30
    }
    noncurrent_version_expiration {
      noncurrent_days = 30
    }
  }
}

resource "aws_s3_bucket_object_lock_configuration" "audit_object_lock_config" {
  depends_on = [aws_s3_bucket_versioning.audit_versioning_config]
  for_each   = !var.debug_mode ? { cloudtrail = aws_s3_bucket.cloudtrail, flow_logs = aws_s3_bucket.flow_logs, s3_access_logs = aws_s3_bucket.s3_access_logs } : {}
  bucket     = each.value.id
  rule {
    default_retention {
      mode  = "COMPLIANCE"
      years = 7
    }
  }
}

resource "aws_s3_bucket_public_access_block" "private" {
  for_each                = { cloudtrail = aws_s3_bucket.cloudtrail, flow_logs = aws_s3_bucket.flow_logs, s3_access_logs = aws_s3_bucket.s3_access_logs }
  bucket                  = each.value.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
