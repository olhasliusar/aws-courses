terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "lohika-course"
  region  = "us-west-2"
}

module "vpc" {
  source = "./modules/vpc"

  vpc_cidr_block  = var.vpc_cidr_block
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
}

module "db" {
  source = "./modules/db"

  vpc_id           = module.vpc.vpc_id
  postgres_subnets = module.vpc.private_subnets

  postgres_db_name  = var.postgres_db_name
  postgres_user     = var.postgres_user
  postgres_password = var.postgres_password
}

module "messaging" {
  source = "./modules/messaging"

  sns_name       = var.sns_name
  sqs_name       = var.sqs_name
  sns_subs_email = var.sns_subs_email
}

module "instance" {
  source = "./modules/instance"

  instance_ami     = var.instance_ami
  instance_type    = var.instance_type
  nat_instance_ami = var.nat_instance_ami
  key_pair         = var.key_pair

  vpc_id          = module.vpc.vpc_id
  public_subnets  = module.vpc.public_subnets
  private_subnets = module.vpc.private_subnets
  rds_endpoint    = module.db.rds_endpoint
}