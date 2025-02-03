data "aws_caller_identity" "current" {}
resource "aws_iam_policy" "lambda_function" {
  name        = "LambdaFunctionPolicy"
  description = "Lambda Access Policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "lambda:CreateFunction",
          "lambda:UpdateFunctionCode",
          "lambda:UpdateFunctionConfiguration",
          "iam:GetRole",
          "logs:DescribeLogGroups"
        ]
        Resource = [
          "arn:aws:lambda:${var.aws_region}:${data.aws_caller_identity.current.account_id}:function:*"
        ]
      }
    ]
  })
}

# Attaching Inline Policy to the Role to access resources
resource "aws_iam_role_policy_attachment" "eks_auth_policy_attachment" {
  role       = aws_iam_role.github_oidc_role.name
  policy_arn = aws_iam_policy.lambda_function.arn
}

# S3 bucket policy to create bucket.
resource "aws_iam_policy" "s3_bucket_policy" {
  name        = "S3BucketPolicy"
  description = "allows terraform to read/write state files and only create new S3 buckets"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      # Read/Write access to the statefile bucket
      {
        Effect = "Allow"
        Action = [
          "s3:ListBucket",
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:HeadBucket"
        ]
        Resource = [
          "arn:aws:s3:::krupakaryasa",         
          "arn:aws:s3:::krupakaryasa/*"      
        ] #statefile bucket arn
      },
      # Permission to create new S3 buckets
      {
        Effect = "Allow"
        Action = [
          "s3:CreateBucket",
          "s3:ListBucket",
          "s3:HeadBucket"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "s3_bucket_policy_attachment" {
  role       = aws_iam_role.github_oidc_role.name
  policy_arn = aws_iam_policy.s3_bucket_policy.arn
}