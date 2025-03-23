locals {
  bucket_id = length(var.id) <= 14 ? var.id : substr(var.id, 0, 14)
}

resource "aws_s3_bucket" "logs" {
  bucket_prefix = "${local.bucket_id}-logs-bucket-"
  lifecycle {
    prevent_destroy = true
  }
  tags = merge(
    {
      Name = "${local.bucket_id}-logs-bucket"
      TFID = var.id
    },
    var.aws_tags
  )
}


resource "aws_s3_bucket_policy" "logs" {
  bucket = aws_s3_bucket.logs.id
  policy = data.aws_iam_policy_document.logs.json
}

resource "aws_s3_bucket_versioning" "logs" {
  bucket = aws_s3_bucket.logs.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "logs" {
  bucket = aws_s3_bucket.logs.id
  rule {
    id     = "expire"
    status = "Enabled"
    filter {
      prefix = ""
    }
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
  depends_on = [aws_s3_bucket_versioning.logs]
  bucket     = aws_s3_bucket.logs.id
  rule {
    default_retention {
      mode  = "COMPLIANCE"
      years = 7
    }
  }
}

resource "aws_s3_bucket_public_access_block" "private" {
  bucket                  = aws_s3_bucket.logs.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
