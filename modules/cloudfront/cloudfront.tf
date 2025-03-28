resource "aws_cloudfront_distribution" "frontend" {
  enabled = true
  default_root_object = "index.html"

  origin {
    domain_name = var.domain_name
    origin_id   = "frontendS3Origin"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.oai.cloudfront_access_identity_path
    }
  }

  default_cache_behavior {
    target_origin_id       = "frontendS3Origin"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    min_ttl     = 0
    default_ttl = 3600
    max_ttl     = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn = var.acm_certificate_arn
    ssl_support_method  = "sni-only"
  }

  aliases = ["www.shndh.kro.kr"]
}

resource "aws_cloudfront_origin_access_identity" "oai" {
  comment = "OAI for frontend bucket"
}

