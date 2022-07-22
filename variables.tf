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
# CloudWatch logs
#------------------------------------------------------------------------------
variable "create_kms_key" {
  description = "If true a new KMS key will be created to encrypt the logs. Defaults true. If set to false a custom key can be used by setting the variable `log_group_kms_key_id`"
  type        = bool
  default     = false
}

variable "log_group_kms_key_id" {
  description = "The ARN of the KMS Key to use when encrypting log data. Please note, after the AWS KMS CMK is disassociated from the log group, AWS CloudWatch Logs stops encrypting newly ingested data for the log group. All previously ingested data remains encrypted, and AWS CloudWatch Logs requires permissions for the CMK whenever the encrypted data is requested."
  type        = string
  default     = null
}

variable "log_group_retention_in_days" {
  description = "(Optional) Specifies the number of days you want to retain log events in the specified log group. Possible values are: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653, and 0. If you select 0, the events in the log group are always retained and never expire. Default to 30 days."
  type        = number
  default     = 30
}

#------------------------------------------------------------------------------
# APPLICATION LOAD BALANCER LOGS
#------------------------------------------------------------------------------
variable "enable_s3_logs" {
  description = "(Optional) If true, all resources to send LB logs to S3 will be created"
  type        = bool
  default     = true
}

variable "block_s3_bucket_public_access" {
  description = "(Optional) If true, public access to the S3 bucket will be blocked."
  type        = bool
  default     = true
}

variable "enable_s3_bucket_server_side_encryption" {
  description = "(Optional) If true, server side encryption will be applied."
  type        = bool
  default     = true
}

variable "s3_bucket_server_side_encryption_sse_algorithm" {
  description = "(Optional) The server-side encryption algorithm to use. Valid values are AES256 and aws:kms"
  type        = string
  default     = "AES256"
}

variable "s3_bucket_server_side_encryption_key" {
  description = "(Optional) The AWS KMS master key ID used for the SSE-KMS encryption. This can only be used when you set the value of sse_algorithm as aws:kms. The default aws/s3 AWS KMS master key is used if this element is absent while the sse_algorithm is aws:kms."
  type        = string
  default     = null
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
# Sonarqube storage settings
#------------------------------------------------------------------------------

variable "ephemeral_storage_size" {
  type        = number
  description = "The number of GBs to provision for ephemeral storage on Fargate tasks. Must be greater than or equal to 21 and less than or equal to 200"
  default     = 0
}

variable "volumes" {
  description = "(Optional) A set of volume blocks that containers in your task may use"
  type = list(object({
    host_path = string
    name      = string
    docker_volume_configuration = list(object({
      autoprovision = bool
      driver        = string
      driver_opts   = map(string)
      labels        = map(string)
      scope         = string
    }))
    efs_volume_configuration = list(object({
      file_system_id          = string
      root_directory          = string
      transit_encryption      = string
      transit_encryption_port = string
      authorization_config = list(object({
        access_point_id = string
        iam             = string
      }))
    }))
  }))
  default = []
}

variable "mount_points" {
  type = list(any)

  description = "Container mount points. This is a list of maps, where each map should contain a `containerPath` and `sourceVolume`. The `readOnly` key is optional."
  default     = []
}

#------------------------------------------------------------------------------
# AWS ECS Container Definition Variables
#------------------------------------------------------------------------------

variable "container_memory" {
  type        = number
  description = "(Optional) The amount of memory (in MiB) to allow the container to use. This is a hard limit, if the container attempts to exceed the container_memory, the container is killed. This field is optional for Fargate launch type and the total amount of container_memory of all containers in a task will need to be lower than the task memory value"
  default     = 8192 # 8 GB
}

variable "container_memory_reservation" {
  type        = number
  description = "(Optional) The amount of memory (in MiB) to reserve for the container. If container needs to exceed this threshold, it can do so up to the set container_memory hard limit"
  default     = 4096 # 4 GB
}

variable "container_cpu" {
  # https://docs.aws.amazon.com/AmazonECS/latest/developerguide/AWS_Fargate.html#fargate-task-defs
  type        = number
  description = "(Optional) The number of cpu units to reserve for the container. This is optional for tasks using Fargate launch type and the total amount of container_cpu of all containers in a task will need to be lower than the task-level cpu value"
  default     = 4096 # 4 vCPU
}

variable "permissions_boundary" {
  description = "(Optional) The ARN of the policy that is used to set the permissions boundary for the `ecs_task_execution_role` role."
  type        = string
  default     = null
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
