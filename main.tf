terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.45"
    }
  }

  required_version = ">= 1.0.0"
    backend "remote" {
    hostname      = "app.terraform.io"
    organization  = "mobilemedics"

    workspaces {
      name = "terraform-valheim-aws"
    }
  }
}

provider "aws" {
  profile = "default"
  region = "us-east-1"
  default_tags {
    tags = {
      Application = "Valheim"
    }
  }
}

module "iam" {
  source = "./modules/iam"
  hosted_zone_id = var.hosted_zone_id
  instance_id = module.server.valheim_instance.spot_instance_id
}

module "network" {
  source = "./modules/network"
  availability_zone = var.availability_zone
}

module "security_groups" {
  source  = "./modules/security-groups"
  your_ip = var.your_ip
  vpc_id  = module.network.valheim_vpc
}

module "storage" {
  source = "./modules/storage"
  availability_zone = var.availability_zone
  volume_size = var.volume_size
  volume_type = var.volume_type
  dlm_iam = module.iam.valheim_dlm_iam
}

module "server" {
  source = "./modules/spot-instance"
  instance_type = var.instance_type
  security_groups = [module.security_groups.security_group_id]
  subnet_id = module.network.valheim_subnet
  volume_id = module.storage.valheim_volume
  user_data = templatefile("./scripts/bootstrap.tpl", { valheim_pass = var.valheim_pass })
  key_name = var.key_name
  spot_price = var.spot_price
}

module "lambdas" {
  source = "./modules/lambdas"
  hosted_zone_id = var.hosted_zone_id
  record_name = var.record_name
  instance_id = module.server.valheim_instance.spot_instance_id
  eventbridge_autostop_arn = module.eventbridges.eventbridge_autostop_arn
  eventbridge_dns_arn = module.eventbridges.eventbridge_dns_arn
}

module "eventbridges" {
  source = "./modules/eventbridges"
  lambda_dns_arn = module.lambdas.lambda_dns_arn
  lambda_autostop_arn = module.lambdas.lambda_autostop_arn
  instance_id = module.server.valheim_instance.spot_instance_id
}