output "vpc" {
  value = aws_vpc.vpc
}

output "public_subnet" {
  value = aws_subnet.public_subnet
}
