output "certificate_arn" {
  description = "ARN of the application certificate"
  value       = aws_acm_certificate.this.arn
}