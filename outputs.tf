output "project-resource-group" {
  description = "always create resource group, so that we can quickly find all the resources belonging to this specific project via tags"
  value       = aws_resourcegroups_group.rg_project.id
}

output "bucket-details" {
  value = aws_s3_bucket.site
}

output "bucket-config" {
  value = aws_s3_bucket_website_configuration.site_config
}

output "website-domain" {
  description = "used to create Route53 record type A (alias) to point to S3 bucket"
  value       = aws_s3_bucket_website_configuration.site_config.website_domain
}
