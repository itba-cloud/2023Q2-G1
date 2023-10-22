resource "aws_route53_zone" "this" {
  name = var.base_domain
}

resource "aws_route53_record" "this" {
  depends_on = [
    aws_route53_zone.this
  ]
  zone_id = aws_route53_zone.this.zone_id
  type    = "A"
  name    = var.base_domain
  alias {
    name                   = var.cdn.domain_name
    zone_id                = var.cdn.hosted_zone_id
    evaluate_target_health = false
  }
}

# resource "aws_route53_record" "www" {
#   zone_id = aws_route53_zone.primathisry.zone_id
#   name    = "www.${var.base_domain}"
#   type    = "A"
#   ttl     = 600
#   records = ["${var.base_domain}"]
#    depends_on = [
#     aws_route53_record.this
#   ]
# }