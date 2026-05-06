terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.0"
}

provider "aws" {
  region = var.aws_region
}

module "ec2" {
  source = "./modules/ec2"

  project_name      = var.project_name
  ami_id            = var.ami_id
  instance_type     = var.instance_type
  key_name          = var.key_name
  private_subnet_id = module.vpc.private_subnet_id
  public_subnet_id  = module.vpc.public_subnet_id
  vpc_id            = module.vpc.vpc_id
}

module "vpc" {
  source = "./modules/vpc"

  project_name        = var.project_name
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidr  = var.public_subnet_cidr
  public_subnet_cidr2 = var.public_subnet_cidr2
  private_subnet_cidr = var.private_subnet_cidr
  az                  = var.az
  az2                 = var.az2
}

module "alb" {
  source = "./modules/alb"

  project_name      = var.project_name
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = [module.vpc.public_subnet_id, module.vpc.public_subnet_id2]
  ec2_instance_id   = module.ec2.web_instance_id
}


