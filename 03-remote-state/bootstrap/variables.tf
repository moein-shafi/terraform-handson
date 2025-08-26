variable "region" {
  description = "AWS region for state backend"
  type        = string
  default     = "us-east-1"
}

variable "aws_profile" {
  description = "AWS CLI profile (optional)"
  type        = string
  default     = null
}

variable "state_bucket_name" {
  description = "Globally-unique name for the Terraform state bucket"
  type        = string
}

variable "lock_table_name" {
  description = "Name for the DynamoDB lock table"
  type        = string
  default     = "terraform-locks"
}
