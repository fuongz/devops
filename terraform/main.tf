terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

module "networking" {
  source = "./modules/networking"
}

module "ssh_key" {
  source = "./modules/ssh_key"
}

module "ec2" {
  source = "./modules/ec2"

  public_subnet = module.networking.public_subnet
  vpc = module.networking.vpc
  key_name = module.ssh_key.key_name
}
