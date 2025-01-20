locals {
  aws_elb_accounts = [
    "127311923021",
    "033677994240",
    "027434742980",
    "797873946194",
    "098369216593",
    "754344448648",
    "589379963580",
    "718504428378",
    "383597477331",
    "600734575887",
    "114774131450",
    "783225319266",
    "582318560864",
    "985666609251",
    "054676820928",
    "156460612806",
    "652711504416",
    "635631232127",
    "009996457667",
    "897822967062",
    "076674570225",
    "507241528517"
  ]
}
data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "logs" {
  # Grant CloudTrail the ability to write to the bucket
  statement {
    sid    = "AWSCloudTrailAclCheck"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions   = ["s3:GetBucketAcl"]
    resources = [aws_s3_bucket.logs.arn]
  }

  statement {
    sid    = "AWSCloudTrailWrite"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.logs.arn}/*"]

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }

  # Grant VPC Flow Logs the ability to write to the bucket
  statement {
    sid    = "AWSFlowLogsWrite"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }
    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.logs.arn}/*"]
    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [data.aws_caller_identity.current.account_id]
    }
  }
  statement {
    sid = "AWSFlowLogsRead"
    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }
    actions   = ["s3:Get*", "s3:List*"]
    resources = [aws_s3_bucket.logs.arn]
    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [data.aws_caller_identity.current.account_id]
    }
    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values   = ["arn:aws:logs:*:${data.aws_caller_identity.current.account_id}:*"]
    }
  }

  # Grant S3 Access Logs the ability to write to the bucket
  statement {
    sid    = "AWSS3AccessLogsWrite"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["logging.s3.amazonaws.com"]
    }
    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.logs.arn}/*"]
    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [data.aws_caller_identity.current.account_id]
    }
  }

  # Grant ELB Logs the ability to write to the bucket
  # Pre-2022 regions
  dynamic "statement" {
    for_each = toset(local.aws_elb_accounts)
    content {
      sid = "AWSELBLogsWrite-${statement.value}"
      principals {
        type        = "AWS"
        identifiers = [statement.value]
      }
      actions   = ["s3:PutObject"]
      resources = ["${aws_s3_bucket.logs.arn}/*"]
    }
  }

  # Post-2022 regions
  statement {
    sid = "AWSELBLogsWriteService"
    principals {
      type        = "Service"
      identifiers = ["logdelivery.elasticloadbalancing.amazonaws.com"]
    }
    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.logs.arn}/*"]
  }
}
