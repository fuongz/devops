terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

module "networking" {
  source = "./modules/networking"

  services = var.services["networking"]
}

module "ssh_key" {
  source = "./modules/ssh_key"
}

module "ec2" {
  source = "./modules/ec2"
  count = var.modules["ec2"] == true ? 1 : 0

  public_subnet = module.networking.public_subnet
  vpc = module.networking.vpc
  key_name = module.ssh_key.key_name
}
