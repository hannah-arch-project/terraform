output "backend_s3_bucket" {
  description = "S3 bucket name for backend deployment"
  value       = aws_s3_bucket.backend-bucket.bucket
}
