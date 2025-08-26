variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "aws_profile" {
  description = "AWS CLI profile (optional)"
  type        = string
  default     = null
}

variable "name" {
  description = "Name prefix for resources"
  type        = string
  default     = "tf-demo"
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "azs" {
  description = "List of AZs to use"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "public_subnets" {
  description = "Public subnet CIDRs (same length/order as azs)"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "Name for the AWS key pair"
  type        = string
  default     = "tf-demo-key"
}

variable "public_key_path" {
  description = "Path to your SSH public key (e.g., ~/.ssh/id_rsa.pub)"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "your_ip_cidr" {
  description = "Your IP address in CIDR notation for SSH (e.g., 203.0.113.4/32)"
  type        = string
}

variable "tags" {
  description = "Common resource tags"
  type        = map(string)
  default = {
    Project = "tf-bigger-example"
    ManagedBy = "Terraform"
  }
}
