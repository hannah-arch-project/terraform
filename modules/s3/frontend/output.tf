# /modules/s3/output.tf

output "frontend_bucket_name" {
  value = aws_s3_bucket.frontend_bucket.bucket
}

# output "backend_bucket_name" {
#   value = aws_s3_bucket.backend_artifacts.bucket
# }

output "frontend_bucket_arn" {
  value = aws_s3_bucket.frontend_bucket.arn
}

output "domain_name" {
  value = aws_s3_bucket.frontend_bucket.bucket_regional_domain_name
}
