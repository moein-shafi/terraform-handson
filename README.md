# Terraform on AWS — Hands-On Learning Kit (Windows 11)

This kit takes you from zero → a working AWS setup with two progressive projects and an optional remote-state backend.

**Projects**

1. `01-s3-hello` — Create a secure, private, versioned, encrypted **S3 bucket**.
2. `02-vpc-ec2` — Launch a tiny **VPC + EC2 web server** (Nginx) with safe defaults and minimal cost.
3. `03-remote-state` — (Optional) Configure **S3 + DynamoDB** for shared/locked **Terraform state**.

   * `03-remote-state/bootstrap` — One-time creation of the state bucket + lock table.

---

## Prerequisites (Windows 11)

Open **PowerShell**:

```powershell
# Install tools
winget install Amazon.AWSCLI
winget install HashiCorp.Terraform

aws --version
terraform -version

# Ensure OpenSSH client exists (already present on most Win11 installs)
ssh -V
# If missing, run PowerShell *as Administrator*:
# Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0
```

**AWS account (personal use):**

1. Secure your **root** account (MFA, strong password, no access keys).
2. Create an **IAM user** (e.g., `tf-admin`) with **AdministratorAccess** for learning.
3. Create **access keys** for that IAM user.
4. Configure an AWS CLI profile (e.g., `tf-personal`):

```powershell
aws configure --profile tf-personal
# Access key, Secret key, region (e.g., us-east-1), output json

aws sts get-caller-identity --profile tf-personal
```

> Tip: set a small **Billing budget/alert** in AWS Billing to avoid surprises.



---

## Folder Structure

```
terraform-aws-guide/
│  README.md                 ← (this file)
├─01-s3-hello/               ← S3 “hello world”
├─02-vpc-ec2/                ← VPC + EC2 + Nginx
└─03-remote-state/           ← Remote state docs
   └─bootstrap/              ← Create S3 bucket + DynamoDB table
```

---

## Typical Terraform workflow

```powershell
terraform fmt         # optional formatting
terraform validate    # optional syntax checks
terraform init        # download providers/modules, init backend
terraform plan        # preview changes
terraform apply       # create/update (type "yes")
# ... test resources ...
terraform destroy     # clean up to avoid charges
```

---

## Cost, Security & Cleanup

* **Cost**: `02-vpc-ec2` uses a tiny instance and no NAT/ALB to keep cost low. **Always destroy** labs when done.
* **Security**:

  * Keep **root** keys unused.
  * Restrict **SSH** to your IP (`your_ip_cidr = "<YOUR.IP>/32"`).
  * Use **encryption** and **block public access** on S3 (already configured).
* **Cleanup**: Run `terraform destroy` in each project you applied. For remote state, delete the S3 bucket **only after** all states using it are gone and the bucket is empty.

---

## Where to start

1. Do `01-s3-hello` (10 minutes).
2. Do `02-vpc-ec2` (20–30 minutes).
3. (Optional) Set up `03-remote-state/bootstrap`, then point your projects at it.

---

## Troubleshooting (quick)

* **AccessDenied** / **UnauthorizedOperation**: wrong profile/keys or missing permissions → check `aws sts get-caller-identity --profile ...`.
* **BucketAlreadyExists**: S3 bucket names are global → change `bucket_name`.
* **SSH timeouts**: wrong `your_ip_cidr`, or corporate/VPN firewall → verify your IP and security group.
* **State lock errors** (when using remote): wait a minute or run `terraform force-unlock <LOCK_ID>` (rare; use carefully).

