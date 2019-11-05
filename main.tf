# Own personal acct details for sandbox testing

provider "aws" {
    region     = "eu-west-1"
}

resource "aws_vpc" "TerraForm_VPC01" {
  cidr_block       = "10.0.0.0/16"
  tags = {
    Name = "TerraForm_VPC01"
  }
}

resource "aws_subnet" "TerraForm_VPC01_Private_Subnet_1a" {
  vpc_id     = "${aws_vpc.TerraForm_VPC01.id}"
  cidr_block = "10.0.1.0/24"
  availability_zone = "eu-west-1a"

  tags = {
    Name = "Main"
  }
}

resource "aws_security_group" "mik_terra" {
  name        = "mik_terra"
  description = "Allow SSH in from devlan"
  vpc_id      = "${aws_vpc.TerraForm_VPC01.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["195.27.20.114/32"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["87.155.238.50/32"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    self        = true
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["86.155.238.50/32"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "TCP"
    cidr_blocks = ["86.155.238.50/32"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    cidr_blocks = ["86.155.238.50/32"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "terraform1" {
  ami           = "ami-bb9a6bc2"
  instance_type = "t2.micro"
  key_name = "mikDev"
  subnet_id   = "${aws_subnet.TerraForm_VPC01_Private_Subnet_1a.id}"
  security_groups = [ "mik_terra" ]
  ebs_block_device {
    device_name = "/dev/sdb"
    volume_size = 5
    volume_type = "gp2"
    delete_on_termination = true
  }
}

