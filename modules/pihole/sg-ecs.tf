resource "aws_security_group" "sg_pihole_ecs" {
  name        = "${var.Prefix}-ecs-sg"
  description = "PiHole Security Group - ECS"
  vpc_id      = data.aws_subnet.selected.vpc_id

  tags = {
    Name = "${var.Prefix}-ecs-sg"
  }
}

resource "aws_security_group_rule" "ecs_allow_webinterface_inbound" {
  description              = "Webinterface"
  type                     = "ingress"
  security_group_id        = aws_security_group.sg_pihole_ecs.id
  source_security_group_id = aws_security_group.sg_pihole.id
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
}

resource "aws_security_group_rule" "ecs_allow_dnsreq_tcp_inbound" {
  description              = "DNS Request"
  type                     = "ingress"
  security_group_id        = aws_security_group.sg_pihole.id
  source_security_group_id = aws_security_group.sg_pihole.id
  from_port                = 53
  to_port                  = 53
  protocol                 = "tcp"
}

resource "aws_security_group_rule" "ecs_allow_dnsreq_udp_inbound" {
  description              = "DNS Request"
  type                     = "ingress"
  security_group_id        = aws_security_group.sg_pihole.id
  source_security_group_id = aws_security_group.sg_pihole.id
  from_port                = 53
  to_port                  = 53
  protocol                 = "udp"
}

resource "aws_security_group_rule" "ecs_allow_any_outbound" {
  description       = "Allow All"
  type              = "egress"
  security_group_id = aws_security_group.sg_pihole.id
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
}

