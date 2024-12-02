<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~>1.9 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_audit_buckets"></a> [audit\_buckets](#module\_audit\_buckets) | ./modules/audit_buckets | n/a |
| <a name="module_cloudtrail"></a> [cloudtrail](#module\_cloudtrail) | ./modules/cloudtrail | n/a |
| <a name="module_oidc"></a> [oidc](#module\_oidc) | ./modules/oidc | n/a |
| <a name="module_opt_in"></a> [opt\_in](#module\_opt\_in) | ./modules/opt_in | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_tags"></a> [aws\_tags](#input\_aws\_tags) | Additional AWS tags to apply to resources in this module. | `map(string)` | `{}` | no |
| <a name="input_id"></a> [id](#input\_id) | The unique identifier for this deployment. | `string` | n/a | yes |
| <a name="input_oidc_github_organization"></a> [oidc\_github\_organization](#input\_oidc\_github\_organization) | The GitHub organization that owns the repositories of interest. | `string` | n/a | yes |
| <a name="input_oidc_github_repo"></a> [oidc\_github\_repo](#input\_oidc\_github\_repo) | The GitHub repository that may be used in automated deployments. | `string` | `"*"` | no |
| <a name="input_oidc_hcp_terraform_organization"></a> [oidc\_hcp\_terraform\_organization](#input\_oidc\_hcp\_terraform\_organization) | The HCP Terraform organization that may be used in automated deployments. | `string` | n/a | yes |
| <a name="input_oidc_hcp_terraform_project"></a> [oidc\_hcp\_terraform\_project](#input\_oidc\_hcp\_terraform\_project) | The HCP Terraform project that may be used in automated deployments. | `string` | `"*"` | no |
| <a name="input_oidc_hcp_terraform_workspace"></a> [oidc\_hcp\_terraform\_workspace](#input\_oidc\_hcp\_terraform\_workspace) | The HCP Terraform workspace that may be used in automated deployments. | `string` | `"*"` | no |
| <a name="input_tgw"></a> [tgw](#input\_tgw) | The ID of the external transit gateway to associate with a VPC. | `string` | `null` | no |
| <a name="input_tgw_route"></a> [tgw\_route](#input\_tgw\_route) | The route (CIDR) to associate with the transite gateway. | `string` | `null` | no |
| <a name="input_vpc_nat"></a> [vpc\_nat](#input\_vpc\_nat) | Whether to create a NAT gateway. | `bool` | `false` | no |
| <a name="input_vpc_nat_multi_az"></a> [vpc\_nat\_multi\_az](#input\_vpc\_nat\_multi\_az) | Whether to create only a single NAT gateway for all private subnets to use, or to create a NAT gateway in each AZ. | `bool` | `false` | no |
| <a name="input_vpc_network_address"></a> [vpc\_network\_address](#input\_vpc\_network\_address) | The private IP network address to use for the VPC CIDR block. | `string` | `"10.0.0.0"` | no |
| <a name="input_vpc_network_mask"></a> [vpc\_network\_mask](#input\_vpc\_network\_mask) | The network mask to use for the VPC CIDR block. Must be between 16 and 28. | `number` | `16` | no |
| <a name="input_vpc_subnet_new_bits"></a> [vpc\_subnet\_new\_bits](#input\_vpc\_subnet\_new\_bits) | The adjustment to make to the VPC network mask (in bits) to define the subnets. | `number` | `6` | no |
| <a name="input_vpc_subnets"></a> [vpc\_subnets](#input\_vpc\_subnets) | The number of public-private subnet pairs to create. Cannot be greater than the number of AZ in this region. | `number` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cloudtrail_read_log_group"></a> [cloudtrail\_read\_log\_group](#output\_cloudtrail\_read\_log\_group) | The Read-Only CloudTrail log group. |
| <a name="output_cloudtrail_read_trail"></a> [cloudtrail\_read\_trail](#output\_cloudtrail\_read\_trail) | The Read-Only CloudTrail trail. |
| <a name="output_cloudtrail_write_log_group"></a> [cloudtrail\_write\_log\_group](#output\_cloudtrail\_write\_log\_group) | The Write-Only CloudTrail log group. |
| <a name="output_cloudtrail_write_trail"></a> [cloudtrail\_write\_trail](#output\_cloudtrail\_write\_trail) | The Write-Only CloudTrail trail. |
| <a name="output_s3_bucket_access_logs"></a> [s3\_bucket\_access\_logs](#output\_s3\_bucket\_access\_logs) | The bucket in which the bucket access logs will be stored. |
| <a name="output_s3_bucket_cloudtrail"></a> [s3\_bucket\_cloudtrail](#output\_s3\_bucket\_cloudtrail) | The bucket in which the audit data will be stored. |
| <a name="output_s3_bucket_flow_logs"></a> [s3\_bucket\_flow\_logs](#output\_s3\_bucket\_flow\_logs) | The bucket in which the VPC flow logs will be stored. |
| <a name="output_vpc"></a> [vpc](#output\_vpc) | The VPC. |
| <a name="output_vpc_private_subnets"></a> [vpc\_private\_subnets](#output\_vpc\_private\_subnets) | The private subnets. |
| <a name="output_vpc_public_subnets"></a> [vpc\_public\_subnets](#output\_vpc\_public\_subnets) | The public subnets. |
<!-- END_TF_DOCS -->