output "project-resource-group" {
  description = "always create resource group, so that we can quickly find all the resources belonging to this specific project via tags"
  value       = aws_resourcegroups_group.rg_project.id
}
output "website-domain" {
  value = aws_s3_bucket_website_configuration.site_config.website_domain
}

output "website-endpoint" {
  value = aws_s3_bucket_website_configuration.site_config.website_endpoint
}

output "bucket-details" {
  value = aws_s3_bucket.site
}
