terraform {
  # remote backend: Terraform Cloud (TFC) free
  backend "remote" {
    ## Required for Terraform Enterprise; Defaults to app.terraform.io for Terraform Cloud
    hostname = "app.terraform.io"
    # this is TFC organization, ensure to it set to reflect organization that we created in Terraform Cloud account
    organization = "tfc-aws-s3-website"

    # use prefix when using multiple workspaces, else use name for a single ws
    workspaces {
      prefix = "ws-"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Configure the AWS Provider
# AWS access key credentials are stored as environment variables in TFC Organization's Variables set, to avoid hardcoding here or leaking it on github
provider "aws" {
  region = var.aws_region
}
