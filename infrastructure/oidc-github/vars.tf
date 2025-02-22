variable "aws_region" {
  description = "Provide AWS Region to create resources"
  default     = "ap-south-1"
  type        = string
}
variable "url" {
  description = "value of the URL"
  type        = string
  default     = "https://token.actions.githubusercontent.com"
}

variable "role_name" {
  description = "Role that is attached to OIDC"
  default     = "github_oidc_role-dev"
  type        = string
}
variable "github_organization" {
  description = "Enter github organization name for accessing to aws"
  default     = "krupakar0307"
  type        = string
}

# Restricting access to resources from the OIDC created above to a specific branch in the repository.
# If the branch is not provided, it will allow access to all branches.
variable "repo" {
  description = "Enter github repo name to restrict access for specific repo"
  default     = ""
  type        = string
}
variable "branch" {
  description = "enter the branch name to run ci/cd actions"
  default     = ""
  type        = string
}



