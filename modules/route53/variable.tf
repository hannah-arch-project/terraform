variable alb_dns_name {
    type = string
}

variable "cloudfront_domain_name" {
  description = "CloudFront 배포 도메인 이름"
  type        = string
}

variable "cloudfront_zone_id" {
  description = "CloudFront 배포 호스팅 영역 ID"
  type        = string
}
