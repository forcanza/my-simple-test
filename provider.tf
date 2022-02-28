terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
  backend "local" {
    path = "terraform2.tfstate"
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "eu-central-1"
}
