resource "aws_security_group" "sg_pihole" {
  name        = "${var.Prefix}-xlb-sg"
  description = "PiHole Security Group"
  vpc_id      = data.aws_subnet.selected.vpc_id

  tags = {
    Name = "${var.Prefix}-xlb-sg"
  }
}

resource "aws_security_group_rule" "xlb_allow_webinterface_inbound" {
  description       = "Webinterface"
  type              = "ingress"
  security_group_id = aws_security_group.sg_pihole.id
  cidr_blocks       = var.webinterface_allowed_cidr_blocks
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
}

resource "aws_security_group_rule" "xlb_allow_dnsreq_tcp_inbound" {
  description       = "DNS Request"
  type              = "ingress"
  security_group_id = aws_security_group.sg_pihole.id
  cidr_blocks       = var.dnsreq_allowed_cidr_blocks
  from_port         = 53
  to_port           = 53
  protocol          = "tcp"
}

resource "aws_security_group_rule" "xlb_allow_dnsreq_udp_inbound" {
  description       = "DNS Request"
  type              = "ingress"
  security_group_id = aws_security_group.sg_pihole.id
  cidr_blocks       = var.dnsreq_allowed_cidr_blocks
  from_port         = 53
  to_port           = 53
  protocol          = "udp"
}

resource "aws_security_group_rule" "xlb_allow_any_outbound" {
  description       = "Allow All"
  type              = "egress"
  security_group_id = aws_security_group.sg_pihole.id
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
}

