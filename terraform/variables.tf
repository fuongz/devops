variable "environment" {
  type = string
  default = "fuongz"
}

variable "aws_profile" {
  type = string
  default = "default"
}

variable "aws_region" {
  type = string
  default = "us-west-2"
}

variable "vpc_id" {
  description = "Existing VPC to use (specify this, if you don't want to create new VPC)"
  type = string
  default = ""
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overriden"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnets_cidr" {
  type        = list(any)
  default     = ["10.0.0.0/20", "10.0.128.0/20"]
  description = "CIDR block for Public Subnet"
}

variable "private_subnets_cidr" {
  type        = list(any)
  default     = ["10.0.16.0/20", "10.0.144.0/20"]
  description = "CIDR block for Private Subnet"
}

variable "modules" {
  type = object({
    ec2 = bool
    fargate = bool
  })
  default = {
    ec2 = true
    fargate = false
  }
  description = "List modules"
}

variable "services" {
  type = object({
    networking = object({
      nat = bool
    })
  })
  default = {
    networking = {
      nat: false
    }
  }
  description = "List services"
}
