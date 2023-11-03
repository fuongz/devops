provider "aws" {
  region = var.aws_region
  profile = var.aws_profile
  max_retries = 1
}
