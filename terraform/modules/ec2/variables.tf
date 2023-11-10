variable "environment" {
  type = string
  default = "fuongz"
}

variable "key_name" {
  type = any
}

variable "ami_id" {
  type = string
  default = "ami-00448a337adc93c05" # Amazon Linux 2023 AMI 2023.2.20231030.1 x86_64 HVM kernel-6.1
}

variable "instance_type" {
  type = string
  default = "t2.micro"
}

variable "vpc" {
  type = any
}

variable "public_subnet" {
  type = any
}
