# Local Setup & How to Run

This guide covers the tools needed to validate and test this Terraform project locally.

## 1. Prerequisites
- **Terraform CLI** (`>= 1.5.0`): `terraform -version`
- **AWS CLI** (`>= 2.0`): `aws --version`
- **Docker Desktop** *(optional)*: Used to run **LocalStack** so you can test deploying the bucket locally without needing a paid AWS account.

## 2. Validating the Code (No AWS Account Needed)
You can check code formatting and validate the Terraform syntax completely offline:

```powershell
# 1. Check formatting across all files
terraform fmt -check -recursive

# 2. Initialize the example without a remote state backend and validate syntax
terraform -chdir=examples/secure-data-lake init -backend=false
terraform -chdir=examples/secure-data-lake validate
```

## 3. Testing with LocalStack (Optional Local Emulation)
If you want to run `terraform plan` and `terraform apply` locally using Docker:

```powershell
# 1. Start LocalStack container
docker run --rm -d --name localstack -p 4566:4566 localstack/localstack

# 2. Set dummy credentials for the current terminal session
$env:AWS_ACCESS_KEY_ID="test"
$env:AWS_SECRET_ACCESS_KEY="test"
$env:AWS_DEFAULT_REGION="us-east-1"

# 3. Run Terraform inside the example directory
cd examples/secure-data-lake
cp terraform.tfvars.example terraform.tfvars
terraform init
terraform plan
terraform apply
```

To clean up resources when done:
```powershell
terraform destroy
```
