# Bootstrap — Create S3 State Bucket + DynamoDB Lock Table (Windows 11)

This module **creates** (one-time per account/region) the remote-state infrastructure.

### What it creates

* **S3 bucket** with:

  * Versioning enabled
  * AES-256 server-side encryption
  * All public access blocked
* **DynamoDB table** with:

  * PAY\_PER\_REQUEST billing
  * `LockID` string partition key

### Files

* `main.tf` — resources (S3 + DynamoDB)
* `variables.tf` — inputs (bucket name, region, profile)
* `terraform.tfvars.example` — copy to `terraform.tfvars` and edit
* `README.md` — this file

### Step-by-step (PowerShell)

```powershell
cd "$HOME\Projects\terraform-aws-guide\03-remote-state\bootstrap"

Copy-Item .\terraform.tfvars.example .\terraform.tfvars
notepad .\terraform.tfvars
# Set:
#   state_bucket_name = "unique-tf-state-bucket-12345"
#   region            = "us-east-1"       # or your region
#   aws_profile       = "tf-personal"     # optional if default

terraform init
terraform plan
terraform apply      # type 'yes'
```

### Outputs

* `state_bucket` — the S3 bucket name to use in project backends
* `lock_table` — the DynamoDB table name to use in project backends

### Verify (optional)

```powershell
aws s3 ls --profile tf-personal
aws dynamodb describe-table --table-name terraform-locks --profile tf-personal
```

### Use in a project

Copy that project’s `backend.tf.example` to `backend.tf`, fill in values, then:

```powershell
terraform init   # accept migration to S3 backend
```

### Clean up (use caution)

Only destroy this stack if:

* All projects using the backend have **migrated** off or been **destroyed**.
* The S3 bucket is **empty** and not holding any state files.

```powershell
terraform destroy
```

> **Warning:** Deleting the state bucket while it contains state files can orphan live resources or cause state loss.

