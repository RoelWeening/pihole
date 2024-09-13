resource "aws_route53_record" "vpn" {
  zone_id = var.zone_id
  name    = "vpn.${var.domain_name}"
  type    = "A"
  ttl     = 300
  records = [aws_lb.vpn.dns_name]
}

resource "aws_route53_record" "pihole" {
  zone_id = var.zone_id
  name    = "pihole.${var.domain_name}"
  type    = "A"
  ttl     = 300
  records = [aws_lb.pihole.dns_name]
}