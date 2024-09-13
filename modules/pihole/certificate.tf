resource "tls_private_key" "self_signed" {
  count     = var.use_self_signed == true ? 1 : 0
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "tls_self_signed_cert" "self_signed" {
  count           = var.use_self_signed == true ? 1 : 0
  private_key_pem = tls_private_key.self_signed[0].private_key_pem

  dns_names = ["*.elb.${data.aws_region.current.name}.amazonaws.com"]

  subject {
    common_name = "PiHole on AWS"
  }

  validity_period_hours = 8760 #1 Year

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}

resource "aws_acm_certificate" "cert" {
  private_key      = var.use_self_signed == true ? tls_private_key.self_signed[0].private_key_pem : var.private_key
  certificate_body = var.use_self_signed == true ? tls_self_signed_cert.self_signed[0].cert_pem : var.certificate_body
}