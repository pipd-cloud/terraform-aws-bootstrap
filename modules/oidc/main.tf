# Configure the GitHub Actions Role
resource "aws_iam_openid_connect_provider" "github" {
  url             = "https://token.actions.githubusercontent.com"
  thumbprint_list = [data.tls_certificate.github.certificates[0].sha1_fingerprint]
  client_id_list  = ["sts.amazonaws.com"]
}

resource "aws_iam_role" "github_role" {
  assume_role_policy = data.aws_iam_policy_document.github_trust_policy.json
  name               = "GitHubActionsRole"
}

resource "aws_iam_role_policy_attachment" "github_managed_policies" {
  for_each   = data.aws_iam_policy.github_managed_policies
  role       = aws_iam_role.github_role.name
  policy_arn = each.value.arn
}


# Configure the Terraform Cloud Role
resource "aws_iam_openid_connect_provider" "terraform" {
  url             = "https://app.terraform.io"
  thumbprint_list = [data.tls_certificate.terraform.certificates[0].sha1_fingerprint]
  client_id_list  = ["aws.workload.identity"]
}

resource "aws_iam_role" "terraform_role" {
  assume_role_policy = data.aws_iam_policy_document.terraform_trust_policy.json
  name               = "HCPTerraformRole"
}

resource "aws_iam_role_policy_attachment" "terraform_managed_policies" {
  for_each   = data.aws_iam_policy.terraform_managed_policies
  role       = aws_iam_role.terraform_role.name
  policy_arn = each.value.arn
}
