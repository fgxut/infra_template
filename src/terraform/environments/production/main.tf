terraform {
  required_version = "= 1.3.5"

  backend "s3" {
    bucket = "prd-example-tfstate-123456789123"
    key    = "prd-example.tfstate"
    region = "ap-northeast-1"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.43.0"
    }
  }
}

provider "aws" {
  profile = var.common["profile"]
  region  = var.common["region"]
}

module "network" {
  source  = "../../modules/network"
  common  = var.common
  network = var.network
}

module "rds" {
  source     = "../../modules/rds"
  common     = var.common
  rds        = var.rds
  aws_vpc    = module.network.aws_vpc
  aws_subnet = module.network.aws_subnet
}

module "bastion" {
  source     = "../../modules/bastion"
  common     = var.common
  aws_vpc    = module.network.aws_vpc
  aws_subnet = module.network.aws_subnet
}

module "wordpress" {
  source     = "../../modules/wordpress"
  common     = var.common
  wordpress  = var.wordpress
  rds        = var.rds
  aws_vpc    = module.network.aws_vpc
  aws_subnet = module.network.aws_subnet
}
