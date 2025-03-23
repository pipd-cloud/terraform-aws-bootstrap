resource "aws_iam_openid_connect_provider" "remote" {
  count           = var.create_provider ? 1 : 0
  url             = var.url
  thumbprint_list = [data.tls_certificate.remote.certificates[0].sha1_fingerprint]
  client_id_list  = var.client_ids
  tags = merge(var.aws_tags, {
    Name = var.provider_name
    TFID = var.id
  })
}

resource "aws_iam_role" "remote" {
  assume_role_policy = data.aws_iam_policy_document.trust.json
  name               = "${var.provider_name}-role"
  tags = merge(var.aws_tags, {
    Name = "${var.provider_name}-role"
    TFID = var.id
  })
}

resource "aws_iam_policy" "custom" {
  name        = "${var.id}-${var.provider_name}-custom-policy"
  description = "Allows GitHub Actions to pass any role to any service"
  policy      = data.aws_iam_policy_document.custom.json
  tags = merge(var.aws_tags,
    {
      name = "${var.id}-${var.provider_name}-custom-policy"
      TFID = var.id
    }
  )
}

resource "aws_iam_role_policy_attachment" "custom" {
  role       = aws_iam_role.remote.name
  policy_arn = aws_iam_policy.custom.arn
}

resource "aws_iam_role_policy_attachment" "managed" {
  for_each   = data.aws_iam_policy.managed
  role       = aws_iam_role.remote.name
  policy_arn = each.value.arn
}
