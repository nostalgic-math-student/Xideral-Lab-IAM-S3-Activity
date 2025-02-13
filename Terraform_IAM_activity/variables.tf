variable "region" {
  description = "region for the resources to be available"
  default     = "us-east-1"
}

variable "user_name" {
  description = "IAM USERNAME"
  default     = "lambdauser"
}

variable "role_name" {
  description = "IAM role name"
  default     = "lambda_full_access_role"
}