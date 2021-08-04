# Load balancer to access the simulator using certificate
resource "aws_lb" "this" {
  name               = "sonarqube"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [module.sg_sonarqube_alb.this_security_group_id]
  subnets            = data.terraform_remote_state.devops_infra_shared.outputs.public_subnets_ids

  enable_deletion_protection = false

  tags = {
    Name = "Sonarqube"
    DeploymentEnv = "production"
    Application = "sonarqube"
    Type = "ALB"
  }
}

# Default target group
resource "aws_lb_target_group" "sonarqube" {
  name     = "sonarqube-fargate"
  port     = 9000
  protocol = "HTTP"
  target_type = "ip"
  deregistration_delay = 5
  vpc_id   = data.terraform_remote_state.devops_infra_shared.outputs.vpc_id
  health_check {
      healthy_threshold   = 2
      interval            = 35
      timeout             = 30
      unhealthy_threshold = 10
      port                = 9000
  }
}

# Default listener
resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.this.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = data.aws_acm_certificate.issued.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.sonarqube.arn
  }
}

