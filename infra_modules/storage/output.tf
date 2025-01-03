output "bucket_name" {
  description = "The name of the S3 bucket"
  value       = local.bucket_name
}

################################################################################
# S3
################################################################################
output "s3_bucket_id" {
  description = "The ID of the S3 bucket"
  value       = module.s3.s3_bucket_id
}

output "s3_bucket_arn" {
  description = "The ARN of the S3 bucket"
  value       = module.s3.s3_bucket_arn
}

output "s3_bucket_domain_name" {
  description = "The bucket domain name"
  value       = module.s3.s3_bucket_bucket_domain_name
}
