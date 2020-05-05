# ---------------------------------------------------------------------------------------------------------------------
# Misc
# ---------------------------------------------------------------------------------------------------------------------
variable "name_preffix" {
  description = "Name preffix for resources on AWS"
}

# ---------------------------------------------------------------------------------------------------------------------
# AWS Networking
# ---------------------------------------------------------------------------------------------------------------------
variable "vpc_id" {
  description = "ID of the VPC"
}

variable "availability_zones" {
  type        = list
  description = "List of Availability Zones"
}

variable "public_subnets_ids" {
  type        = list
  description = "List of Public Subnets IDs"
}

variable "private_subnets_ids" {
  type        = list
  description = "List of Private Subnets IDs"
}

