output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}

output "security_group_id" {
  value = module.security_group.security_group_id
}

output "instance_ids" {
  value = module.ec2.instance_ids
}

output "instance_public_ip" {
  value = module.ec2.public_ip
}


