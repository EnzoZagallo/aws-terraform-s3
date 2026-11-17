# -----------------------------------------------------------------------------
# Real-Life Scenario: Secure Data Lake Bucket
#
# Use case:
# A team collects daily raw application logs and CSV exports into a central S3
# bucket. Active files from the last 30 days are queried frequently, older files
# move to cheaper storage (Standard-IA after 30 days, Glacier after 90 days),
# and public access is strictly blocked so internal data is never leaked.
# -----------------------------------------------------------------------------

module "data_lake_bucket" {
  source = "../../modules/s3-secure-bucket"

  bucket_name = var.bucket_name
  environment = var.environment

  # In dev/testing we allow destroying the bucket easily during cleanup,
  # in prod this stays false so data cannot be wiped by mistake.
  force_destroy = var.environment == "dev" ? true : false

  # Keep file history enabled and encrypt everything with AES256 (SSE-S3)
  enable_versioning = true
  sse_algorithm     = "AES256"

  # Lifecycle rules to reduce storage costs as data ages
  transition_to_ia_days              = 30
  transition_to_glacier_days         = 90
  noncurrent_version_expiration_days = 90

  tags = {
    Project = "DataLake"
    Role    = "RawDataStorage"
  }
}
