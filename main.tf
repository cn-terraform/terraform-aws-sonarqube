# ---------------------------------------------------------------------------------------------------------------------
# PROVIDER
# ---------------------------------------------------------------------------------------------------------------------
provider "aws" {
    profile   = "${var.profile}"
    region    = "${var.region}"
}

# ---------------------------------------------------------------------------------------------------------------------
# Variables
# ---------------------------------------------------------------------------------------------------------------------
locals {
    sonar_container_name         = "sonar"
    sonar_cloudwatch_log_path    = "/ecs/service/${var.name_preffix}-sonar"
    sonar_container_web_port     = 9000
    sonar_fargate_cpu_value      = 2048 # 2 vCPU  - https://docs.aws.amazon.com/AmazonECS/latest/developerguide/AWS_Fargate.html#fargate-task-defs
    sonar_fargate_memory_value   = 4096 # 4 GB    - https://docs.aws.amazon.com/AmazonECS/latest/developerguide/AWS_Fargate.html#fargate-task-defs
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
    description = "Sonar Encryption Key"
    is_enabled = true
    enable_key_rotation = true
}