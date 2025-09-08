# Generate private key
resource "tls_private_key" "alb_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}
# Generate self-signed cert
resource "tls_self_signed_cert" "alb_cert" {
  validity_period_hours = 8760  # 1 year
  early_renewal_hours   = 168   # 1 week
  private_key_pem       = tls_private_key.alb_key.private_key_pem

  subject {
    common_name  = var.domain_name  # replace with your FQDN or dummy domain
    organization = "fittmeal"
  }

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth"
  ]
}


# --- ACM Certificate ---
resource "aws_acm_certificate" "n8n_selfsigned_cert" {
  private_key       = tls_private_key.alb_key.private_key_pem
  certificate_body  = tls_self_signed_cert.alb_cert.cert_pem

  tags = {
    Name = "n8n-alb-cert"
  }
}