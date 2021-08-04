#------------------------------------------------------------------------------
# Misc
#------------------------------------------------------------------------------
variable "name_prefix" {
  type        = string
  description = "Name prefix for resources on AWS"
  default     = "devops"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Resource tags"
}

#------------------------------------------------------------------------------
# AWS REGION
#------------------------------------------------------------------------------
variable "region" {
  type        = string
  description = "AWS Region the infrastructure is hosted in"
  default     = "us-east-1"
}

#------------------------------------------------------------------------------
# AWS Networking
#------------------------------------------------------------------------------
# variable "data.terraform_remote_state.aws_simulator_network.outputs.vpc_id" {
#   type        = string
#   description = "ID of the VPC"
#   default     = data.terraform_remote_state.aws_simulator_network.outputs.data.terraform_remote_state.aws_simulator_network.outputs.vpc_id
# }

# variable "data.terraform_remote_state.aws_simulator_network.outputs.azs" {
#   type        = list(string)
#   description = "List of Availability Zones"
#   default     = data.terraform_remote_state.aws_simulator_network.outputs.azs
# }

# variable "data.terraform_remote_state.aws_simulator_network.outputs.public_subnets_ids" {
#   type        = list(string)
#   description = "List of Public Subnets IDs"
#   default     = data.terraform_remote_state.aws_simulator_network.outputs.data.terraform_remote_state.aws_simulator_network.outputs.public_subnets_ids
# }

# variable "data.terraform_remote_state.aws_simulator_network.outputs.data.terraform_remote_state.aws_simulator_network.outputs.public_subnets_ids" {
#   type        = list(string)
#   description = "List of Private Subnets IDs"
#   default     = data.terraform_remote_state.aws_simulator_network.outputs.data.terraform_remote_state.aws_simulator_network.outputs.public_subnets_ids
# }

variable "db_instance_size" {
  type        = string
  default     = "db.r4.large"
  description = "DB instance size"
}

variable "db_name" {
  type        = string
  default     = "sonar"
  description = "Default DB name"
}

variable "db_username" {
  type        = string
  default     = "sonar"
  description = "Default DB username"
}

variable "db_password" {
  type        = string
  default     = "1qazWSX3edc"
  description = "DB password"
}

#------------------------------------------------------------------------------
# AWS RDS settings
#------------------------------------------------------------------------------
variable "db_engine_version" {
  type        = string
  default     = "11.7"
  description = "DB engine version"
}

#------------------------------------------------------------------------------
# Sonarqube image version
#------------------------------------------------------------------------------
variable "sonarqube_image" {
  description = "Sonarqube image"
  type        = string
  default     = "sonarqube:lts"
}
