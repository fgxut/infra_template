resource "aws_ecs_cluster" "example" {
  name = "${var.common["env_abbr"]}-${var.common["name"]}-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = {
    Name = "${var.common["env_abbr"]}-${var.common["name"]}-cluster"
    env  = var.common["env"]
  }
}

resource "aws_ecs_task_definition" "example" {
  family                   = "${var.common["env_abbr"]}-${var.common["name"]}-task-definition"
  cpu                      = var.wordpress["ecs_task_cpu"]
  memory                   = var.wordpress["ecs_task_memory"]
  task_role_arn            = aws_iam_role.example_ecs_task_role.arn
  execution_role_arn       = aws_iam_role.example_ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]

  container_definitions = jsonencode([
    {
      "name" : "${var.common["env_abbr"]}-${var.common["name"]}-app",
      "image" : "wordpress:latest", # ${aws_ecr_repository.example.repository_url}:latest
      "essential" : true,
      "logConfiguration" : {
        "logDriver" : "awslogs",
        "options" : {
          "awslogs-region" : "${var.common["region"]}",
          "awslogs-group" : "${aws_cloudwatch_log_group.example_ecs.name}",
          "awslogs-stream-prefix" : "app"
        }
      },
      "portMappings" : [
        {
          "hostPort" : 80,
          "protocol" : "tcp",
          "containerPort" : 80
        }
      ],
      "mountPoints" : [
        {
          "sourceVolume" : "${var.common["env_abbr"]}-${var.common["name"]}-ecs-efs"
          "containerPath" : "/var/www/html",
        }
      ],
      "environment" : [
        {
          "name" : "WORDPRESS_DB_HOST",
          "value" : "${data.aws_db_instance.example.address}"
        },
        {
          "name" : "WORDPRESS_DB_USER",
          "value" : "${var.rds["aws_db_instance_instance_username"]}"
        },
        {
          "name" : "WORDPRESS_DB_NAME",
          "value" : "${var.rds["aws_db_instance_instance_dbname"]}"
        }
      ]
      "secrets" : [
        {
          "name" : "WORDPRESS_DB_PASSWORD",
          "valueFrom" : "arn:aws:ssm:${var.common["region"]}:${var.common["account_id"]}:parameter/${var.common["env_abbr"]}-${var.common["name"]}-wordpress-db-password"
        }
      ]
    }
  ])

  volume {
    name = "${var.common["env_abbr"]}-${var.common["name"]}-ecs-efs"

    efs_volume_configuration {
      file_system_id = aws_efs_file_system.example.id
    }
  }

  tags = {
    Name = "${var.common["env_abbr"]}-${var.common["name"]}-task-definition"
    env  = var.common["env"]
  }
}

resource "aws_ecs_service" "example" {
  name                               = "${var.common["env_abbr"]}-${var.common["name"]}-service"
  launch_type                        = "FARGATE"
  cluster                            = aws_ecs_cluster.example.id
  platform_version                   = var.wordpress["ecs_fargate_platform_version"]
  desired_count                      = var.wordpress["ecs_desired_count"]
  deployment_minimum_healthy_percent = var.wordpress["ecs_deployment_minimum_healthy_percent"]
  deployment_maximum_percent         = var.wordpress["ecs_deployment_maximum_percent"]
  propagate_tags                     = "SERVICE"
  enable_execute_command             = true
  health_check_grace_period_seconds  = 180

  # Track the latest ACTIVE revision
  task_definition = "${aws_ecs_task_definition.example.family}:${max(
    aws_ecs_task_definition.example.revision,
    data.aws_ecs_task_definition.example.revision,
  )}"

  deployment_controller {
    type = "ECS"
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.example_blue.id
    container_name   = "${var.common["env_abbr"]}-${var.common["name"]}-app"
    container_port   = 80
  }

  network_configuration {
    subnets = [
      var.aws_subnet["example_public"][0].id,
      var.aws_subnet["example_public"][1].id,
      var.aws_subnet["example_public"][2].id
    ]
    security_groups = [
      aws_security_group.example_ecs.id,
      aws_security_group.example_blue_green.id,
    ]
    assign_public_ip = true
  }

  # desired_count: do not track task number
  # load_balancer: ECS Fargate deployment is Blue/Green so AWS code deploy change load balancer resources
  # service_registries: Service discovery updates port every time new containers register
  lifecycle {
    ignore_changes = [
      desired_count,
      load_balancer,
      service_registries,
      task_definition
    ]
  }

  tags = {
    Name = "${var.common["env_abbr"]}-${var.common["name"]}-service"
    env  = var.common["env"]
  }
}
