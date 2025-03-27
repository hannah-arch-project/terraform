resource "aws_route53_zone" "shndh_kro_kr" {
    name = "shndh.kro.kr"
}

resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = "www"
  type    = "CNAME"
  ttl     = 300
  records = [var.alb_dns_name]  # ALB의 DNS 이름
}

data "aws_route53_zone" "primary" {
  name         = "shndh.kro.kr"
  private_zone = false
}