variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
}

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "List of CIDRs for public subnets"
  type        = list(string)
}

variable "availability_zones" {
  description = "List of availability zones for public subnets"
  type        = list(string)
}

variable "sg_name" {
  description = "Name of the security group"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}
variable "role_name" {
  description = "Name of the IAM role and instance profile"
  type        = string
}

variable "instance_name" {
  description = "Tag name for the EC2 instance"
  type        = string
}
variable "alb_name" {
  description = "Name of the Application Load Balancer"
  type        = string
  
}
variable "domain_name" {
  description = "Domain name for the ACM certificate"
  type        = string
  
}
variable "openai_api_key" {
  description = "OpenAI API key for n8n"
  type        = string
  sensitive   = true
}
