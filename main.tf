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

module "vpc" {
  source              = "./modules/vpc"
  id                  = var.id
  aws_tags            = var.aws_tags
  bucket_name         = module.audit_buckets.flow_logs_bucket.id
  vpc_network_address = var.vpc_network_address
  vpc_network_mask    = var.vpc_network_mask
  vpc_subnet_new_bits = var.vpc_subnet_new_bits
  vpc_subnets         = var.vpc_subnets
  nat                 = var.vpc_nat
  nat_multi_az        = var.vpc_nat_multi_az
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
