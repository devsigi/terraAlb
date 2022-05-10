module "modvars"{
    source = "../dirvars"
}

variable vpcid{}
variable sgid{}
#variable subnetid{}

resource "aws_security_group" "ressgalb" {
  name        = "${module.modvars.env}_albsg"
  description = "sg for alb servers"
  vpc_id      = var.vpcid

  ingress {
    description      = "HTTP for server access"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
#    security_groups = ["${var.loadbalancer.id}",]
#    security_groups	 = ["${var.sgid}",]
    cidr_blocks      = ["76.186.132.59/32"]
  }
    
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
#    ipv6_cidr_blocks = ["::/0"]
  }
}

output outsgalbid{
    value= "${aws_security_group.ressgalb.id}"
}
