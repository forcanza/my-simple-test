resource "local_file" "ssh_key" {
  filename = "${module.key_pair.key_pair_key_name}.pem"
  content  = tls_private_key.this.private_key_pem
  file_permission = "0400"
}


output "ec2_ip" {
  description = "Public IP for the NAT instance"
  value       = aws_eip.ec2_eip.public_ip
}