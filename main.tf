data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  availability_zones = slice(data.aws_availability_zones.available.names, 0, 2)
}

module "vpc" {
  source             = "./modules/vpc"
  project_name       = var.project_name
  vpc_cidr           = var.vpc_cidr
  availability_zones = local.availability_zones
}

module "security_groups" {
  source       = "./modules/security_groups"
  project_name = var.project_name
  vpc_id       = module.vpc.vpc_id
}

module "alb" {
  source         = "./modules/alb"
  project_name   = var.project_name
  vpc_id         = module.vpc.vpc_id
  public_subnets = module.vpc.public_subnet_ids
  alb_sg_id      = module.security_groups.alb_sg_id
}

module "rds" {
  source       = "./modules/rds"
  project_name = var.project_name
  vpc_id       = module.vpc.vpc_id
  subnet_ids   = concat(module.vpc.public_subnet_ids, module.vpc.private_subnet_ids)
  rds_sg_id    = module.security_groups.rds_sg_id
  db_username  = var.db_username
  db_password  = var.db_password
}

module "ecs" {
  source          = "./modules/ecs"
  project_name    = var.project_name
  aws_region      = var.aws_region
  private_subnets = module.vpc.private_subnet_ids
  ecs_sg_id       = module.security_groups.ecs_sg_id
  tg_app1_arn     = module.alb.tg_app1_arn
  tg_ngnix_arn    = module.alb.tg_ngnix_arn
  db_endpoint     = module.rds.db_endpoint
  db_username     = var.db_username
  db_password     = var.db_password
}
