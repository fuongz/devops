terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    docker = {
      source = "kreuzwerker/docker"
      version = "~> 3.0"
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

# Fargate
module "erc" {
  source  = "terraform-aws-modules/ecr/aws"
  count = var.modules["fargate"] == true ? 1 : 0
  version = "~> 1.6.0"
  repository_force_delete = true
  repository_name = "${var.environment}_repository"
  repository_lifecycle_policy = jsonencode({
    rules = [{
    action = { type = "expire" }
    description = "Delete all images except a handful of the newest images"
    rulePriority = 1
    selection = {
      countNumber = 3
      countType = "imageCountMoreThan"
      tagStatus = "any"
    }
    }]
  })
}
module "fargate" {
  source = "./modules/fargate"
  count = var.modules["fargate"] == true ? 1 : 0

  providers = {
    docker = docker.docker_kreuzwerker
  }

  repository_url = module.erc[0].repository_url
}

