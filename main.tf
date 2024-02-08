provider "aws" {
  region = "us-east-1"
}

resource "aws_key_pair" "terraform-keys" {
 key_name = "terraform-keys"
 public_key = "${file("${path.root}/terraform-keys.pub")}"
}

resource "aws_vpc" "vpc_test" {
  cidr_block = var.vpc_cidr_block
  tags = {
      Name = "vpc_test"
  }
}