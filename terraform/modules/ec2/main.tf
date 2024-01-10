# EC2

# Local
locals {
  http_ports = [
    {
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port = 8080
      to_port = 8080
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port = 443
      to_port = 443
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

# Security Group
# - Allow SSH via port 22

# Public Group
resource "aws_security_group" "public_allow_http" {
  name = "${var.environment}-allow-http-public"
  description = "Allow HTTP inbound traffic"
  vpc_id = var.vpc.id

  dynamic ingress {
    for_each = local.http_ports
    content {
      description = "HTTP from the internet"
      from_port = ingress.value["from_port"]
      to_port = ingress.value["to_port"]
      protocol = ingress.value["protocol"]
      cidr_blocks = ingress.value["cidr_blocks"]
    }
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.environment}-allow-http-public"
  }
}

resource "aws_security_group" "public_allow_ssh" {
  name = "${var.environment}-allow-ssh-public"
  description = "Allow SSH inbound traffic"
  vpc_id = var.vpc.id

  ingress {
    description = "SSH from the internet"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.environment}-allow-ssh-public"
  }
}


# EC2 Instance
resource "aws_instance" "ec2" {
  ami = var.ami_id
  instance_type = var.instance_type
  associate_public_ip_address = true
  key_name = var.key_name
  subnet_id = var.public_subnet[0].id
  vpc_security_group_ids = [aws_security_group.public_allow_ssh.id, aws_security_group.public_allow_http.id]

  tags = {
    Name = "${var.environment}-ec2-public"
  }

  # Copies the ssh key file to home dir
  provisioner "file" {
    source = "./${var.key_name}.pem"
    destination = "/home/ec2-user/${var.key_name}.pem"

    connection {
      type = "ssh"
      user = "ec2-user"
      private_key = file("${var.key_name}.pem")
      host = self.public_ip
    }
  }
  
  # chmod key 0400 on EC2 instance
  provisioner "remote-exec" {
    inline = [ "chmod 400 ~/${var.key_name}.pem" ]

    connection {
      type = "ssh"
      user = "ec2-user"
      private_key = file("${var.key_name}.pem")
      host = self.public_ip
    }
  }
}
