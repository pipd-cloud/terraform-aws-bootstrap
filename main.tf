module "logging" {
  source   = "./modules/logging"
  id       = var.id
  aws_tags = var.aws_tags
}

module "cloudtrail" {
  count       = var.cloudtrail_enabled ? 1 : 0
  source      = "./modules/cloudtrail"
  id          = var.id
  aws_tags    = var.aws_tags
  bucket_name = module.logging.logs_bucket.bucket
}

module "opt_in" {
  count    = var.opt_in_services_enabled ? 1 : 0
  source   = "./modules/opt_in"
  id       = var.id
  aws_tags = var.aws_tags
}

module "oidc_github" {
  count             = var.oidc_github_enabled ? 1 : 0
  source            = "./modules/oidc_provider_role"
  id                = var.id
  aws_tags          = var.aws_tags
  provider_name     = "github"
  url               = "https://token.actions.githubusercontent.com"
  client_ids        = ["sts.amazonaws.com"]
  iam_policies      = var.oidc_github_managed_iam_policies
  custom_iam_policy = var.oidc_github_custom_iam_policies
  trust_policy_conditions = [
    {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    },
    {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values = [
        "repo:${var.oidc_github_organization}/${var.oidc_github_repo}:${var.oidc_github_branches}"
      ]
    }
  ]
}

module "oidc_hcp_terraform" {
  count             = var.oidc_hcp_terraform_enabled ? 1 : 0
  source            = "./modules/oidc_provider_role"
  id                = var.id
  aws_tags          = var.aws_tags
  provider_name     = "hcp-terraform"
  url               = "https://app.terraform.io"
  client_ids        = ["aws.workload.identity"]
  iam_policies      = var.oidc_hcp_terraform_managed_iam_policies
  custom_iam_policy = var.oidc_hcp_terraform_custom_iam_policies
  trust_policy_conditions = [
    {
      test     = "StringEquals"
      variable = "app.terraform.io:aud"
      values   = ["aws.workload.identity"]
    },
    {
      test     = "StringLike"
      variable = "app.terraform.io:sub"
      values   = ["organization:${var.oidc_hcp_terraform_organization}:project:${var.oidc_hcp_terraform_project}:workspace:${var.oidc_hcp_terraform_workspace}:run_phase:*"]
    }
  ]
}
