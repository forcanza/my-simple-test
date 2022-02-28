# Configure the AWS Provider
variable "env" {
  type = string
}

variable "base_cidr_block" {
  type = string
}

variable "region" {
  type = string
}

variable "ec2_type" {
  type = string
}

variable "ec2_ingress" {
  type = list(object({
    description = string
    port        = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = []
}

variable "az_count" {
  description = "Number of AZs to cover in a given AWS region"
  type        = number
  default     = "2"
}
