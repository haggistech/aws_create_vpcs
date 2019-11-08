resource "aws_lb_target_group" "Webserver_TG" {
  name     = "Webserver-TG"
  port     = 80
  protocol = "HTTP"
  health_check {
    interval = 5
    timeout = 2
    healthy_threshold = 2
    unhealthy_threshold = 2
  }
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

resource "aws_lb" "Webserver_ALB" {
  name               = "Webserver-ALB-01"
  internal           = false
  load_balancer_type = "application"
  subnets            = ["${aws_subnet.TerraForm_VPC01_Public_Subnet_1a.id}", "${aws_subnet.TerraForm_VPC01_Public_Subnet_1b.id}", "${aws_subnet.TerraForm_VPC01_Public_Subnet_1c.id}"]
  security_groups    = ["${aws_security_group.Webserver_LB_SG.id}"]
  enable_deletion_protection = false

  tags = {
    Environment = "Terraform"
  }
}


resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = "${aws_lb.Webserver_ALB.arn}"
  port              = "80"
  protocol          = "HTTP"
  #ssl_policy        = "ELBSecurityPolicy-2016-08"
  #certificate_arn   = "arn:aws:iam::187416307283:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.Webserver_TG.arn}"
  }
}