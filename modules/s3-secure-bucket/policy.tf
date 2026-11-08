# -----------------------------------------------------------------------------
# Bucket Policy (Encryption in Transit / Enforce HTTPS)
#
# Encryption at rest protects files on disk, but we also need to make sure
# data isn't sent over plain HTTP while travelling across the network.
# This policy denies any S3 request where 'aws:SecureTransport' is false.
# -----------------------------------------------------------------------------

# Using a Terraform data source instead of raw JSON catches syntax typos
# during 'terraform validate' and makes the policy easier to read.

data "aws_iam_policy_document" "enforce_tls" {
  statement {
    sid    = "DenyInsecureHTTPTransport"
    effect = "Deny"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = ["s3:*"]

    # Must cover both the bucket itself and all objects/* inside it
    resources = [
      aws_s3_bucket.this.arn,
      "${aws_s3_bucket.this.arn}/*",
    ]

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.enforce_tls.json

  # Wait for public access block to finish first so AWS doesn't throw a
  # conflicting operation error when both resources update the bucket at once.
  depends_on = [aws_s3_bucket_public_access_block.this]
}
