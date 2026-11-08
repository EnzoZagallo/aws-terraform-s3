# -----------------------------------------------------------------------------
# Module Input Variables
#
# Every variable defines an explicit 'type' and 'description' so anyone using
# the module knows what values are expected. Simple validation blocks help
# catch typos early during 'terraform plan' before AWS returns an API error.
# -----------------------------------------------------------------------------

variable "bucket_name" {
  description = "Globally unique name for the S3 bucket (must be 3-63 characters, lowercase)."
  type        = string

  validation {
    condition     = length(var.bucket_name) >= 3 && length(var.bucket_name) <= 63
    error_message = "Bucket name must be between 3 and 63 characters long."
  }
}

variable "environment" {
  description = "Deployment environment name (e.g., dev, staging, prod) used for tagging."
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod."
  }
}

variable "force_destroy" {
  description = "If true, allows Terraform to delete the bucket even if it is not empty. Keep false in prod."
  type        = bool
  default     = false
}

variable "enable_versioning" {
  description = "Enable object versioning to protect against accidental deletions or overwrites."
  type        = bool
  default     = true
}

variable "sse_algorithm" {
  description = "Server-side encryption algorithm to use: 'AES256' (SSE-S3) or 'aws:kms' (SSE-KMS)."
  type        = string
  default     = "AES256"

  validation {
    condition     = contains(["AES256", "aws:kms"], var.sse_algorithm)
    error_message = "sse_algorithm must be either 'AES256' or 'aws:kms'."
  }
}

variable "kms_key_arn" {
  description = "KMS key ARN to use when sse_algorithm is set to 'aws:kms'."
  type        = string
  default     = null
}

variable "transition_to_ia_days" {
  description = "Number of days before moving current objects to Standard-IA (Infrequent Access)."
  type        = number
  default     = 30
}

variable "transition_to_glacier_days" {
  description = "Number of days before moving current objects to Glacier Flexible Retrieval."
  type        = number
  default     = 90
}

variable "noncurrent_version_expiration_days" {
  description = "Number of days to keep old (overwritten) object versions before deleting them."
  type        = number
  default     = 90
}

variable "tags" {
  description = "Additional key-value tags to attach to the S3 bucket."
  type        = map(string)
  default     = {}
}
