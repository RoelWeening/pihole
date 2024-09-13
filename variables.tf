
variable "domain_name" {
  type        = string
  description = "Domain name for the public DNS records"
}

variable "zone_id" {
  type        = string
  description = "Route53 Zone ID"
}
