## configure backend for state configuration
terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.84.0"
    }
  }
}
module "lambda" {
  aws_region            = "us-west-2"
  environment           = var.environment
  source                = "../modules/lambda-mod"
  lambda_function_file_path = "${path.module}/../../service"
  lambda_function_name  = "lambda_function"
  handler               = "lambda_function.lambda_handler"
  runtime               = "python3.12"
  create_bedrock_policy = false
  create_s3_policy          = false
  # environment_variables = {
  #     "BEDROCK_RESOURCE_ARN" = var.bedrock_resource_arn
  #     "S3_RESOURCE_ARN" = var.s3_resource_arn
  # }
}
