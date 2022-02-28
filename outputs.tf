resource "local_file" "ssh_key" {
  filename = "${module.key_pair.key_pair_key_name}.pem"
  content  = tls_private_key.this.private_key_pem
}


output "ec2_ip" {
  description = "Public IP for the NAT instance"
  value       = aws_eip.ec2_eip.public_ip
}