output "instance_ids" {
  description = "List of EC2 instance IDs for n8n"
  value       = [for i in aws_instance.n8n : i.id]
}

output "public_ip" {
  value =   [for i in aws_instance.n8n : i.public_ip]
  
}
