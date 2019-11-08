resource "aws_instance" "Webserver_1" {
  ami           = "${var.ec2_ami}"
  instance_type = "t2.micro"
  key_name = "${var.ec2_key}"
  subnet_id   = "${aws_subnet.TerraForm_VPC01_Private_Subnet_1a.id}"
  vpc_security_group_ids = [ "${aws_security_group.Webserver_SG.id}" ]
  user_data = "${file("webserver_userdata.txt")}"
  depends_on = ["aws_nat_gateway.gw"]
  ebs_block_device {
    device_name = "/dev/sdb"
    volume_size = 5
    volume_type = "gp2"
    delete_on_termination = true
  }
  tags = {
    Name = "Webserver_1"
  }
}

resource "aws_instance" "Webserver_2" {
  ami           = "${var.ec2_ami}"
  instance_type = "t2.micro"
  key_name = "${var.ec2_key}"
  subnet_id   = "${aws_subnet.TerraForm_VPC01_Private_Subnet_1b.id}"
  vpc_security_group_ids = [ "${aws_security_group.Webserver_SG.id}" ]
  user_data = "${file("webserver_userdata.txt")}"
  depends_on = ["aws_nat_gateway.gw"]
  ebs_block_device {
    device_name = "/dev/sdb"
    volume_size = 5
    volume_type = "gp2"
    delete_on_termination = true
  }
  tags = {
    Name = "Webserver_2"
  }
}

resource "aws_instance" "JumpBox" {
  depends_on = ["aws_internet_gateway.gw"]
  ami           = "${var.ec2_ami}"
  instance_type = "t2.micro"
  key_name = "${var.ec2_key}"
  associate_public_ip_address = true
  subnet_id   = "${aws_subnet.TerraForm_VPC01_Public_Subnet_1b.id}"
  vpc_security_group_ids = [ "${aws_security_group.JumpBox_SG.id}" ]
  ebs_block_device {
    device_name = "/dev/sdb"
    volume_size = 5
    volume_type = "gp2"
    delete_on_termination = true
  }
  tags = {
    Name = "JumpBox"
  }
}