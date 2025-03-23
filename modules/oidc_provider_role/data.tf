data "tls_certificate" "remote" {
  url = "${var.url}/.well-known/openid-configuration"
}

data "aws_iam_openid_connect_provider" "remote" {
  count = var.create_provider ? 1 : 0
  url   = var.url
}


data "aws_iam_policy_document" "trust" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = [var.create_provider ? aws_iam_openid_connect_provider.remote[0].arn : data.aws_iam_openid_connect_provider.remote[0].arn]
    }
    dynamic "condition" {
      for_each = { for idx, obj in var.trust_policy_conditions : idx => obj }
      content {
        test     = condition.value.test
        values   = condition.value.values
        variable = condition.value.variable
      }
    }
  }
}

data "aws_iam_policy" "managed" {
  for_each = toset(var.iam_policies)
  name     = each.value
}

data "aws_iam_policy_document" "custom" {
  dynamic "statement" {
    for_each = { for idx, obj in var.custom_iam_policy : idx => obj }
    content {
      actions       = statement.value.actions
      resources     = statement.value.resources
      effect        = statement.value.effect
      not_actions   = statement.value.not_actions
      not_resources = statement.value.not_resources
      dynamic "condition" {
        for_each = { for idx, obj in statement.value.conditions : idx => obj }
        content {
          test     = condition.value.test
          values   = condition.value.values
          variable = condition.value.variable
        }
      }
    }
  }
}