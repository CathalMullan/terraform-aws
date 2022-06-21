data "aws_iam_policy_document" "github_cathal_dev_oidc" {
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
      values   = ["repo:CathalMullan/cathal.dev:*"]
    }
  }
}

resource "aws_iam_role" "github_cathal_dev" {
  name               = "github-cathal-dev"
  assume_role_policy = data.aws_iam_policy_document.github_cathal_dev_oidc.json
}

data "aws_iam_policy_document" "github_cathal_dev_policies" {
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
      "arn:aws:s3:::cmullan-state/prod/cathal.dev/terraform.tfstate"
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

  # www.cathal.dev S3 bucket
  statement {
    actions = [
      "s3:DeleteObject",
      "s3:ListBucket",
      "s3:PutObject",
    ]

    resources = [
      "arn:aws:s3:::www.cathal.dev/*",
    ]
  }
}

resource "aws_iam_role_policy" "github_cathal_dev" {
  name   = "github-cathal-dev"
  role   = aws_iam_role.github_cathal_dev.id
  policy = data.aws_iam_policy_document.github_cathal_dev_policies.json
}
