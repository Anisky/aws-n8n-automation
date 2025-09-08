variable "role_name" {
  description = "Name of the IAM role and instance profile"
  type        = string
}
variable "openai_secret_arn" {
  description = "ARN of the OpenAI secret in Secrets Manager"
  type        = string
}