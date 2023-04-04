locals {
  common_tags = {
    Name        = var.project_prefix
    Environment = var.environment
    Terraform   = true
  }
}

# always create resource group, so that we can quickly find all the resources belonging to this specific project via tags
resource "aws_resourcegroups_group" "rg_project" {
  name        = "rg-${var.project_prefix}"
  description = "Terraform project for- ${var.project_prefix}"

  # remember to get below JSON from AWS resource group page! 
  resource_query {
    query = <<JSON
      {
        "ResourceTypeFilters": [
          "AWS::AllSupported"
        ],
        "TagFilters": [
          {
            "Key": "Name",
            "Values": ["${local.common_tags.Name}"]
          },    
          {
            "Key": "Environment",
            "Values": ["${local.common_tags.Environment}"]
          },
          {
            "Key": "Terraform",
            "Values": ["true"]
          }    
        ]
      }
      JSON
  }
}

# S3 bucket with static website hosting enabled
resource "aws_s3_bucket" "site" {
  bucket = var.bucket_name

  tags = local.common_tags
}

resource "aws_s3_bucket_website_configuration" "site_config" {
  bucket = aws_s3_bucket.site.id

  index_document {
    suffix = "index.html"
  }

  # todo
  # error_document {
  #   key = "error.html"
  # }
}

resource "aws_s3_bucket_acl" "site_acl" {
  bucket = aws_s3_bucket.site.id

  acl = "public-read"
}

resource "aws_s3_bucket_policy" "site_policy" {
  bucket = aws_s3_bucket.site.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource = [
          aws_s3_bucket.site.arn,
          "${aws_s3_bucket.site.arn}/*",
        ]
      },
    ]
  })
}

resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_encryption" {
  bucket = aws_s3_bucket.site.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
    bucket_key_enabled = true
  }
}

# Uploading a file to a bucket
# For demo purposes, I am having app code as part of IaC. 
# In real world, this should be avoided. Instead have a different repo for app (website) and levearage CodePipeline to deploy app
resource "aws_s3_object" "object" {
  bucket = aws_s3_bucket.site.id
  key    = "index.html"
  source = "website/index.html"

  # The filemd5() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
  # etag = "${md5(file("path/to/file"))}"
  etag = filemd5("website/index.html")

  content_type = "text/html"
}

# Route53 public hosted zone to point to S3 static website endpoint
# Here I already have created public hosted zone with domain=abhishekpradhan.com, hence just getting it via data & not creating it 
data "aws_route53_zone" "selected_zone" {
  name         = var.domain
  private_zone = false
}

# now create subdomain: staging as an A record with Alias to S3 bucket
resource "aws_route53_record" "staging_a_alias" {
  zone_id = data.aws_route53_zone.selected_zone.id
  name    = "${var.sub_domain}.${var.domain}"
  type    = "A"

  alias {
    name                   = aws_s3_bucket_website_configuration.site_config.website_domain
    zone_id                = aws_s3_bucket.site.hosted_zone_id
    evaluate_target_health = true
  }
}


# todo: TLS certificate to be uploaded to us-east-1 ACM, this cert will be used in CloudFront distro

# todo: CloudFront distribution

# todo: Route53 public hosted zone to point to CloudFront distro