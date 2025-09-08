variable "alb_name" {
  description = "Name of the Application Load Balancer"
  type        = string
}
variable "alb_security_group_id" {
  description = "Security Group ID for the ALB"
  type        = string
  
}
variable "public_subnet_ids" {
  description = "List of public subnet IDs for the ALB"
  type        = list(string)  
  
}
variable "vpc_id" {
  description = "VPC ID where the ALB will be deployed"
  type        = string  
  
}
variable "target_group_arn" {
  description = "ARN of the Target Group to attach EC2 instances"
  type        = string
  
}
variable "instance_ids" {
  description = "List of EC2 instance IDs to register with the Target Group"
  type        = list( string )
  
}
variable "cm_certificate_arn" {
  description = "ARN of the ACM certificate for HTTPS listener"
  type        = string
  
}
