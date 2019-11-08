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

resource "aws_security_group" "JumpBox_SG" {
  name        = "JumpBox_SG"
  description = "Allow Port 22 from Mik"
  vpc_id      = "${aws_vpc.TerraForm_VPC01.id}"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["86.129.225.16/32"]
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "Webserver_SG" {
  name        = "Webserver_SG"
  description = "Allow Port 80 from Webserver_LB"
  vpc_id      = "${aws_vpc.TerraForm_VPC01.id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    security_groups = ["${aws_security_group.Webserver_LB_SG.id}"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    security_groups = ["${aws_security_group.JumpBox_SG.id}"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["86.129.225.16/32"]
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "Webserver_LB_SG" {
  name        = "Webserver_LB_SG"
  description = "Allow Port 80 from Public"
  vpc_id      = "${aws_vpc.TerraForm_VPC01.id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}