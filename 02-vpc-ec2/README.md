# 03 — Remote State with S3 + DynamoDB (Windows 11)

Terraform keeps a **state file** describing real resources. Storing it **locally** is fine for solo experiments, but using **S3** with **DynamoDB locking** is safer and enables collaboration, CI, and multiple machines.

### What you’ll set up

* **S3 bucket** for Terraform state (`versioned`, `encrypted`, `private`).
* **DynamoDB table** for **state locking** (prevents concurrent writes).

> You create these once per account/region and reuse them across projects.

### Structure

* `BACKEND-S3.md` — overview (this doc’s concepts)
* `bootstrap/` — Terraform that actually creates the bucket + table

### One-time bootstrap (create backend)

See the `bootstrap/` README below for exact steps. In short:

```powershell
cd "$HOME\Projects\terraform-aws-guide\03-remote-state\bootstrap"
Copy-Item .\terraform.tfvars.example .\terraform.tfvars
notepad .\terraform.tfvars
terraform init
terraform apply
```

Record outputs:

* `state_bucket` (S3 bucket name)
* `lock_table` (DynamoDB table name)

### Point a project at the backend

Example for `02-vpc-ec2`:

```powershell
cd "$HOME\Projects\terraform-aws-guide\02-vpc-ec2"
Copy-Item .\backend.tf.example .\backend.tf
notepad .\backend.tf
# Fill in:
#   bucket         = "<your state bucket>"
#   key            = "projects/02-vpc-ec2/terraform.tfstate"
#   region         = "us-east-1"             # or your region
#   profile        = "tf-personal"
#   dynamodb_table = "<your lock table>"

terraform init   # accept state migration
```

### Tips

* Choose a clear `key` path per project (e.g., `projects/<name>/terraform.tfstate`).
* Don’t delete the state bucket unless every project using it has been migrated/destroyed and the bucket is **empty**.

