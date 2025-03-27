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

output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.frontend.domain_name
}

output "cloudfront_zone_id" {
  value = aws_cloudfront_distribution.frontend.hosted_zone_id
}
