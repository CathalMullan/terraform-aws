data "aws_iam_policy_document" "github_terraform_website_oidc" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:CathalMullan/terraform-website:*"]
    }
  }
}

resource "aws_iam_role" "github_terraform_website" {
  name               = "github-terraform-website"
  assume_role_policy = data.aws_iam_policy_document.github_terraform_website_oidc.json
}

data "aws_iam_policy_document" "github_terraform_website_policies" {
  # Terraform Defaults
  statement {
    actions = [
      "s3:ListBucket"
    ]

    resources = [
      "arn:aws:s3:::cmullan-state"
    ]
  }

  statement {
    actions = [
      "s3:GetObject",
      "s3:PutObject",
    ]

    resources = [
      "arn:aws:s3:::cmullan-state/prod/terraform-website/terraform.tfstate"
    ]
  }

  statement {
    actions = [
      "dynamodb:DeleteItem",
      "dynamodb:GetItem",
      "dynamodb:PutItem",
    ]

    resources = [
      "arn:aws:dynamodb:*:*:table/cmullan-state-lock"
    ]
  }

  # AWS Certificate Manager
  statement {
    actions = [
      "acm:AddTagsToCertificate",
      "acm:DeleteCertificate",
      "acm:DescribeCertificate",
      "acm:ImportCertificate",
      "acm:ListTagsForCertificate",
    ]

    resources = [
      "arn:aws:acm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:certificate/*",
    ]
  }

  # Route 53
  statement {
    actions = [
      "route53:ChangeResourceRecordSets",
      "route53:GetChange",
      "route53:GetHostedZone",
      "route53:ListResourceRecordSets",
      "route53:ListTagsForResource",
    ]

    resources = [
      "arn:aws:route53:::hostedzone/*",
      "arn:aws:route53:::change/*",
    ]
  }

  statement {
    actions = [
      "route53:ListHostedZones",
    ]

    resources = [
      "*"
    ]
  }
}

resource "aws_iam_role_policy" "github_terraform_website" {
  name   = "github-terraform-website"
  role   = aws_iam_role.github_terraform_website.id
  policy = data.aws_iam_policy_document.github_terraform_website_policies.json
}
