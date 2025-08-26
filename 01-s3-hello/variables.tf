variable "region" {
  description = "AWS region to use"
  type        = string
  default     = "us-east-1"
}

variable "aws_profile" {
  description = "AWS CLI profile name to use (optional)"
  type        = string
  default     = null
}

variable "bucket_name" {
  description = "Globally-unique S3 bucket name (e.g., yourname-tf-demo-12345)"
  type        = string
}

variable "enable_versioning" {
  description = "Enable S3 bucket versioning"
  type        = bool
  default     = true
}

variable "force_destroy" {
  description = "Allow bucket to be destroyed even if non-empty (use with caution)"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
  default = {
    Project = "tf-basics"
  }
}
