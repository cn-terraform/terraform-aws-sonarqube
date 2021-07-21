#------------------------------------------------------------------------------
# Variables
#------------------------------------------------------------------------------
locals {
  sonar_db_engine_version = var.db_engine_version
  sonar_db_port           = 5432
  sonar_db_instance_size  = var.db_instance_size
  sonar_db_name           = var.db_name
  sonar_db_username       = var.db_username
  sonar_db_password       = var.db_password == "" ? random_password.master_password.result : var.db_password
}

#------------------------------------------------------------------------------
# Random password for RDS
#------------------------------------------------------------------------------
resource "random_password" "master_password" {
  length  = 10
  special = false
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

#------------------------------------------------------------------------------
# ECS Fargate Service
#------------------------------------------------------------------------------
module "ecs_fargate" {
  source  = "cn-terraform/ecs-fargate/aws"
  version = "2.0.26"
  # source = "../terraform-aws-ecs-fargate"

  name_prefix                  = "${var.name_prefix}-sonar"
  vpc_id                       = var.vpc_id
  public_subnets_ids           = var.public_subnets_ids
  private_subnets_ids          = var.private_subnets_ids
  container_name               = "${var.name_prefix}-sonar"
  container_image              = var.sonarqube_image
  container_cpu                = 4096
  container_memory             = 8192
  container_memory_reservation = 4096
  lb_http_ports = {
    default = {
      listener_port     = 80
      target_group_port = 9000
    }
  }
  lb_https_ports = {}
  command = [
    "-Dsonar.search.javaAdditionalOpts=-Dnode.store.allow_mmap=false"
  ]
  ulimits = [
    {
      "name" : "nofile",
      "softLimit" : 65535,
      "hardLimit" : 65535
    }
  ]
  port_mappings = [
    {
      containerPort = 9000
      hostPort      = 9000
      protocol      = "tcp"
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
  ]
  log_configuration = {
    logDriver = "awslogs"
    options = {
      "awslogs-region"        = var.region
      "awslogs-group"         = "/ecs/service/${var.name_prefix}-sonar"
      "awslogs-stream-prefix" = "ecs"
    }
    secretOptions = null
  }

  tags = var.tags
}