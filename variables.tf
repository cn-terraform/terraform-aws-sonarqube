#------------------------------------------------------------------------------
# Misc
#------------------------------------------------------------------------------
variable "name_prefix" {
  type        = string
  description = "Name prefix for resources on AWS"
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
}

#------------------------------------------------------------------------------
# AWS Networking
#------------------------------------------------------------------------------
variable "vpc_id" {
  type        = string
  description = "ID of the VPC"
}

variable "availability_zones" {
  type        = list(string)
  description = "List of Availability Zones"
}

variable "public_subnets_ids" {
  type        = list(string)
  description = "List of Public Subnets IDs"
}

variable "private_subnets_ids" {
  type        = list(string)
  description = "List of Private Subnets IDs"
}

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
  default     = ""
  description = "DB password"
}

variable "lb_enable_cross_zone_load_balancing" {
  type        = string
  default     = "true"
  description = "Enable cross zone support for LB"
}

variable "lb_http_ports" {
  description = "Map containing objects to define listeners behaviour based on type field. If type field is `forward`, include listener_port and the target_group_port. For `redirect` type, include listener port, host, path, port, protocol, query and status_code. For `fixed-response`, include listener_port, content_type, message_body and status_code"
  type        = map(any)
  default     = {}
}

variable "lb_https_ports" {
  description = "Map containing objects to define listeners behaviour based on type field. If type field is `forward`, include listener_port and the target_group_port. For `redirect` type, include listener port, host, path, port, protocol, query and status_code. For `fixed-response`, include listener_port, content_type, message_body and status_code"
  type        = map(any)
  default = {
    default = {
      listener_port         = 443
      target_group_port     = 9000
      target_group_protocol = "HTTP"
    }
  }
}

#------------------------------------------------------------------------------
# AWS RDS settings
#------------------------------------------------------------------------------
variable "db_engine_version" {
  type        = string
  default     = "14.2"
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


variable "enable_autoscaling" {
  type        = bool
  default     = false
  description = "Enable auto scaling for datacenter edition"
}

#------------------------------------------------------------------------------
# Sonarqube SSL settings
#------------------------------------------------------------------------------
variable "enable_ssl" {
  description = "Enable SSL"
  type        = bool
  default     = true
}


variable "dns_zone_id" {
  description = "Route 53 zone id"
  type        = string
  default     = ""
}

variable "https_record_name" {
  description = "Route 53 dns name"
  type        = string
  default     = ""
}

variable "https_record_domain_name" {
  description = "Route 53 domain name"
  type        = string
  default     = ""
}
