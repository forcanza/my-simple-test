data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

resource "aws_security_group" "sg" {
  name        = "main-${var.env}"
  description = "Allow NAT traffic"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "All traffic from VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [aws_vpc.vpc.cidr_block]
  }
  dynamic "ingress" {
    for_each = var.ec2_ingress
    content {
      description = ingress.value.description
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ec2_instance"
  }
}

resource "aws_instance" "ec2" {
  ami                         = data.aws_ami.amazon_linux_2.id
  instance_type               = var.ec2_type
  associate_public_ip_address = true
  source_dest_check           = false
  key_name                    = module.key_pair.key_pair_key_name
  subnet_id                   = aws_subnet.public_subnets.0.id
  vpc_security_group_ids      = ["${aws_security_group.sg.id}"]
  user_data                   = file("scripts/ec2_startup.sh")

  tags = {
    Name = "ec2-${var.env}"
  }
  lifecycle {
    ignore_changes = [
      ami,
    ]
  }
}

resource "aws_eip" "ec2_eip" {
  instance = aws_instance.ec2.id
  vpc      = true
  tags = {
    Name = "eip-${var.env}-ec2"
  }
}

resource "aws_route" "route_ec2" {
  route_table_id         = aws_vpc.vpc.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  instance_id            = aws_instance.ec2.id
}
