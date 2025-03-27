# /modules/s3/variable.tf

variable "frontend_bucket_name" {
  description = "Name of the S3 bucket for frontend hosting"
  type        = string
}

variable "acm_certificate_arn" {
    type = string
}

# variable "backend_bucket_name" {
#   description = "Name of the S3 bucket for backend CodeDeploy artifacts"
#   type        = string
# }

