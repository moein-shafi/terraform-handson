# 01 — S3 “Hello, Terraform” (Windows 11)

Creates a **private, versioned, encrypted S3 bucket** with all public access blocked.

### What you’ll learn

* Provider basics, variables, outputs
* Secure S3 defaults (block public, SSE, versioning)
* Plan / Apply / Destroy cycle

### Files

* `main.tf` — AWS provider + S3 resources
* `variables.tf` — inputs (region, bucket name, etc.)
* `outputs.tf` — prints bucket name/ARN
* `terraform.tfvars.example` — copy to `terraform.tfvars` and edit
* `README.md` — this file

### Requirements

* AWS CLI profile (e.g., `tf-personal`)
* Terraform ≥ 1.9, AWS provider \~> 5.60

### Step-by-step (PowerShell)

```powershell
cd "$HOME\Projects\terraform-aws-guide\01-s3-hello"

Copy-Item .\terraform.tfvars.example .\terraform.tfvars
notepad .\terraform.tfvars
# Set:
#   bucket_name = "globally-unique-name-12345"
#   region      = "us-east-1"        # or your region
#   aws_profile = "tf-personal"      # optional if default is set

terraform init
terraform plan
terraform apply     # type 'yes'
```

### Verify

```powershell
aws s3 ls --profile tf-personal --region us-east-1
```

You should see your bucket in the listing.

### Clean up

```powershell
terraform destroy
```

### Common pitfalls

* **Bucket name not unique** → change `bucket_name`.
* **Destroy fails** because bucket not empty → set `force_destroy = true` in `terraform.tfvars` **only for labs**, or empty bucket first.

### Next steps

* Add bucket **lifecycle rules** (e.g., transition to Glacier, expiration).
* Enable **server-access logging** to another bucket.
* Practice tagging and naming conventions.

