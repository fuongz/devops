output "public_connection_string" {
  description = "Copy/Paste/Enter - You are in the matrix"
  value = "ssh -i ${module.ssh_key.key_name}.pem ec2-user@${module.ec2.public_ip}"
}
