# Create a KMS key that is used for encrypting and decrypting CloudWatch logs.
resource "aws_kms_key" "cmk_cloudwatch_logs" {
  description             = "KMS key used for encrypting CloudWatch logs."
  enable_key_rotation     = true
  rotation_period_in_days = 30
  deletion_window_in_days = 30
}

resource "aws_kms_key_policy" "cmk_cloudwatch_logs_policy" {
  key_id = aws_kms_key.cmk_cloudwatch_logs.key_id
  policy = data.aws_iam_policy_document.cmk_cloudwatch_logs_policy.json
}

resource "aws_kms_alias" "cmk_cloudwatch_logs_alias" {
  name          = "alias/noodle/cloudwatch/logs"
  target_key_id = aws_kms_key.cmk_cloudwatch_logs.key_id
}

# Create a KMS key that is used for encrypting and decrypting CloudTrail events.
resource "aws_kms_key" "cmk_cloudtrail" {
  description             = "KMS key used for encrypting CloudTrail events."
  enable_key_rotation     = true
  rotation_period_in_days = 30
  deletion_window_in_days = 30
}

resource "aws_kms_key_policy" "cmk_cloudtrail_policy" {
  key_id = aws_kms_key.cmk_cloudtrail.key_id
  policy = data.aws_iam_policy_document.cmk_cloudtrail_policy.json
}

resource "aws_kms_alias" "cmk_cloudtrail_alias" {
  name          = "alias/noodle/cloudtrail"
  target_key_id = aws_kms_key.cmk_cloudtrail.key_id
}

# Create a CloudWatch log group that is used for publishing CloudTrail events.
resource "aws_cloudwatch_log_group" "cloudtrail_log_group" {
  name              = "cloudtrail"
  retention_in_days = 30
  kms_key_id        = aws_kms_key.cloudwatch_logs.key_id
}

resource "aws_iam_role" "cloudtrail_role" {
  name               = "CloudTrailRole"
  description        = "Role that is assumed by CloudTrail to log to CloudWatch logs."
  assume_role_policy = data.aws_iam_policy_document.cloudtrail_trust_policy.json
}

resource "aws_iam_policy" "cloudwatch_inline_policy" {
  name        = "CloudTrailCloudWatchLogsWriteAccess"
  description = "Grants access to the CloudWatch Logs group for CloudTrail."
  policy      = data.aws_iam_policy_document.cloudtrail_cloudwatch_policy.json
}

# Create the main CloudTrail
resource "aws_cloudtrail" "management_events" {
  depends_on                    = [aws_s3_bucket_policy.cloudtrail_events_policy]
  name                          = "cloudtrail"
  s3_bucket_name                = aws_s3_bucket.cloudtrail_events.id
  include_global_service_events = true
  enable_log_file_validation    = true
  event_selector {
    include_management_events = true
    read_write_type           = "WriteOnly"
  }
  cloud_watch_logs_group_arn = "${aws_cloudwatch_log_group.cloudtrail.arn}/*"
  cloud_watch_logs_role_arn  = aws_iam_role.cloudtrail_role.arn
  kms_key_id                 = aws_kms_key.cloudtrail.key_id
}

resource "aws_s3_bucket" "cloudtrail_events" {
  bucket_prefix = "aws-cloudtrail"
}

resource "aws_s3_bucket_policy" "cloudtrail_events_policy" {
  bucket = aws_s3_bucket.cloudtrail_events.id
  policy = data.aws_iam_policy_document.cloudtrail.json
}

resource "aws_s3_bucket_versioning" "cloudtrail_events_versioning" {
  bucket = aws_s3_bucket.cloudtrail_events.id
  versioning_configuration {
    status = "Enabled"
  }
}


resource "aws_s3_bucket_lifecycle_configuration" "cloudtrail_events_lifecycle" {
  bucket = aws_s3_bucket.cloudtrail_events.id
  rule {
    id     = "expire"
    status = "Enabled"
    expiration {
      days = 2556
    }
    noncurrent_version_expiration {
      noncurrent_days = 30
    }
  }
}

resource "aws_s3_bucket_object_lock_configuration" "cloudtrail_object_lock" {
  bucket = aws_s3_bucket.cloudtrail_events.id
  rule {
    default_retention {
      mode  = "COMPLIANCE"
      years = 7
    }
  }
}
