resource "aws_security_group" "sg_pihole_efs" {
  name        = "${var.Prefix}-efs-sg"
  description = "PiHole Security Group - EFS"
  vpc_id      = data.aws_subnet.selected.vpc_id

  tags = {
    Name = "${var.Prefix}-efs-sg"
  }
}
resource "aws_security_group_rule" "fargate_efs" {
  description              = "Fargate EFS"
  type                     = "ingress"
  security_group_id        = aws_security_group.sg_pihole_efs.id
  source_security_group_id = aws_security_group.sg_pihole_ecs.id
  from_port                = 2980
  to_port                  = 2999
  protocol                 = "tcp"
}

resource "aws_security_group_rule" "fargate_efs_2049" {
  description              = "Fargate EFS"
  type                     = "ingress"
  security_group_id        = aws_security_group.sg_pihole_efs.id
  source_security_group_id = aws_security_group.sg_pihole_ecs.id
  from_port                = 2049
  to_port                  = 2049
  protocol                 = "tcp"
}

resource "aws_security_group_rule" "efs_egress" {
  description       = "Allow All"
  type              = "egress"
  security_group_id = aws_security_group.sg_pihole_efs.id
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
}