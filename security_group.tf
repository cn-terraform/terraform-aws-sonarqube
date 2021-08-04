# SG for each simulator environment
module "sg_sonarqube_container" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 3.0"

  name        = "sonarqube_container"
  description = "Security group for to allow communication between sonarqube and alb"
  vpc_id      = data.terraform_remote_state.devops_infra_shared.outputs.vpc_id
  egress_cidr_blocks      = ["0.0.0.0/0"]
  egress_rules            = ["all-all"]
}

# SG for ALB
module "sg_sonarqube_alb" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 3.0"

  name        = "sonarqube_alb"
  description = "Security group for to allow HTTPS"
  vpc_id      = data.terraform_remote_state.devops_infra_shared.outputs.vpc_id

  ingress_cidr_blocks      = ["0.0.0.0/0"]
  ingress_rules            = ["https-443-tcp"]
  egress_cidr_blocks      = ["0.0.0.0/0"]
  egress_rules            = ["all-all"]
}

# SG that allow total communication between the resource
resource "aws_security_group_rule" "allow_communication_internal" {
  type              = "ingress"
  from_port         = 9000
  to_port           = 9000
  protocol          = "all"
  security_group_id       = "${module.sg_sonarqube_container.this_security_group_id}" 
  source_security_group_id  = "${module.sg_sonarqube_alb.this_security_group_id}" 
}
