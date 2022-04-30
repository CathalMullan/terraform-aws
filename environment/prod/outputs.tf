output "github_terraform_website_role_arn" {
  description = "GitHub Actions OIDC: Terraform Website ARN"
  value       = aws_iam_role.github_terraform_website.arn
}
