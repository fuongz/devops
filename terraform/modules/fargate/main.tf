locals {
  container_name = var.container_name
  container_port = var.container_port
}

terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}




# * Build our Image locally with the appropriate name so that we can push 
# * our Image to our Repository in AWS. Also, give it a random image tag.
resource "docker_image" "this" {
 name = format("%v:%v", var.repository_url, formatdate("YYYY-MM-DD'T'hh-mm-ss", timestamp()))

 build { context = "./examples/fargate/" } # Path to our local Dockerfile
}

# * Push our container image to our ECR.
resource "docker_registry_image" "this" {
 keep_remotely = true # Do not delete old images when a new image is pushed
 name = resource.docker_image.this.name
}
