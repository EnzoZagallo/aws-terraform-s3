# -----------------------------------------------------------------------------
# Provider Configuration
#
# In Terraform, child modules (like modules/s3-secure-bucket) declare which
# provider versions they need, while the root configuration (this folder)
# configures HOW to connect to AWS (region, credentials, or LocalStack).
# -----------------------------------------------------------------------------

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region

  # When testing locally with LocalStack (use_localstack = true), we skip AWS
  # credential checks and route S3 calls to localhost:4566 instead of real AWS.
  skip_credentials_validation = var.use_localstack
  skip_metadata_api_check     = var.use_localstack
  skip_requesting_account_id  = var.use_localstack
  s3_use_path_style           = var.use_localstack

  dynamic "endpoints" {
    for_each = var.use_localstack ? [1] : []
    content {
      s3  = "http://localhost:4566"
      sts = "http://localhost:4566"
      iam = "http://localhost:4566"
    }
  }
}
