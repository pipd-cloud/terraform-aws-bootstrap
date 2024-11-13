data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

# KMS key policy for the CloudWatch Logs CMK
data "aws_iam_policy_document" "cmk_cloudwatch_logs_policy" {
  # Grant IAM access
  statement {
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
    effect    = "Allow"
    actions   = ["kms:*"]
    resources = ["*"]
  }
  # Grant CloudWatch Logs access to use key
  statement {
    principals {
      type        = "Service"
      identifiers = ["logs.${data.aws_region.current.name}.amazonaws.com"]
    }
    actions = [
      "kms:Encrypt*",
      "kms:Decrypt*",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:Describe*"
    ]
    resources = ["*"]
    condition {
      variable = "kms:EncryptionContext:aws:logs:arn"
      test     = "ArnLike"
      values   = ["arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*"]
    }
  }
}

# KMS key policy for the Cloudtrail CMK
data "aws_iam_policy_document" "cmk_cloudtrail_policy" {
  # Grant IAM access
  statement {
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
    effect    = "Allow"
    actions   = ["kms:*"]
    resources = ["*"]
  }
  # Grant CloudTrail access to encrypt with the key
  statement {
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
    effect    = "Allow"
    actions   = ["kms:GenerateDataKey*"]
    resources = ["*"]
    condition {
      variable = "aws:SourceArn"
      test     = "StringLike"
      values   = ["arn:aws:cloudtrail:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:trail/*"]
    }
    condition {
      variable = "kms:EncryptionContext:aws:cloudtrail:arn"
      test     = "StringLike"
      values   = ["arn:aws:cloudtrail:*:${data.aws_caller_identity.current.account_id}:trail/*"]
    }
  }
  # Grant CloudTrail access to decrypt with the key
  statement {
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
    effect    = "Allow"
    actions   = ["kms:Decrypt"]
    resources = ["*"]
  }

  # Grant CloudTrail access to describe the key
  statement {
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
    effect    = "Allow"
    actions   = ["kms:Describe*"]
    resources = ["*"]
    condition {
      variable = "aws:SourceArn"
      test     = "StringLike"
      values   = ["arn:aws:cloudtrail:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:trail/*"]
    }
  }
}

# Trust policy for the CloudTrail Role.
data "aws_iam_policy_document" "cloudtrail_role_trust_policy" {
  statement {
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
  }
}

# Policy document for the CloudTrail role inline policy.
# This policy is used to publish to CloudWatch and to decrypt the CloudWatch KMS key.
data "aws_iam_policy_document" "cloudtrail_cloudwatch_logs_policy" {
  statement {
    effect    = "Allow"
    actions   = ["logs:CreateLogStream", "logs:PutLogEvents"]
    resources = ["${aws_cloudwatch_log_group.cloudtrail_read_log_group.arn}:log-stream:*", "${aws_cloudwatch_log_group.cloudtrail_write_log_group.arn}:log-stream:*"]
  }
  statement {
    effect    = "Allow"
    actions   = ["kms:Decrypt"]
    resources = [aws_kms_key.cmk_cloudwatch_logs.arn]
  }
}

# Fetch the bucket specified in the variables
data "aws_s3_bucket" "cloudtrail" {
  bucket = var.bucket_name
}
