# Provider
provider "aws" {
  region  = var.region
  profile = var.aws_profile
}

# Minimal VPC using community module (no NAT to keep costs low)
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = var.name
  cidr = var.vpc_cidr

  azs             = var.azs
  public_subnets  = var.public_subnets

  create_igw         = true
  enable_nat_gateway = false

  tags = var.tags
}

# Get a recent Ubuntu 22.04 LTS AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

# SSH key pair (reads your local public key file)
resource "aws_key_pair" "this" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
  tags       = var.tags
}

# Security group allowing HTTP from everywhere and SSH only from your IP
resource "aws_security_group" "web_sg" {
  name        = "${var.name}-web-sg"
  description = "Allow HTTP and limited SSH"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description = "SSH (your IP)"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.your_ip_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = var.tags
}

# EC2 instance in a public subnet with Nginx installed via user_data
module "web" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 5.0"

  name = "${var.name}-web"

  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = module.vpc.public_subnets[0]
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  key_name               = aws_key_pair.this.key_name
  associate_public_ip_address = true

  user_data = file("${path.module}/user_data.sh")

  tags = var.tags
}

output "web_public_ip" {
  value = module.web.public_ip
}

output "web_http_url" {
  value = "http://${module.web.public_ip}"
}
