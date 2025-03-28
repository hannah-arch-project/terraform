# /modules/s3/variable.tf

variable "frontend_bucket_name" {
  description = "Name of the S3 bucket for frontend hosting"
  type        = string
}

variable "oai_iam_arn" {
  type = string
}

