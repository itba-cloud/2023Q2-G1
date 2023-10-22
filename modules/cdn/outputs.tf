output "cloudfront_distribution" {
  description = "The cloudfront distribution for the deployment"
  value       = aws_cloudfront_distribution.this
}

output "OAI" {
  description = "OAI form cloudfront"
  value       = aws_cloudfront_origin_access_identity.this.iam_arn
}