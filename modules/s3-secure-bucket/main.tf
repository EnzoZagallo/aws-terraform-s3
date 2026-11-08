# -----------------------------------------------------------------------------
# Core S3 Bucket, Public Access Block, and Versioning
#
# Why these are separate resources:
# Starting in AWS Provider v4+, HashiCorp deprecated inline settings inside
# 'aws_s3_bucket'. Splitting versioning, public access, encryption, and
# lifecycle into separate resources avoids state conflicts and makes each
# setting easier to manage independently.
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

# 1. The base S3 bucket resource
resource "aws_s3_bucket" "this" {
  bucket        = var.bucket_name
  force_destroy = var.force_destroy

  # merge() combines our standard tags with any custom tags passed into the module
  tags = merge(
    {
      Environment = var.environment
      ManagedBy   = "Terraform"
    },
    var.tags
  )
}

# 2. Block all public access by default
# Even if someone accidentally attaches a permissive ACL or policy later,
# AWS will reject public access as long as these four flags are true.
resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# 3. Object Versioning
# Keeps a history of every file change so we can recover from accidental
# overwrites or deletions.
resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id

  versioning_configuration {
    status = var.enable_versioning ? "Enabled" : "Suspended"
  }
}
