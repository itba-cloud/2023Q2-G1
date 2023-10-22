resource "aws_cloudfront_origin_access_identity" "this" {
  comment = "OAI for cloudfront"
}

resource "aws_cloudfront_distribution" "this" {
  origin {
    domain_name = var.bucket_name
    origin_id   = var.bucket_id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.this.cloudfront_access_identity_path
    }
  }

  origin {
    domain_name = local.apigw_name
    origin_id   = local.apigw_id
    origin_path = var.apigw_stage

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"


  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = var.bucket_id
    cache_policy_id  = data.aws_cloudfront_cache_policy.optimized.id

    viewer_protocol_policy = "redirect-to-https"
  }

  # Cache behavior with precedence 0
  ordered_cache_behavior {
    target_origin_id = local.apigw_id
    path_pattern     = "/${var.apigw_path}/*"

    allowed_methods = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods  = ["GET", "HEAD"]
    cache_policy_id = data.aws_cloudfront_cache_policy.disabled.id

    viewer_protocol_policy = "redirect-to-https"
  }

  price_class = "PriceClass_200"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  # viewer_certificate {
  #   acm_certificate_arn      = var.certificate_arn
  #   ssl_support_method       = "sni-only"
  #   minimum_protocol_version = "TLSv1.2_2021"
  # }
}