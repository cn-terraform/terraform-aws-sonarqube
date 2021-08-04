
resource "aws_ecs_cluster" "this" {
  name = "sonarqube"
}

#------------------------------------------------------------------------------
# AWS Cloudwatch Logs
#------------------------------------------------------------------------------
module "aws_cw_logs" {
  source  = "cn-terraform/cloudwatch-logs/aws"
  version = "1.0.8"
  # source  = "../terraform-aws-cloudwatch-logs"

  logs_path = "/ecs/service/${var.name_prefix}-sonar"
  tags      = var.tags
}


resource "aws_ecs_service" "this" {
  name            = "sonarqube"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.this.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  health_check_grace_period_seconds = 30
  network_configuration {
    security_groups = [module.sg_sonarqube_container.this_security_group_id]
    subnets = data.terraform_remote_state.devops_infra_shared.outputs.public_subnets_ids
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.sonarqube.arn
    container_name   = "${var.name_prefix}-sonarqube"
    container_port   = 9000
  }

}

resource "aws_ecs_task_definition" "this" {
  family = "sonarqube"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu        = 4096
  memory     = 8192
  task_role_arn           = aws_iam_role.this.arn
  execution_role_arn      = aws_iam_role.this.arn
  container_definitions = jsonencode([
    {
      name       = "${var.name_prefix}-sonarqube"
      image      = var.sonarqube_image
      essential  = true
      cpu        = 4096
      memory     = 8192
      memoryReservation = 4096
      command    = [
        "-Dsonar.search.javaAdditionalOpts=-Dnode.store.allow_mmap=false"
      ]
      portMappings = [
        {
          containerPort = 9000
          hostPort      = 9000
          protocol      = "tcp"
        }
      ]
      ulimits = [
        {
          "name" : "nofile",
          "softLimit" : 65535,
          "hardLimit" : 65535
        }
      ]
      environment = [
        {
          name  = "SONAR_JDBC_USERNAME"
          value = local.sonar_db_username
        },
        {
          name  = "SONAR_JDBC_PASSWORD"
          value = local.sonar_db_password
        },
        {
          name  = "SONAR_JDBC_URL"
          value = "jdbc:postgresql://${aws_rds_cluster.aurora_db.endpoint}/${local.sonar_db_name}?sslmode=require"
        },
      ],
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "/fargate/service/sonarqube",
          "awslogs-region": "us-east-1",
          "awslogs-stream-prefix": "ecs"
        }
      }
    }
  ])

}

variable "logs_retention_in_days" {
  type        = number
  default     = 90
  description = "Specifies the number of days you want to retain log events"
}

resource "aws_cloudwatch_log_group" "logs" {
  name              = "/fargate/service/sonarqube"
  retention_in_days = var.logs_retention_in_days
}