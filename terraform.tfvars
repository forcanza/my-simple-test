env             = "main"
base_cidr_block = "172.16.0.0/16"
region          = "eu-central-1"
ec2_type        = "t3a.2xlarge"

ec2_ingress = [
  {
    description = "all"
    port        = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  },
]
