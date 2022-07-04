#------------------------------------------------------------------------------
# SonarQube ALB DNS
#------------------------------------------------------------------------------
output "sonar_lb_id" {
  description = "SonarQube Load Balancer ID"
  value       = module.ecs_fargate.aws_lb_lb_id
}

output "sonar_lb_arn" {
  description = "SonarQube Load Balancer ARN"
  value       = module.ecs_fargate.aws_lb_lb_arn
}

output "sonar_lb_arn_suffix" {
  description = "SonarQube Load Balancer ARN Suffix"
  value       = module.ecs_fargate.aws_lb_lb_arn_suffix
}

output "sonar_lb_dns_name" {
  description = "SonarQube Load Balancer DNS Name"
  value       = module.ecs_fargate.aws_lb_lb_dns_name
}

output "sonar_lb_zone_id" {
  description = "SonarQube Load Balancer Zone ID"
  value       = module.ecs_fargate.aws_lb_lb_zone_id
}

#------------------------------------------------------------------------------
# AWS SECURITY GROUPS
#------------------------------------------------------------------------------
output "ecs_tasks_sg_id" {
  description = "SonarQube ECS Tasks Security Group - The ID of the security group"
  value       = module.ecs_fargate.ecs_tasks_sg_id
}
