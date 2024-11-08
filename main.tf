module "audit_buckets" {
  source     = "./modules/audit_buckets"
  id         = var.id
  aws_tags   = var.aws_tags
  debug_mode = true
}
module "cloudtrail" {
  source      = "./modules/cloudtrail"
  id          = var.id
  aws_tags    = var.aws_tags
  bucket_name = module.audit_buckets.cloudtrail_bucket.id
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
