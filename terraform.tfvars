# Since we cannot pass -var-file=staging.tfvars to TFC, we will use this file as common variables across Workspaces 
#   and variables related to a specific Workspace will be part of TFC Workspace Variables.
# For example, we will have Workspaces like ws-dev, ws-staging, ws-prod 

# common variables
project_prefix = "tfc-aws-s3-website"

# workspace specific variables - we should move these to TFC Workspace variables
aws_region  = "ap-south-1"
environment = "staging"
bucket_name = "staging.abhishekpradhan.com"
domain = "abhishekpradhan.com"
sub_domain = "staging"

# AWS access key credentials are already part of TFC Workspace variables as environment variables 