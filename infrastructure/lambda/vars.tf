variable "environment" {
  description = "Environment for the lambda function"
  type        = string
  default     = "stg"

}
variable "aws_region" {
  type        = string
  description = "enter aws region"
  default     = "us-east-1"
}
variable "tags_all" {
  description = "set tags"
  type        = map(string)
  default = {
    Environment = "stg"
    managed_by  = "terraform"
    terraform   = "true"
    Project     = "Expense-Tracker-LLM"
  }
}