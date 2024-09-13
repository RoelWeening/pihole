module "pihole" {
  source        = "./modules/pihole"
  pihole_image  = data.aws_ecr_repository.pihole.repository_url
}

module "vpn" {
  source        = "./modules/vpn"
  vpn_image     = data.aws_ecr_repository.vpn.repository_url
}

module "route53" {
  source      = "./modules/route53"
  domain_name = var.domain_name
  zone_id     = var.zone_id
}