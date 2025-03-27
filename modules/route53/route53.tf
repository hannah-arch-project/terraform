resource "aws_route53_zone" "shndh_kro_kr" {
    name = "shndh.kro.kr"
}

# resource "aws_route53_record" "www" {
#   zone_id = data.aws_route53_zone.primary.zone_id
#   name    = "www"
#   type    = "CNAME"
#   ttl     = 300
#   records = [var.alb_dns_name]  # ALB의 DNS 이름
# }

resource "aws_route53_record" "frontend_alias" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = "www.shndh.kro.kr"
  type    = "A"

  alias {
    name                   = var.cloudfront_domain_name
    zone_id                = var.cloudfront_zone_id
    evaluate_target_health = false
  }
}

data "aws_route53_zone" "primary" {
  name         = "shndh.kro.kr"
  private_zone = false
}