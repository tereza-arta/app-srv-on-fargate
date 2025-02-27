resource "aws_ecs_cluster" "main" {
  name = "cb-cluster"
}

data "aws_iam_policy_document" "policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_task_exec_role" {
  count              = 1
  name               = "ecsTaskExecutionRole"
  assume_role_policy = data.aws_iam_policy_document.policy.json
}

resource "aws_iam_role_policy_attachment" "ecs_rp_attach" {
  role       = aws_iam_role.ecs_task_exec_role[0].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_ecs_task_definition" "this" {
  count                    = 1
  family                   = "srv-task-def"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.ecs_task_exec_role[0].arn
  network_mode             = "awsvpc"
  cpu                      = 1024
  memory                   = 2048

  container_definitions = jsonencode([
    {
      name   = "srv-cnt"
      image  = "${var.repo_url[0]}:latest"
      cpu    = 1024
      memory = 2048
      portMappings = [
        {
          containerPort = 5000
          hostPort      = 5000
        }
      ]
      environment = var.app_port != 5000 ? [] : [
        {
          name  = var.env_1
          value = var.db_username
        },
        {
          name  = var.env_2
          value = var.db_password
        },
        {
          name  = var.env_3
          value = var.db_name
        },
        {
          name  = var.env_4
          value = var.db_host
        },
        {
          name  = var.env_5
          value = var.db_port
        }
      ]
    }

  ])
  #depends_on = [var.task_def_dependency]
}

resource "aws_ecs_service" "svc" {
  name            = "cb-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.this[0].arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [var.ecs_sg_id]
    subnets          = var.priv_sub_id
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = var.tg_id
    container_name   = "srv-cnt"
    container_port   = 5000
  }

  #depends_on = [aws_alb_listener.this, aws_iam_role_policy_attachment.ecs_rp_attach]
}
