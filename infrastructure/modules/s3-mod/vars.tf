variable "aws_region" {
  description = "AWS region"
  type        = string

}
variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
  #   default     = "your_bucket_name"
}
variable "environment" {
  description = "Environment for the lambda function"
  type        = string

}