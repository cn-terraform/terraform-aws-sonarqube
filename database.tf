# ---------------------------------------------------------------------------------------------------------------------
# AWS RDS Subnet Group
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_db_subnet_group" "aurora_db_subnet_group" {
    name       = "${var.name_preffix}-sonar-aurora-db-subnet-group"
    subnet_ids = [ "${var.private_subnets_ids}" ]
}

# ---------------------------------------------------------------------------------------------------------------------
# AWS RDS Aurora Cluster
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_rds_cluster" "aurora_db" {
    depends_on              = [ "aws_kms_key.encryption_key" ]
    # Cluster
    cluster_identifier      = "${var.name_preffix}-sonar-aurora-db"
    vpc_security_group_ids  = [ "${aws_security_group.aurora_sg.id}" ]
    db_subnet_group_name    = "${aws_db_subnet_group.aurora_db_subnet_group.id}"
    # Encryption
    storage_encrypted       = true
    kms_key_id              = "${aws_kms_key.encryption_key.arn}"
    # Logs
    #enabled_cloudwatch_logs_exports = ["audit", "error", "general"]
    # Database
    engine                  = "aurora-postgresql"
    engine_version          = "${local.sonar_postgre_sql_db_version}"
    database_name           = "${local.sonar_db_name}"
    master_username         = "${local.sonar_db_username}"
    master_password         = "${local.sonar_db_password}"
    # Backups
    backup_retention_period = 3
    preferred_backup_window = "07:00-09:00"
    skip_final_snapshot     = true
    tags {
        Name = "${var.name_preffix}-sonar-aurora-db"
    } 
}

# ---------------------------------------------------------------------------------------------------------------------
# AWS RDS Aurora Cluster Instances
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_rds_cluster_instance" "aurora_db_cluster_instances" {
    count                = "${length(var.availability_zones)}"
    identifier           = "aurora-db-instance-${count.index}"
    cluster_identifier   = "${aws_rds_cluster.aurora_db.id}"
    db_subnet_group_name = "${aws_db_subnet_group.aurora_db_subnet_group.id}"
    engine               = "aurora-postgresql"
    engine_version       = "${local.sonar_postgre_sql_db_version}"
    instance_class       = "${local.sonar_db_instance_size}"
    publicly_accessible  = true
    tags {
        Name = "${var.name_preffix}-sonar-aurora-db-cluster-instances-${count.index}"
    } 
}
