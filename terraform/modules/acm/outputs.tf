output "acm_certificate_arn" {
  description = "ARN of the ACM certificate"
  value       = aws_acm_certificate.n8n_selfsigned_cert.arn
}
output "dns_validation_record" {
  value = [
    for dvo in aws_acm_certificate.n8n_selfsigned_cert.domain_validation_options : {
      domain_name = dvo.domain_name
      name        = dvo.resource_record_name
      type        = dvo.resource_record_type
      value       = dvo.resource_record_value
    }
  ]
}