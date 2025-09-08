

module "vpc" {
  source               = "./modules/vpc"
  vpc_name             = var.vpc_name
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  availability_zones   = var.availability_zones
}

module "security_group" {
  source        = "./modules/security_group"
  sg_name       = var.sg_name
  vpc_id        = module.vpc.vpc_id

}

module "ssm" {
  source          = "./modules/ssm"
  openai_api_key  = var.openai_api_key
  
}


module "iam" {
  source     = "./modules/iam"
  role_name  = var.role_name
  openai_secret_arn = module.ssm.openai_secret_arn
  
}

module "ec2" {
  source               = "./modules/ec2"
  ami_id               = var.ami_id
  instance_type        = var.instance_type
  subnet_ids            = module.vpc.public_subnet_ids[0]
  security_group_id    = module.security_group.security_group_id
  iam_instance_profile = module.iam.instance_profile_name
  instance_name        = var.instance_name
}

module "acm" {
  source      = "./modules/acm"
  domain_name = var.domain_name
  
}

module "alb" {
  source       = "./modules/alb"
  alb_name     = var.alb_name
  vpc_id       = module.vpc.vpc_id
  instance_ids  = module.ec2.instance_ids
  alb_security_group_id = module.security_group.alb_security_group_id
  target_group_arn = module.alb.target_group_arn
  public_subnet_ids = module.vpc.public_subnet_ids
  cm_certificate_arn = module.acm.acm_certificate_arn

}