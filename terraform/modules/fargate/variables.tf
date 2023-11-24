variable "environment" {
  type = string
  default = "fuongz"
}

variable "container_name" {
  type = string
  default = "fuongz-fargate-sample"
}

variable "container_port" {
  type = number
  default = 8080
}

variable "repository_url" {
  type = string
}
