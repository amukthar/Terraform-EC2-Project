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

resource "aws_subnet" "public_subnet_test" {
  count                  = length(var.public_subnet_cidr_blocks)
  vpc_id                 = "${aws_vpc.vpc_test.id}"
  cidr_block             = var.public_subnet_cidr_blocks[count.index]
  availability_zone      = element(var.aws_availability_zones, count.index)
  map_public_ip_on_launch = true
  tags = {
      Name = "public_subnet_test"
  }
}

resource "aws_subnet" "private_subnet_test" {
  count                  = length(var.private_subnet_cidr_blocks)
  vpc_id                 = aws_vpc.vpc_test.id
  cidr_block             = var.private_subnet_cidr_blocks[count.index]
  availability_zone      = element(var.aws_availability_zones, count.index)
  tags = {
      Name = "private_subnet_test"
  }
}
