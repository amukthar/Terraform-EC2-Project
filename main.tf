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

resource "aws_internet_gateway" "gw_test" {
  vpc_id = aws_vpc.vpc_test.id
  tags = {
      Name = "gw_test"
  }
}

resource "aws_route_table" "public_route_table_test" {
  vpc_id = aws_vpc.vpc_test.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw_test.id
  }
  tags = {
      Name = "public_route_table_test"
  }
}

resource "aws_route_table_association" "public_subnet_associations" {
  count          = length(aws_subnet.public_subnet_test)
  subnet_id      = aws_subnet.public_subnet_test[count.index].id
  route_table_id = aws_route_table.public_route_table_test.id
}

resource "aws_security_group" "nginx_sg_test" {
  vpc_id = aws_vpc.vpc_test.id

   ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  tags = {
    Name = "nginx_sg_test"
  }
}

resource "aws_instance" "nginx_instance_test" {
  ami                    = "ami-0e731c8a588258d0d"
  instance_type          = "t2.micro" 
  subnet_id              = element(aws_subnet.public_subnet_test[*].id, 0)
  vpc_security_group_ids = [aws_security_group.nginx_sg_test.id]
  key_name               = "terraform-keys"
  user_data = <<-EOF
              #!/bin/bash
              yum install -y nginx
              service nginx start
              chkconfig nginx on
              EOF

  tags = {
    Name = "nginx_instance_test"
}
  }

resource "aws_instance" "public_instance1_test" {
  ami                    = "ami-0e731c8a588258d0d"
  instance_type          = "t2.micro" 
  subnet_id              = element(aws_subnet.public_subnet_test[*].id, 0)
  vpc_security_group_ids = [aws_security_group.nginx_sg_test.id]
  key_name               = "terraform-keys"
  tags = {
    Name = "public_instance1_test"
}
  }
resource "aws_instance" "public_instance2_test" {
  ami                    = "ami-0e731c8a588258d0d"
  instance_type          = "t2.micro" 
  subnet_id              = element(aws_subnet.public_subnet_test[*].id, 0)
  vpc_security_group_ids = [aws_security_group.nginx_sg_test.id]
  key_name               = "terraform-keys"
  tags = {
    Name = "public_instance2_test"
}
  }

resource "aws_instance" "private_instance1_test" {
  ami                    = "ami-0e731c8a588258d0d"
  instance_type          = "t2.micro" 
  subnet_id              = element(aws_subnet.private_subnet_test[*].id, 0)
  vpc_security_group_ids = [aws_security_group.nginx_sg_test.id]
  key_name               = "terraform-keys"
  tags = {
    Name = "private_instance1_test"
}
  }

resource "aws_instance" "private_instance2_test" {
  ami                    = "ami-0e731c8a588258d0d"
  instance_type          = "t2.micro" 
  subnet_id              = element(aws_subnet.private_subnet_test[*].id, 0)
  vpc_security_group_ids = [aws_security_group.nginx_sg_test.id]
  key_name               = "terraform-keys"
  tags = {
    Name = "private_instance1_test"
}
  }

resource "aws_instance" "private_instance3_test" {
  ami                    = "ami-0e731c8a588258d0d"
  instance_type          = "t2.micro" 
  subnet_id              = element(aws_subnet.private_subnet_test[*].id, 0)
  vpc_security_group_ids = [aws_security_group.nginx_sg_test.id]
  key_name               = "terraform-keys"
  tags = {
    Name = "private_instance1_test"
}
  }

output "public_ip" {
  value       = aws_instance.nginx_instance_test.public_ip
  description = "The public IP of the Instance"
}