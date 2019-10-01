# ---------------------------------------------------------------------------------------------------------------------
# PROVIDER
# ---------------------------------------------------------------------------------------------------------------------
provider "aws" {
  profile = var.profile
  region  = var.region
}

# ---------------------------------------------------------------------------------------------------------------------
# Variables
# ---------------------------------------------------------------------------------------------------------------------
locals {
  sonar_postgre_sql_db_version = "10.6"
  sonar_postgre_sql_port       = 5432
  sonar_postgre_sql_db         = "sonar"
  sonar_db_instance_size       = "db.r4.large"
  sonar_db_name                = "sonar"
  sonar_db_username            = "sonar"
  sonar_db_password            = "${var.name_preffix}-sonar-pass"
}

# ---------------------------------------------------------------------------------------------------------------------
# ECS Cluster
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_ecs_cluster" "sonar_cluster" {
  name = "${var.name_preffix}-sonar"
}

# ---------------------------------------------------------------------------------------------------------------------
# AWS KMS Encryption Key
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_kms_key" "encryption_key" {
  description         = "Sonar Encryption Key"
  is_enabled          = true
  enable_key_rotation = true
}

# ---------------------------------------------------------------------------------------------------------------------
# ECS Fargate Service
# ---------------------------------------------------------------------------------------------------------------------
module "ecs_fargate" {
  source  = "cn-terraform/ecs-fargate/aws"
  version = "2.0.1"
  #source = "../terraform-aws-ecs-fargate"

  name_preffix                 = "${var.name_preffix}-sonar"
  profile                      = var.profile
  region                       = var.region
  vpc_id                       = var.vpc_id
  availability_zones           = ["var.availability_zones"]
  public_subnets_ids           = ["var.public_subnets_ids"]
  private_subnets_ids          = ["var.private_subnets_ids"]
  container_name               = "${var.name_preffix}-sonar"
  container_image              = "sonarqube:7.6-community"
  container_cpu                = 1024
  container_memory             = 8192
  container_memory_reservation = 2048
  container_port               = 9000
  environment = [
    {
      name  = "sonar.jdbc.username"
      value = local.sonar_db_username
    },
    {
      name  = "sonar.jdbc.password"
      value = local.sonar_db_password
    },
    {
      name  = "sonar.jdbc.url"
      value = "jdbc:postgresql://${aws_rds_cluster.aurora_db.endpoint}/${local.sonar_db_name}"
    },
  ]
}
