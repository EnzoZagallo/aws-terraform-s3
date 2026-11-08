# -----------------------------------------------------------------------------
# Server-Side Encryption (Encryption at Rest)
#
# Encrypts all objects before they are written to disk inside AWS data centers.
# By default, this module uses 'AES256' (SSE-S3), which is managed by AWS at
# no extra cost. If a custom KMS key is needed, callers can set sse_algorithm
# to 'aws:kms' and pass kms_key_arn.
# -----------------------------------------------------------------------------

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = var.sse_algorithm
      kms_master_key_id = var.sse_algorithm == "aws:kms" ? var.kms_key_arn : null
    }

    # S3 Bucket Keys reduce KMS request costs by generating a short-lived
    # bucket-level key instead of calling KMS for every single object upload.
    bucket_key_enabled = true
  }
}
