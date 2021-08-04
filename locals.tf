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