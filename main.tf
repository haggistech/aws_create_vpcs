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
    Name = "TerraForm_VPC01_Private_Subnet_1a"
  }
}

resource "aws_subnet" "TerraForm_VPC01_Private_Subnet_1b" {
  vpc_id     = "${aws_vpc.TerraForm_VPC01.id}"
  cidr_block = "10.0.2.0/24"
  availability_zone = "eu-west-1b"

  tags = {
    Name = "TerraForm_VPC01_Private_Subnet_1b"
  }
}

resource "aws_subnet" "TerraForm_VPC01_Private_Subnet_1c" {
  vpc_id     = "${aws_vpc.TerraForm_VPC01.id}"
  cidr_block = "10.0.3.0/24"
  availability_zone = "eu-west-1c"

  tags = {
    Name = "TerraForm_VPC01_Private_Subnet_1c"
  }
}

resource "aws_subnet" "TerraForm_VPC01_Public_Subnet_1a" {
  vpc_id     = "${aws_vpc.TerraForm_VPC01.id}"
  cidr_block = "10.0.4.0/24"
  availability_zone = "eu-west-1a"

  tags = {
    Name = "TerraForm_VPC01_Public_Subnet_1a"
  }
}

resource "aws_subnet" "TerraForm_VPC01_Public_Subnet_1b" {
  vpc_id     = "${aws_vpc.TerraForm_VPC01.id}"
  cidr_block = "10.0.5.0/24"
  availability_zone = "eu-west-1b"

  tags = {
    Name = "TerraForm_VPC01_Public_Subnet_1b"
  }
}

resource "aws_subnet" "TerraForm_VPC01_Public_Subnet_1c" {
  vpc_id     = "${aws_vpc.TerraForm_VPC01.id}"
  cidr_block = "10.0.6.0/24"
  availability_zone = "eu-west-1c"

  tags = {
    Name = "TerraForm_VPC01_Public_Subnet_1c"
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


resource "aws_lb_target_group" "Webserver_TG" {
  name     = "Webserver-TG"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${aws_vpc.TerraForm_VPC01.id}"
}

resource "aws_lb_target_group_attachment" "Webserver1_TG_attach" {
  target_group_arn = "${aws_lb_target_group.Webserver_TG.arn}"
  target_id        = "${aws_instance.Webserver_1.id}"
  port             = 80
}

resource "aws_lb_target_group_attachment" "Webserver2_TG_attach" {
  target_group_arn = "${aws_lb_target_group.Webserver_TG.arn}"
  target_id        = "${aws_instance.Webserver_2.id}"
  port             = 80
}

resource "aws_lb" "Webserver_NLB" {
  name               = "Webserver-NLB-01"
  internal           = true
  load_balancer_type = "application"
  subnets            = ["${aws_subnet.TerraForm_VPC01_Public_Subnet_1a.id}", "${aws_subnet.TerraForm_VPC01_Public_Subnet_1b.id}", "${aws_subnet.TerraForm_VPC01_Public_Subnet_1c.id}"]

  enable_deletion_protection = false

  tags = {
    Environment = "Terraform"
  }
}


resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = "${aws_lb.Webserver_NLB.arn}"
  port              = "80"
  protocol          = "TCP"
  #ssl_policy        = "ELBSecurityPolicy-2016-08"
  #certificate_arn   = "arn:aws:iam::187416307283:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.Webserver_TG.arn}"
  }
}



resource "aws_instance" "Webserver_1" {
  ami           = "ami-bb9a6bc2"
  instance_type = "t2.micro"
  key_name = "mikDev"
  subnet_id   = "${aws_subnet.TerraForm_VPC01_Private_Subnet_1a.id}"
  vpc_security_group_ids = [ "${aws_security_group.mik_terra.id}" ]
  ebs_block_device {
    device_name = "/dev/sdb"
    volume_size = 5
    volume_type = "gp2"
    delete_on_termination = true
  }
}

resource "aws_instance" "Webserver_2" {
  ami           = "ami-bb9a6bc2"
  instance_type = "t2.micro"
  key_name = "mikDev"
  subnet_id   = "${aws_subnet.TerraForm_VPC01_Private_Subnet_1b.id}"
  vpc_security_group_ids = [ "${aws_security_group.mik_terra.id}" ]
  ebs_block_device {
    device_name = "/dev/sdb"
    volume_size = 5
    volume_type = "gp2"
    delete_on_termination = true
  }
}