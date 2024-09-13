resource "aws_ecs_task_definition" "vpn" {
  family                   = "vpn-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  container_definitions    = jsonencode([{
    name      = "vpn"
    image     = aws_ecr_repository.vpn.repository_url
    essential = true
    portMappings = [
      {
        containerPort = 1194
        protocol      = "udp"
      }
    ]
  }])

  tags = {
    Name = "vpn-task"
  }
}