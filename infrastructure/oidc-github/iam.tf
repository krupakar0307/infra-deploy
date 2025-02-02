
resource "aws_iam_policy" "lambda_function" {
    name        = "LambdaFunctionPolicy"
    description = "Lambda Access Policy"

    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Effect   = "Allow"
                Action   = [
                    "lambda:CreateFunction",
                    "lambda:UpdateFunctionCode",
                    "lambda:UpdateFunctionConfiguration",
                    "lambda:DeleteFunction"
                ]
                Resource = "*" #later attach to specific resource with strict policy
            }
        ]
    })
}

# Attaching Inline Policy to the Role to access resources
resource "aws_iam_role_policy_attachment" "eks_auth_policy_attachment" {
  role       = aws_iam_role.github_oidc_role.name
  policy_arn = aws_iam_policy.lambda_function.arn
}