resource "aws_route53_record" "record_dns" {
  count = var.enable_ssl ? 1 : 0

  zone_id = var.dns_zone_id
  name    = var.https_record_name
  type    = "A"

  alias {
    name                   = module.ecs_fargate.aws_lb_lb_dns_name
    zone_id                = module.ecs_fargate.aws_lb_lb_zone_id
    evaluate_target_health = true
  }
}

module "acm" {
  count = var.enable_ssl ? 1 : 0

  source  = "terraform-aws-modules/acm/aws"
  version = "~> 4.0"

  domain_name = var.https_record_domain_name
  zone_id     = var.dns_zone_id

  subject_alternative_names = [
    "*.${var.https_record_domain_name}",
  ]

  wait_for_validation = true

  tags = var.tags
}
