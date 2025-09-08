# Create Secrets Manager secret
resource "aws_secretsmanager_secret" "openai" {
  name        = "n8n-openai-api-key"
  description = "OpenAI API key for n8n workflows"
}

# Add the secret value
resource "aws_secretsmanager_secret_version" "openai_version" {
  secret_id     = aws_secretsmanager_secret.openai.id
  secret_string = jsonencode({
    OPENAI_API_KEY = var.openai_api_key
  })
}