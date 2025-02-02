terraform {
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "~> 5.84.0"
        }
    }
}
provider "aws" {
  region = var.aws_region
}
## configure backend for state configuration
terraform {
    backend "s3" {
        bucket = "krupakaryasa"
        key    = "OIDC-github/terraform.tfstate"
        region = "ap-south-1"
    }
}

## create OIDC provider
resource "aws_iam_openid_connect_provider" "github" {
  url             = var.url
  client_id_list  = ["sts.amazonaws.com"]
}

## create IAM role

resource "aws_iam_role" "github_oidc_role" {
  name = var.role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_openid_connect_provider.github.arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud": "sts.amazonaws.com"
          }
          StringLike = {
            "token.actions.githubusercontent.com:sub": "repo:${var.github_organization}/${var.repo != "" ? var.repo : "*"}:ref:refs/heads/${var.branch != "" ? var.branch : "*"}"
          }

        }
      }
    ]
  })
}