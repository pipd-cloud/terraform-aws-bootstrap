# Create a KMS key that is used for encrypting and decrypting CloudWatch logs.
resource "aws_kms_key" "cmk_cloudwatch_logs" {
  description             = "KMS key used for encrypting CloudWatch logs."
  enable_key_rotation     = true
  rotation_period_in_days = 90
  deletion_window_in_days = 30
  tags = merge(
    {
      Name = "cloudwatch/logs"
      TFID = var.id
    },
    var.aws_tags
  )
}

resource "aws_kms_key_policy" "cmk_cloudwatch_logs_policy" {
  key_id = aws_kms_key.cmk_cloudwatch_logs.key_id
  policy = data.aws_iam_policy_document.cmk_cloudwatch_logs_policy.json
}

resource "aws_kms_alias" "cmk_cloudwatch_logs_alias" {
  name          = "alias/cloudwatch/logs"
  target_key_id = aws_kms_key.cmk_cloudwatch_logs.key_id
}

# Create a KMS key that is used for encrypting and decrypting CloudTrail events.
resource "aws_kms_key" "cmk_cloudtrail" {
  description             = "KMS key used for encrypting CloudTrail events."
  enable_key_rotation     = true
  rotation_period_in_days = 90
  deletion_window_in_days = 30
  tags = merge({
    Name = "cloudtrail"
    TFID = var.id
    },
    var.aws_tags
  )
}

resource "aws_kms_key_policy" "cmk_cloudtrail_policy" {
  key_id = aws_kms_key.cmk_cloudtrail.key_id
  policy = data.aws_iam_policy_document.cmk_cloudtrail_policy.json
}

resource "aws_kms_alias" "cmk_cloudtrail_alias" {
  name          = "alias/cloudtrail"
  target_key_id = aws_kms_key.cmk_cloudtrail.key_id
}

# Create a CloudWatch log group that is used for publishing CloudTrail events.
resource "aws_cloudwatch_log_group" "cloudtrail_write_log_group" {
  name              = "cloudtrail/write"
  retention_in_days = 365
  kms_key_id        = aws_kms_key.cmk_cloudwatch_logs.arn
  tags = merge({
    Name = "cloudtrail/write"
    TFID = var.id
    },
    var.aws_tags
  )
}

resource "aws_cloudwatch_log_group" "cloudtrail_read_log_group" {
  name              = "cloudtrail/read"
  retention_in_days = 365
  kms_key_id        = aws_kms_key.cmk_cloudwatch_logs.arn
  tags = merge({
    Name = "cloudtrail/read"
    TFID = var.id
    },
    var.aws_tags
  )
}

# Grant CloudTrail access to publish to CloudWatch logs.
resource "aws_iam_role" "cloudtrail_role" {
  name_prefix        = "CloudTrailRole_"
  description        = "Role that is assumed by CloudTrail to publish CloudWatch logs."
  assume_role_policy = data.aws_iam_policy_document.cloudtrail_role_trust_policy.json
  tags = merge({
    Name = "CloudTrailRole"
    TFID = var.id
    },
    var.aws_tags
  )
}

resource "aws_iam_policy" "cloudtrail_inline_policy" {
  name_prefix = "CloudTrailCloudWatchLogsWriteAccess_"
  description = "Grants access to the CloudWatch Logs group for CloudTrail."
  policy      = data.aws_iam_policy_document.cloudtrail_cloudwatch_logs_policy.json
  tags = merge({
    Name = "CloudTrailCloudWatchLogsWriteAccess"
    TFID = var.id
    },
    var.aws_tags
  )
}

resource "aws_iam_role_policy_attachment" "cloudtrail_inline_policy_attachment" {
  role       = aws_iam_role.cloudtrail_role.name
  policy_arn = aws_iam_policy.cloudtrail_inline_policy.arn
}

# Create the main CloudTrail
resource "aws_cloudtrail" "cloudtrail_write" {
  name                          = "cloudtrail-write"
  s3_bucket_name                = data.aws_s3_bucket.cloudtrail.id
  include_global_service_events = true
  enable_log_file_validation    = true
  enable_logging                = true
  cloud_watch_logs_group_arn    = "${aws_cloudwatch_log_group.cloudtrail_write_log_group.arn}:*"
  cloud_watch_logs_role_arn     = aws_iam_role.cloudtrail_role.arn
  kms_key_id                    = aws_kms_key.cmk_cloudtrail.arn
  is_multi_region_trail         = true
  event_selector {
    include_management_events = true
    read_write_type           = "WriteOnly"
  }
  tags = merge({
    Name = "cloudtrail-write"
    TFID = var.id
    },
    var.aws_tags
  )
}
resource "aws_cloudtrail" "cloudtrail_read" {
  name                          = "cloudtrail-read"
  s3_bucket_name                = data.aws_s3_bucket.cloudtrail.id
  include_global_service_events = true
  enable_log_file_validation    = true
  enable_logging                = true
  cloud_watch_logs_group_arn    = "${aws_cloudwatch_log_group.cloudtrail_read_log_group.arn}:*"
  cloud_watch_logs_role_arn     = aws_iam_role.cloudtrail_role.arn
  kms_key_id                    = aws_kms_key.cmk_cloudtrail.arn
  is_multi_region_trail         = true
  event_selector {
    include_management_events = true
    read_write_type           = "ReadOnly"
  }
  tags = merge({
    Name = "cloudtrail-read"
    TFID = var.id
    },
    var.aws_tags
  )
}


