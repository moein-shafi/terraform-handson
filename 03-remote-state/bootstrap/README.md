# Bootstrap Remote State Resources

This creates an **S3 bucket** (versioned + encrypted + private) and a **DynamoDB table** for Terraform state locking.

## Run

```bash
cp terraform.tfvars.example terraform.tfvars
terraform init
terraform apply
```

Use the outputs (`state_bucket`, `lock_table`) to fill in your project’s `backend.tf`.
