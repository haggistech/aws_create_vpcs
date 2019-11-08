resource "aws_vpc" "TerraForm_VPC01" {
  cidr_block       = "10.0.0.0/16"
  tags = {
    Name = "TerraForm_VPC01"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.TerraForm_VPC01.id}"

  tags = {
    Name = "Internet Gateway"
  }
}


resource "aws_eip" "nat" {
  vpc      = true
}



resource "aws_nat_gateway" "gw" {
  allocation_id = "${aws_eip.nat.id}"
  subnet_id     = "${aws_subnet.TerraForm_VPC01_Public_Subnet_1a.id}"
  depends_on = ["aws_internet_gateway.gw"]
  tags = {
    Name = "gw NAT"
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


resource "aws_route_table" "public_rt" {
  vpc_id = "${aws_vpc.TerraForm_VPC01.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }
  tags = {
    Name = "Public Route Table"
  }
}

resource "aws_route_table_association" "pub_subs_a" {
  subnet_id      = "${aws_subnet.TerraForm_VPC01_Public_Subnet_1a.id}"
  route_table_id = "${aws_route_table.public_rt.id}"
}
resource "aws_route_table_association" "pub_subs_b" {
  subnet_id      = "${aws_subnet.TerraForm_VPC01_Public_Subnet_1b.id}"
  route_table_id = "${aws_route_table.public_rt.id}"
}
resource "aws_route_table_association" "pub_subs_c" {
  subnet_id      = "${aws_subnet.TerraForm_VPC01_Public_Subnet_1c.id}"
  route_table_id = "${aws_route_table.public_rt.id}"
}


resource "aws_route_table" "private_rt" {
  vpc_id = "${aws_vpc.TerraForm_VPC01.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_nat_gateway.gw.id}"
  }
  tags = {
    Name = "Private Route Table"
  }
}

resource "aws_route_table_association" "priv_subs_a" {
  subnet_id      = "${aws_subnet.TerraForm_VPC01_Private_Subnet_1a.id}"
  route_table_id = "${aws_route_table.private_rt.id}"
}
resource "aws_route_table_association" "priv_subs_b" {
  subnet_id      = "${aws_subnet.TerraForm_VPC01_Private_Subnet_1b.id}"
  route_table_id = "${aws_route_table.private_rt.id}"
}
resource "aws_route_table_association" "priv_subs_c" {
  subnet_id      = "${aws_subnet.TerraForm_VPC01_Private_Subnet_1c.id}"
  route_table_id = "${aws_route_table.private_rt.id}"
}