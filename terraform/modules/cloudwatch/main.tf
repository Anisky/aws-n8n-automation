resource "aws_cloudwatch_log_group" "n8n_docker" {
  name              = "/n8n/docker"
  retention_in_days = 14
}
