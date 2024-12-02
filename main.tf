module "audit_buckets" {
  source   = "./modules/audit_buckets"
  id       = var.id
  aws_tags = var.aws_tags
}

module "cloudtrail" {
  source      = "./modules/cloudtrail"
  id          = var.id
  aws_tags    = var.aws_tags
  bucket_name = module.audit_buckets.cloudtrail_bucket.id
}

module "opt_in" {
  source   = "./modules/opt_in"
  id       = var.id
  aws_tags = var.aws_tags
}

module "oidc" {
  source                     = "./modules/oidc"
  id                         = var.id
  aws_tags                   = var.aws_tags
  github_organization        = var.oidc_github_organization
  github_repo                = var.oidc_github_repo
  hcp_terraform_organization = var.oidc_hcp_terraform_organization
  hcp_terraform_project      = var.oidc_hcp_terraform_project
  hcp_terraform_workspace    = var.oidc_hcp_terraform_workspace
}
