<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.9 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.81 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cloudtrail"></a> [cloudtrail](#module\_cloudtrail) | ./modules/cloudtrail | n/a |
| <a name="module_logging"></a> [logging](#module\_logging) | ./modules/logging | n/a |
| <a name="module_oidc_github"></a> [oidc\_github](#module\_oidc\_github) | ./modules/oidc_provider_role | n/a |
| <a name="module_oidc_hcp_terraform"></a> [oidc\_hcp\_terraform](#module\_oidc\_hcp\_terraform) | ./modules/oidc_provider_role | n/a |
| <a name="module_opt_in"></a> [opt\_in](#module\_opt\_in) | ./modules/opt_in | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_tags"></a> [aws\_tags](#input\_aws\_tags) | Additional AWS tags to apply to resources in this module. | `map(string)` | `{}` | no |
| <a name="input_cloudtrail_enabled"></a> [cloudtrail\_enabled](#input\_cloudtrail\_enabled) | Whether to enable CloudTrail logging. | `bool` | `false` | no |
| <a name="input_id"></a> [id](#input\_id) | The unique identifier for this deployment. | `string` | n/a | yes |
| <a name="input_oidc_github_branches"></a> [oidc\_github\_branches](#input\_oidc\_github\_branches) | The branches from which GitHub Actions may assume a role on AWS. | `string` | `"*"` | no |
| <a name="input_oidc_github_custom_iam_policies"></a> [oidc\_github\_custom\_iam\_policies](#input\_oidc\_github\_custom\_iam\_policies) | List of custom IAM policy statements to grant the GitHub Actions agent. | <pre>list(<br/>    object(<br/>      {<br/>        actions       = list(string)<br/>        resources     = list(string)<br/>        effect        = optional(string)<br/>        not_actions   = optional(list(string))<br/>        not_resources = optional(list(string))<br/>        conditions = optional(<br/>          list(<br/>            object(<br/>              {<br/>                test     = string<br/>                values   = list(string)<br/>                variable = string<br/>              }<br/>            )<br/>          )<br/>        )<br/>      }<br/>    )<br/>  )</pre> | <pre>[<br/>  {<br/>    "actions": [<br/>      "iam:PassRole"<br/>    ],<br/>    "conditions": [<br/>      {<br/>        "test": "StringEquals",<br/>        "values": [<br/>          "batch.amazonaws.com",<br/>          "ecs-tasks.amazonaws.com",<br/>          "ecs.amazonaws.com"<br/>        ],<br/>        "variable": "iam:PassedToService"<br/>      }<br/>    ],<br/>    "resources": [<br/>      "*"<br/>    ]<br/>  }<br/>]</pre> | no |
| <a name="input_oidc_github_enabled"></a> [oidc\_github\_enabled](#input\_oidc\_github\_enabled) | Whether to enable GitHub OIDC integration. | `bool` | `false` | no |
| <a name="input_oidc_github_managed_iam_policies"></a> [oidc\_github\_managed\_iam\_policies](#input\_oidc\_github\_managed\_iam\_policies) | List of managed IAM policies that the GitHub Actions agent is granted. | `list(string)` | <pre>[<br/>  "PowerUserAccess"<br/>]</pre> | no |
| <a name="input_oidc_github_organization"></a> [oidc\_github\_organization](#input\_oidc\_github\_organization) | The GitHub organization that owns the repositories of interest. | `string` | `null` | no |
| <a name="input_oidc_github_repo"></a> [oidc\_github\_repo](#input\_oidc\_github\_repo) | The GitHub repository that may be used in automated deployments. | `string` | `"*"` | no |
| <a name="input_oidc_hcp_terraform_custom_iam_policies"></a> [oidc\_hcp\_terraform\_custom\_iam\_policies](#input\_oidc\_hcp\_terraform\_custom\_iam\_policies) | List of custom IAM policy statements to grant the HCP TF agent. | <pre>list(<br/>    object(<br/>      {<br/>        actions       = list(string)<br/>        resources     = list(string)<br/>        effect        = optional(string)<br/>        not_actions   = optional(list(string))<br/>        not_resources = optional(list(string))<br/>        conditions = optional(<br/>          list(<br/>            object(<br/>              {<br/>                test     = string<br/>                values   = list(string)<br/>                variable = string<br/>              }<br/>            )<br/>          )<br/>        )<br/>      }<br/>    )<br/>  )</pre> | `[]` | no |
| <a name="input_oidc_hcp_terraform_enabled"></a> [oidc\_hcp\_terraform\_enabled](#input\_oidc\_hcp\_terraform\_enabled) | Whether to enable HCP Terraform OIDC integration. | `bool` | `false` | no |
| <a name="input_oidc_hcp_terraform_managed_iam_policies"></a> [oidc\_hcp\_terraform\_managed\_iam\_policies](#input\_oidc\_hcp\_terraform\_managed\_iam\_policies) | List of managed IAM policies that the HCP TF agent is granted. | `list(string)` | <pre>[<br/>  "AdministratorAccess"<br/>]</pre> | no |
| <a name="input_oidc_hcp_terraform_organization"></a> [oidc\_hcp\_terraform\_organization](#input\_oidc\_hcp\_terraform\_organization) | The HCP Terraform organization that may be used in automated deployments. | `string` | `null` | no |
| <a name="input_oidc_hcp_terraform_project"></a> [oidc\_hcp\_terraform\_project](#input\_oidc\_hcp\_terraform\_project) | The HCP Terraform project that may be used in automated deployments. | `string` | `"*"` | no |
| <a name="input_oidc_hcp_terraform_workspace"></a> [oidc\_hcp\_terraform\_workspace](#input\_oidc\_hcp\_terraform\_workspace) | The HCP Terraform workspace that may be used in automated deployments. | `string` | `"*"` | no |
| <a name="input_opt_in_services_enabled"></a> [opt\_in\_services\_enabled](#input\_opt\_in\_services\_enabled) | Whether to enable opt-in services. | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cloudtrail_read_log_group"></a> [cloudtrail\_read\_log\_group](#output\_cloudtrail\_read\_log\_group) | The Read-Only CloudTrail log group. |
| <a name="output_cloudtrail_read_trail"></a> [cloudtrail\_read\_trail](#output\_cloudtrail\_read\_trail) | The Read-Only CloudTrail trail. |
| <a name="output_cloudtrail_write_log_group"></a> [cloudtrail\_write\_log\_group](#output\_cloudtrail\_write\_log\_group) | The Write-Only CloudTrail log group. |
| <a name="output_cloudtrail_write_trail"></a> [cloudtrail\_write\_trail](#output\_cloudtrail\_write\_trail) | The Write-Only CloudTrail trail. |
| <a name="output_logs_bucket"></a> [logs\_bucket](#output\_logs\_bucket) | The bucket in which all logs are stored for this deployment. |
<!-- END_TF_DOCS -->