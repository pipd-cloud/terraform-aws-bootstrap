data "aws_caller_identity" "current" {}

# GitHub 
data "tls_certificate" "github" {
  url = "https://token.actions.githubusercontent.com/.well-known/openid-configuration"
}

data "aws_iam_policy_document" "github_trust_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }
    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:${var.github_organization}/${var.github_repo}:*"]
    }
    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }
  }
}

data "aws_iam_policy" "github_managed_policies" {
  for_each = toset(["PowerUserAccess"])
  name     = each.value
}

# Terraform
data "tls_certificate" "terraform" {
  url = "https://app.terraform.io/.well-known/openid-configuration"
}

data "aws_iam_policy_document" "terraform_trust_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.terraform.arn]
    }
    condition {
      test     = "StringEquals"
      variable = "app.terraform.io:aud"
      values   = ["aws.workload.identity"]
    }
    condition {
      test     = "StringLike"
      variable = "app.terraform.io:sub"
      values   = ["organization:${var.hcp_terraform_organization}:project:${var.hcp_terraform_project}:workspace:${var.hcp_terraform_workspace}:run_phase:*"]
    }
  }
}

data "aws_iam_policy" "terraform_managed_policies" {
  for_each = toset(["AdministratorAccess"])
  name     = each.value
}
