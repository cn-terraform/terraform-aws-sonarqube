# ---------------------------------------------------------------------------------------------------------------------
# AWS KMS Encryption Key
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_kms_key" "encryption_key" {
  description         = "Sonar Encryption Key"
  is_enabled          = true
  enable_key_rotation = true
}

# ---------------------------------------------------------------------------------------------------------------------
# AWS RDS Subnet Group
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_db_subnet_group" "aurora_db_subnet_group" {
  name       = "${var.name_preffix}-sonar-aurora-db-subnet-group"
  subnet_ids = var.private_subnets_ids
}

# ---------------------------------------------------------------------------------------------------------------------
# AWS RDS Aurora Cluster
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_rds_cluster" "aurora_db" {
  depends_on = [aws_kms_key.encryption_key]

  # Cluster
  cluster_identifier     = "${var.name_preffix}-sonar-aurora-db"
  vpc_security_group_ids = [aws_security_group.aurora_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.aurora_db_subnet_group.id

  # Encryption
  storage_encrypted = true
  kms_key_id        = aws_kms_key.encryption_key.arn

  # Logs
  #enabled_cloudwatch_logs_exports = ["audit", "error", "general"]
  # Database
  engine          = "aurora-postgresql"
  engine_version  = local.sonar_postgres_sql_db_version
  database_name   = local.sonar_db_name
  master_username = local.sonar_db_username
  master_password = local.sonar_db_password

  # Backups
  backup_retention_period = 3
  preferred_backup_window = "07:00-09:00"
  skip_final_snapshot     = true
  tags = {
    Name = "${var.name_preffix}-sonar-aurora-db"
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# AWS RDS Aurora Cluster Instances
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_rds_cluster_instance" "aurora_db_cluster_instances" {
  count                = length(var.availability_zones)
  identifier           = "aurora-db-instance-${count.index}"
  cluster_identifier   = aws_rds_cluster.aurora_db.id
  db_subnet_group_name = aws_db_subnet_group.aurora_db_subnet_group.id
  engine               = "aurora-postgresql"
  engine_version       = local.sonar_postgres_sql_db_version
  instance_class       = local.sonar_db_instance_size
  publicly_accessible  = true
  tags = {
    Name = "${var.name_preffix}-sonar-aurora-db-cluster-instances-${count.index}"
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# AWS Security Groups - Allow traffic to Aurora DB only on PostgreSQL port and only coming from ECS SG
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_security_group" "aurora_sg" {
  name        = "${var.name_preffix}-sonar-aurora-sg"
  description = "Allow traffic to Aurora DB only on PostgreSQL port and only coming from ECS SG"
  vpc_id      = var.vpc_id
  ingress {
    protocol  = "tcp"
    from_port = local.sonar_postgre_sql_port
    to_port   = local.sonar_postgre_sql_port
    # TF-UPGRADE-TODO: In Terraform v0.10 and earlier, it was sometimes necessary to
    # force an interpolation expression to be interpreted as a list by wrapping it
    # in an extra set of list brackets. That form was supported for compatibilty in
    # v0.11, but is no longer supported in Terraform v0.12.
    # If the expression in the following list itself returns a list, remove the
    # brackets to avoid interpretation as a list of lists. If the expression
    # returns a single list item then leave it as-is and remove this TODO comment.
    security_groups = [ module.ecs_fargate.ecs_tasks_sg_id ]
  }
  egress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.name_preffix}-sonar-aurora-sg"
  }
}

