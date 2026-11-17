# -----------------------------------------------------------------------------
# Example Outputs
#
# Displays the created bucket details in the terminal after 'terraform apply'.
# Notice how we access values exported by our module using:
# module.<module_name>.<output_name>
# -----------------------------------------------------------------------------

output "data_lake_bucket_id" {
  description = "Name of the provisioned data lake S3 bucket."
  value       = module.data_lake_bucket.bucket_id
}

output "data_lake_bucket_arn" {
  description = "ARN of the provisioned data lake S3 bucket."
  value       = module.data_lake_bucket.bucket_arn
}

output "data_lake_bucket_domain_name" {
  description = "Domain name of the provisioned data lake S3 bucket."
  value       = module.data_lake_bucket.bucket_domain_name
}
