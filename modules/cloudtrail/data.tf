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
    actions   = "kms:Decrypt"
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

# Trust policy for the CloudWatch Logs Role ARN.
data "aws_iam_policy_document" "cloudwatch_logs_role_policy_document" {
  statement {
    principals {
      type        = "Service"
      identifiers = ["logs.${data.aws_region.current.name}.amazonaws.com"]
    }
    effect  = ["Allow"]
    actions = ["sts:AssumeRole"]
  }
}

# Policy document for the CloudWatch role inline policy.
# This policy is used to decrypt the CloudTrail CMK
data "aws_iam_policy_document" "cloudwatch_logs_policy" {
  statement {
    effect    = ["Allow"]
    actions   = ["logs:CreateLogStream", "logs:PutLogEvents"]
    resources = ["${aws_cloudwatch_log_group.cloudtrail_log_group.arn}:log-stream:*"]
  }
  statement {
    effect    = ["Allow"]
    actions   = ["kms:Decrypt"]
    resources = [aws_kms_key.cmk_cloudtrail.arn]
  }
}
# Bucket policy for the CloudTrail events bucket
data "aws_iam_policy_document" "cloudtrail_bucket_policy" {
  statement {
    sid    = "AWSCloudTrailAclCheck"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions   = ["s3:GetBucketAcl"]
    resources = [aws_s3_bucket.cloudtrail_events.arn]
    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values   = ["arn:aws:cloudtrail:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:trail/"]
    }
  }

  statement {
    sid    = "AWSCloudTrailWrite"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.cloudtrail_events.arn}/prefix/AWSLogs/${data.aws_caller_identity.current.account_id}/*"]

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values   = ["arn:aws:cloudtrail:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:trail/"]
    }
  }
}
