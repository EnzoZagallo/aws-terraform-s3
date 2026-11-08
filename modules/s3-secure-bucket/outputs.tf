# -----------------------------------------------------------------------------
# Module Outputs
#
# Outputs act like return values for a Terraform module. They expose key
# attributes of the created bucket so the root configuration (or other modules,
# like IAM roles or CloudFront) can reference them.
# -----------------------------------------------------------------------------

output "bucket_id" {
  description = "The name (ID) of the S3 bucket."
  value       = aws_s3_bucket.this.id
}

output "bucket_arn" {
  description = "The ARN of the S3 bucket (used in IAM policies and bucket policies)."
  value       = aws_s3_bucket.this.arn
}

output "bucket_domain_name" {
  description = "The bucket domain name (e.g., bucketname.s3.amazonaws.com)."
  value       = aws_s3_bucket.this.bucket_domain_name
}

output "bucket_region" {
  description = "The AWS region where the bucket resides."
  value       = aws_s3_bucket.this.region
}
