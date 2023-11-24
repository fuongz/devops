output "ec2_public_connection_string" {
  description = "Copy/Paste/Enter - You are in the matrix"
  value = module.ssh_key != null && length(module.ec2) > 0 && module.ec2 != null ? "ssh -i ${module.ssh_key.key_name}.pem ec2-user@${module.ec2[0].public_ip}" : ""
}
