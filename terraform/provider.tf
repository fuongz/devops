provider "aws" {
  region = var.aws_region
  profile = var.aws_profile
  max_retries = 1
}


# Provider: Docker
# * Give Docker permission to pusher Docker images to AWS
data "aws_caller_identity" "this" {}
data "aws_ecr_authorization_token" "this" {}
data "aws_region" "this" {}

locals {
  ecr_address = format("%v.dkr.ecr.%v.amazonaws.com", data.aws_caller_identity.this.account_id, data.aws_region.this.name)
}

provider "docker" {
  alias = "docker_kreuzwerker"
  registry_auth {
    address  = local.ecr_address
    password = data.aws_ecr_authorization_token.this.password
    username = data.aws_ecr_authorization_token.this.user_name
  }
}
