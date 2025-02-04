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
  description = "Environment for the S3 Bucket"
  type        = string

}
variable "tags_all" {
  description = "set tags"
  type        = map(string)
  default = {
    Environment = ""
    managed_by  = "terraform"
    terraform   = "true"
    Project     = "Expense-Tracker-LLM"
  }
}