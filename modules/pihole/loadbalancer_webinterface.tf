resource "aws_lb" "alb_pihole" {
  name               = "${var.Prefix}-alb-pihole"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg_pihole.id]
  subnets            = var.public_subnet_ids

  enable_deletion_protection = true
  drop_invalid_header_fields = true

  preserve_host_header = true
  enable_http2         = true

  tags = {
    Name = "${var.Prefix}-alb-pihole"
  }
}

resource "aws_lb_listener" "https_pihole" {
  load_balancer_arn = aws_lb.alb_pihole.arn
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = aws_acm_certificate.cert.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.fargate_target_pihole.arn
  }

  tags = {
    Name = "${var.Prefix}-alb-pihole-https"
  }
}

resource "aws_lb_target_group" "fargate_target_pihole" {
  name   = "${var.Prefix}-tg-pihole_webinterface"
  vpc_id = data.aws_subnet.selected.vpc_id

  target_type = "ip"
  port        = 80

  protocol         = "HTTP"
  protocol_version = "HTTP1"

  load_balancing_algorithm_type = "round_robin"

  stickiness {
    enabled         = true
    type            = "lb_cookie"
    cookie_duration = 3600 #1 hour
  }

  health_check {
    enabled             = true
    healthy_threshold   = 3
    interval            = 30
    matcher             = "200-499"
    path                = "/"
    protocol            = "HTTP"
    timeout             = 25
    unhealthy_threshold = 3
  }
}