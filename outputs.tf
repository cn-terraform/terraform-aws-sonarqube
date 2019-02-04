# ---------------------------------------------------------------------------------------------------------------------
# SonarQube ALB DNS
# ---------------------------------------------------------------------------------------------------------------------
output "sonar_alb_id" {
    description = "SonarQube Application Load Balancer ID"
    value = "${aws_alb.sonar_alb.id}"
}
output "sonar_alb_arn" {
    description = "SonarQube Application Load Balancer ARN"
    value = "${aws_alb.sonar_alb.arn}"
}
output "sonar_alb_arn_suffix" {
    description = "SonarQube Application Load Balancer ARN Suffix"
    value = "${aws_alb.sonar_alb.arn_suffix}"
}
output "sonar_alb_dns_name" {
    description = "SonarQube Application Load Balancer DNS Name"
    value = "${aws_alb.sonar_alb.dns_name}"
}
output "sonar_alb_zone_id" {
    description = "SonarQube Application Load Balancer Zone ID"
    value = "${aws_alb.sonar_alb.zone_id}"
}
