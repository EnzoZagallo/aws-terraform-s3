# -----------------------------------------------------------------------------
# Lifecycle Configuration (Cost Optimization & Data Retention)
#
# In real projects, most files are accessed frequently right after upload and
# rarely touched later. Lifecycle rules automatically move aging files to
# cheaper storage tiers and clean up old overwritten versions.
# -----------------------------------------------------------------------------

resource "aws_s3_bucket_lifecycle_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  # Versioning must be configured before applying version-based lifecycle rules
  depends_on = [aws_s3_bucket_versioning.this]

  rule {
    id     = "storage-tiering-and-version-cleanup"
    status = "Enabled"

    # Empty filter means this rule applies to all objects in the bucket
    filter {}

    # 1. Move active objects to Infrequent Access (default: after 30 days)
    transition {
      days          = var.transition_to_ia_days
      storage_class = "STANDARD_IA"
    }

    # 2. Move active objects to Glacier archive (default: after 90 days)
    transition {
      days          = var.transition_to_glacier_days
      storage_class = "GLACIER"
    }

    # 3. Delete old (overwritten) versions so versioning doesn't grow the bill forever
    noncurrent_version_expiration {
      noncurrent_days = var.noncurrent_version_expiration_days
    }
  }

  rule {
    id     = "abort-incomplete-multipart-uploads"
    status = "Enabled"

    filter {}

    # If a large multi-part upload fails halfway, AWS still charges for the
    # uploaded chunks unless we automatically clean them up.
    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }
}
