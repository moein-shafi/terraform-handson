# 01 — S3 Hello

Creates a **private, versioned, encrypted S3 bucket**.

## How to run

```bash
# In this folder:
cp terraform.tfvars.example terraform.tfvars  # then edit values

terraform init
terraform plan
terraform apply
```

## Verify

```bash
aws s3 ls --profile <your_profile_optional> --region <your_region>
```

## Clean up

```bash
terraform destroy
```
