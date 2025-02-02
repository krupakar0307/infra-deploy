variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"

}
variable "environment" {
  description = "Environment for the lambda function"
  type        = string
  default     = "development"
}
variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
  default     = "test-demo-llm-0415"
}
