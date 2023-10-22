output "s3_bucket_id" {
  description = "bucket id"
  value       = module.aws_bucket.s3_bucket_id
}

output "domain_name" {
  description = "Domain Name"
  value       = module.aws_bucket.s3_bucket_bucket_regional_domain_name
}