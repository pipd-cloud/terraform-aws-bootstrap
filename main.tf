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

module "oidc" {
  count                      = var.oidc_enabled ? 1 : 0
  source                     = "./modules/oidc"
  id                         = var.id
  aws_tags                   = var.aws_tags
  github_organization        = var.oidc_github_organization
  github_repo                = var.oidc_github_repo
  hcp_terraform_organization = var.oidc_hcp_terraform_organization
  hcp_terraform_project      = var.oidc_hcp_terraform_project
  hcp_terraform_workspace    = var.oidc_hcp_terraform_workspace
}
