resource "aws_ecs_service" "service" {
  name                   = "${var.Prefix}-pihole"
  cluster                = aws_ecs_cluster.cluster.id
  task_definition        = aws_ecs_task_definition.pihole.arn
  desired_count          = 1
  enable_execute_command = true

  launch_type          = "FARGATE"
  force_new_deployment = true

  load_balancer {
    target_group_arn = aws_lb_target_group.fargate_target_pihole.arn
    container_name   = "pihole"
    container_port   = 80
  }

  network_configuration {
    subnets          = var.private_subnet_ids
    assign_public_ip = false
    security_groups  = [aws_security_group.sg_pihole_ecs.id]
  }

  tags = {
    Name = "${var.Prefix}-pihole"
  }
  lifecycle {
    ignore_changes = [
      task_definition, health_check_grace_period_seconds
    ]
  }
}
