variable "domain_name" {
  type        = string
  description = "The domain name for the public DNS records"
}

variable "zone_id" {
  type        = string
  description = "The Route53 Zone ID"
}