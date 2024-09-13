resource "aws_ecs_task_definition" "pihole" {
  family                   = "${var.Prefix}-pihole"
  task_role_arn            = aws_iam_role.ecsTaskRole.arn
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.ecsTaskExecutionRole.arn
  cpu                      = var.task_specs.cpu
  memory                   = var.task_specs.memory
  network_mode             = "awsvpc"

  volume {
    name = "pihole-config"
    efs_volume_configuration {
      file_system_id          = aws_efs_file_system.efs_for_fargate.id
      transit_encryption      = "ENABLED"
      transit_encryption_port = 2996
      authorization_config {
        access_point_id = aws_efs_access_point.pihole_access_point_config.id
        iam             = "DISABLED"
      }
    }
  }

  volume {
    name = "pihole-dns"
    efs_volume_configuration {
      file_system_id          = aws_efs_file_system.efs_for_fargate.id
      transit_encryption      = "ENABLED"
      transit_encryption_port = 2995
      authorization_config {
        access_point_id = aws_efs_access_point.pihole_access_point_dnsmasq.id
        iam             = "DISABLED"
      }
    }
  }

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
  tags = {
    Name = "${var.Prefix}-pihole"
  }

  container_definitions = jsonencode([
    {
      name      = "pihole"
      image     = "${local.pihole_image}"
      cpu       = var.task_specs.cpu
      memory    = var.task_specs.memory
      essential = true
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/container_cluster_${var.Prefix}"
          awslogs-region        = data.aws_region.current.name
          awslogs-create-group  = "true"
          awslogs-stream-prefix = "ecs"
        }
      },
      environment = [
        {
          name  = "TZ"
          value = "${var.timezone}"
        }
      ],

      mountPoints = [
        {
          containerPath = "/etc/pihole",
          sourceVolume  = "pihole-config"
        },
        {
          containerPath = "/etc/dnsmasq.d",
          sourceVolume  = "pihole-dns"
        },
      ],

      portMappings = [
        {
          containerPort = 80,
          protocol      = "tcp",
          hostport      = 80
        },
        {
          containerPort = 53,
          protocol      = "tcp",
          hostport      = 53
        },
        {
          containerPort = 53,
          protocol      = "udp",
          hostport      = 53
        }
      ]
    }
  ])
}