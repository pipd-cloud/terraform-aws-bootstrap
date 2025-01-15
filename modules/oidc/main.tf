# Configure the GitHub Actions Role
resource "aws_iam_openid_connect_provider" "github" {
  url             = "https://token.actions.githubusercontent.com"
  thumbprint_list = [data.tls_certificate.github.certificates[0].sha1_fingerprint]
  client_id_list  = ["sts.amazonaws.com"]
  tags = merge(var.aws_tags, {
    Name = "GitHubActions"
    TFID = var.id
  })
}

resource "aws_iam_role" "github_role" {
  assume_role_policy = data.aws_iam_policy_document.github_trust_policy.json
  name               = "GitHubActionsRole"
  tags = merge(var.aws_tags, {
    Name = "GitHubActionsRole"
    TFID = var.id
  })
}

resource "aws_iam_policy" "github_custom_policy" {
  name        = "GitHubActionsCustomPolicy"
  description = "Allows GitHub Actions to pass any role to any service"
  policy      = data.aws_iam_policy_document.github_custom_policy.json
  tags = merge(var.aws_tags, {
    Name = "GitHubActionsCustomPolicy"
    TFID = var.id
  })
}

resource "aws_iam_role_policy_attachment" "github_custom_policy" {
  role       = aws_iam_role.github_role.name
  policy_arn = aws_iam_policy.github_custom_policy.arn
}

resource "aws_iam_role_policy_attachment" "github_managed_policies" {
  role       = aws_iam_role.github_role.name
  policy_arn = data.aws_iam_policy.github_managed_policies.arn
}


# Configure the Terraform Cloud Role
resource "aws_iam_openid_connect_provider" "terraform" {
  url             = "https://app.terraform.io"
  thumbprint_list = [data.tls_certificate.terraform.certificates[0].sha1_fingerprint]
  client_id_list  = ["aws.workload.identity"]
  tags = merge(var.aws_tags, {
    Name = "TerraformCloud"
    TFID = var.id
  })
}

resource "aws_iam_role" "terraform_role" {
  assume_role_policy = data.aws_iam_policy_document.terraform_trust_policy.json
  name               = "HCPTerraformRole"
  tags = merge(var.aws_tags, {
    Name = "HCPTerraformRole"
    TFID = var.id
  })
}

resource "aws_iam_role_policy_attachment" "terraform_managed_policies" {
  role       = aws_iam_role.terraform_role.name
  policy_arn = data.aws_iam_policy.terraform_managed_policies.arn
}
