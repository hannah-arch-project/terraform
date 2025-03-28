output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.frontend.domain_name
}

output "cloudfront_zone_id" {
  value = aws_cloudfront_distribution.frontend.hosted_zone_id
}

output "oai_iam_arn" {
  value = aws_cloudfront_origin_access_identity.oai.iam_arn
}