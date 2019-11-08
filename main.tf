# Own personal acct details for sandbox testing

provider "aws" {
    region     = "eu-west-1"
}












resource "aws_route53_zone" "mikmclean" {
  name = "mikmclean.co.uk"
}

resource "aws_route53_record" "mikmclean" {
  zone_id = "${aws_route53_zone.mikmclean.zone_id}"
  name    = "www.mikmclean.co.uk"
  type    = "CNAME"
  ttl     = "60"
  records = ["${aws_lb.Webserver_ALB.dns_name}"]
}