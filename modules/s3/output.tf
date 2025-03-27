# /modules/s3/output.tf

output "frontend_bucket_name" {
  value = aws_s3_bucket.frontend_bucket.bucket
}

output "backend_bucket_name" {
  value = aws_s3_bucket.backend_artifacts.bucket
}
