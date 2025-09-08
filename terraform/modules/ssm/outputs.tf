output "openai_secret_arn" {
  value       = aws_secretsmanager_secret.openai.arn
  description = "ARN of the OpenAI secret in Secrets Manager"
}