output "alb_dns_name" {
  description = "DNS name of the ALB"
  value       = aws_lb.n8n.dns_name
}

output "alb_https_listener_arn" {
  description = "ARN of the HTTPS listener"
  value       = aws_lb_listener.https.arn
}

output "target_group_arn" {
  description = "ARN of the ALB target group"
  value       = aws_lb_target_group.n8n_tg.arn
}

