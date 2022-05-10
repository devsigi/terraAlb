module mod_vars{
    source = "../dirvars"
}

variable vpcid{}
variable sgid{}
variable subnetid{}


data "aws_instances" "websers" {
  instance_tags = {
   Name = "${module.mod_vars.env}*"
  }
  instance_state_names = ["running", "stopped"]
}

resource "aws_lb_target_group" "reslbtg" {

  count = length(data.aws_instances.websers.ids)
  health_check{
	interval = 10
	path = "/"
	protocol = "HTTP"
	timeout = 5
	healthy_threshold = 5
	unhealthy_threshold = 2
  }
  
  name     = "${module.mod_vars.env}lbtg${count.index}"
  port     = 80
  protocol = "HTTP"
  target_type = "instance"
  vpc_id   = var.vpcid
}

resource "aws_lb" "aws_alb" {
  name               = "${module.mod_vars.env}alb"
  internal           = false
  ip_address_type = "ipv4"
  load_balancer_type = "application"
  security_groups    = [var.sgid,]
  subnets            = [var.subnetid,]

  #enable_deletion_protection = true

  /* access_logs {
    bucket  = aws_s3_bucket.lb_logs.bucket
    prefix  = "test-lb"
    enabled = true
  } */

  tags = {
    Environment = "${module.mod_vars.env}_alb"
  }
}

resource "aws_lb_listener" "reslblis" {
  count            = length(data.aws_instances.websers.ids)
  load_balancer_arn = aws_lb.aws_alb.arn
  port              = 80
  protocol          = "HTTP"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  #certificate_arn   = "arn:aws:iam::187416307283:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.reslbtg[count.index].arn
  }
}

resource "aws_alb_target_group_attachment" "restglink" {
  count            = length(data.aws_instances.websers.ids)
  target_group_arn = aws_lb_target_group.reslbtg[count.index].arn
  target_id        = "${element(data.aws_instances.websers, count.index)}"
  port             = 80
}

/* 
output outtg_arn{
    value = aws_lb_target_group.reslbtg.arn
} */
