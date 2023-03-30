
variable "aws_region" {
  description = "Setting to default AWS Region of North Virginia, in case we forget to set it"
  type        = string
  default     = "us-east-1"
}

variable "project_prefix" {
  description = "Setting project prefix instead of hardcoding it across TF configs"
  type        = string
}

variable "environment" {
  type = string
}

variable "bucket_name" {
  type = string
}