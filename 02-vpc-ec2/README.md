# 02 — VPC + EC2 Web Server (Windows 11)

Creates a minimal **VPC with public subnets**, a **security group**, and an **EC2 instance** (Ubuntu 22.04) that installs **Nginx** via `user_data`. Designed to be simple, secure, and cheap (no NAT, no ALB).

### What you’ll learn

* Using community modules (VPC, EC2 instance)
* Data sources (latest Ubuntu AMI)
* Ingress/egress security groups
* User data provisioning

### Architecture (high level)

* **VPC** (10.0.0.0/16)
* 2 × **public subnets** (one per AZ)
* **Internet Gateway** + public route
* **Security Group**:

  * HTTP (`80/tcp`) from anywhere
  * SSH (`22/tcp`) from **your** IP only
* **EC2** (t3.micro by default) with public IP

### Files

* `versions.tf` — required providers + versions
* `main.tf` — VPC module, SG, AMI lookup, EC2 module
* `variables.tf` — inputs (region, your\_ip\_cidr, key name, etc.)
* `outputs.tf` — prints `web_public_ip`, `web_http_url`
* `terraform.tfvars.example` — copy to `terraform.tfvars` and edit
* `user_data.sh` — installs Nginx and writes a simple index page
* `backend.tf.example` — sample backend config for remote state
* `README.md` — this file

### Requirements

* AWS CLI profile (e.g., `tf-personal`)
* **SSH key** on Windows:

```powershell
ssh-keygen -t rsa -b 4096 -f "$env:USERPROFILE\.ssh\id_rsa" -N ""
```

* Your public IP (for SSH allow-list):

```powershell
(Invoke-RestMethod https://checkip.amazonaws.com).Trim()
```

### Step-by-step (PowerShell)

```powershell
cd "$HOME\Projects\terraform-aws-guide\02-vpc-ec2"

Copy-Item .\terraform.tfvars.example .\terraform.tfvars
notepad .\terraform.tfvars
# Set at least:
#   your_ip_cidr  = "<YOUR.PUBLIC.IP>/32"
# Optionally:
#   aws_profile   = "tf-personal"
#   region, name, instance_type, etc.

terraform init
terraform plan
terraform apply     # type 'yes'
```

### Test

* Open the **`web_http_url`** output in your browser → should see “It works 🎉”.
* SSH (optional):

```powershell
ssh -i "$env:USERPROFILE\.ssh\id_rsa" ubuntu@<web_public_ip>
```

### Clean up

```powershell
terraform destroy
```

### Cost & safety

* No NAT Gateways/ALBs → very low cost while running.
* Always destroy when done.

### Troubleshooting

* **Timeout loading page**: instance still booting, or SG/Routing issue (re-apply or wait 1–2 mins).
* **SSH denied**: set `your_ip_cidr = "<YOUR.IP>/32"` correctly; confirm your IP again.
* **AMI not found**: region mismatch; keep owners = `099720109477` (Canonical) and use a standard region.

### Extensions

* Add an **Application Load Balancer** and SG rules.
* Use **private subnets** + **NAT** (more realistic; higher cost).
* Replace EC2 with **ECS Fargate** or **EKS** later.
* Add **VPC Flow Logs** to S3 and explore logs.

