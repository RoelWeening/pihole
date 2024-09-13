resource "aws_lb" "nlb_pihole" {
  name               = "${var.Prefix}-nlb-pihole"
  internal           = false
  load_balancer_type = "network"
  security_groups    = [aws_security_group.sg_pihole.id]
  subnets            = var.public_subnet_ids

  enable_deletion_protection = true
  drop_invalid_header_fields = true

  preserve_host_header = true
  enable_http2         = true

  tags = {
    Name = "${var.Prefix}-nlb-pihole"
  }
}

resource "aws_lb_listener" "tcp_udp_53" {
  load_balancer_arn = aws_lb.nlb_pihole.arn
  port              = "53"
  protocol          = "TCP_UDP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tcp_udp_53.arn
  }

  tags = {
    Name = "${var.Prefix}-nlb-pihole-53"
  }
}

resource "aws_lb_target_group" "tcp_udp_53" {
  name   = "${var.Prefix}-tg-filebrowser-ext"
  vpc_id = data.aws_subnet.selected.vpc_id

  target_type = "ip"
  port        = 53

  protocol = "TCP_UDP"

}
