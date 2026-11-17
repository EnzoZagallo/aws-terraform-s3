# -----------------------------------------------------------------------------
# Example Input Variables
#
# These variables let us customize the example deployment per environment
# (for instance, using a .tfvars file) without editing main.tf directly.
# -----------------------------------------------------------------------------

variable "aws_region" {
  description = "AWS region where the data lake bucket will be created."
  type        = string
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "Globally unique name for the data lake S3 bucket."
  type        = string
  default     = "student-secure-data-lake-demo-2026"
}

variable "environment" {
  description = "Target deployment environment (dev, staging, or prod)."
  type        = string
  default     = "dev"
}

variable "use_localstack" {
  description = "Set to true when testing locally against a LocalStack Docker container."
  type        = bool
  default     = false
}
