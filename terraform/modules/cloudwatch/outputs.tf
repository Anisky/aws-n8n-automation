output "cloudwatch_log_group" {
  value = aws_cloudwatch_log_group.n8n_docker.name
}