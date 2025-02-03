variable "environment" {
  description = "Environment for the lambda function"
  type        = string
  default     = ""

}
variable "aws_region" {
  type = string
  description = "enter region"
  default = "ap-south-1"
}