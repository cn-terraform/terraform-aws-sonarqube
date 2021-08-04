#------------------------------------------------------------------------------
# SonarQube ALB DNS
#------------------------------------------------------------------------------
output "sonar_lb_dns_name" {
  description = "SonarQube Load Balancer DNS Name"
  value       = aws_lb.this.dns_name
}
# output "sonar_route53_dns_name" {
#   description = "SonarQube Domain Name"
#   value       = ${aws_route53_record.public_record_domain.name} . "." . ${data.aws_route53_zone.movai.name}
# }
