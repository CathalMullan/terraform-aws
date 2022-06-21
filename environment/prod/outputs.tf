output "github_cathal_dev_role_arn" {
  description = "GitHub Actions OIDC: cathal.dev ARN"
  value       = aws_iam_role.github_cathal_dev.arn
}
