# Network project remote state
data "terraform_remote_state" "devops_infra_shared" {
  backend = "s3"
  config = {
    bucket     = "movai.terraform"
    key    = "devops-infra-shared.tfstate"
    region     = "us-east-1"
  }
}

data "aws_route53_zone" "movai" {
  name = "aws.cloud.mov.ai"
}


data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_acm_certificate" "issued" {
  domain   = "*.${data.aws_route53_zone.movai.name}"
  statuses = ["ISSUED"]
}
