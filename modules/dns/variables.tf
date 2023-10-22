variable "base_domain" {
  description = "Base domain of the application."
  type        = string
}

variable "cdn" {
  description = "CloudFront distribution used for the primary deployment"
  type = object({
    domain_name    = string
    hosted_zone_id = string
  })
}
