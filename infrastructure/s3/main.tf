terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.84.0"
    }
  }
}
provider "aws" {
  region = "us-east-1"
}

module "s3_bucket" {
  source      = "../modules/s3-mod"
  bucket_name = "${var.bucket_name}-${var.environment}"
  environment = var.environment
  aws_region  = var.aws_region
  tags_all    = var.tags_all
}