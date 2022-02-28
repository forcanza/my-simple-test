resource "tls_private_key" "this" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

module "key_pair" {
  source  = "terraform-aws-modules/key-pair/aws"
  version = "1.0.0"

  key_name   = "key-${var.env}"
  public_key = tls_private_key.this.public_key_openssh
}

resource "aws_kms_key" "rds" {
  description = "${var.env} KMS key RDS"
}