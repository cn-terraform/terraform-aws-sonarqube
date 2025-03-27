module "base-network" {
  source  = "cn-terraform/networking/aws"
  version = "3.0.0"

  cidr_block = "192.168.0.0/16"

  public_subnets = {
    first_public_subnet = {
      availability_zone = "us-east-1a"
      cidr_block        = "192.168.0.0/19"
    }
    second_public_subnet = {
      availability_zone = "us-east-1b"
      cidr_block        = "192.168.32.0/19"
    }
    third_public_subnet = {
      availability_zone = "us-east-1c"
      cidr_block        = "192.168.64.0/19"
    }
    fourth_public_subnet = {
      availability_zone = "us-east-1d"
      cidr_block        = "192.168.96.0/19"
    }
  }

  private_subnets = {
    first_private_subnet = {
      availability_zone = "us-east-1a"
      cidr_block        = "192.168.128.0/19"
    }
    second_private_subnet = {
      availability_zone = "us-east-1b"
      cidr_block        = "192.168.160.0/19"
    }
    third_private_subnet = {
      availability_zone = "us-east-1c"
      cidr_block        = "192.168.192.0/19"
    }
    fourth_private_subnet = {
      availability_zone = "us-east-1d"
      cidr_block        = "192.168.224.0/19"
    }
  }
}

module "sonar" {
  source              = "../../"
  name_prefix         = "sonar"
  region              = "us-east-1"
  vpc_id              = module.base-network.vpc_id
  public_subnets_ids  = module.base-network.public_subnets_ids
  private_subnets_ids = module.base-network.private_subnets_ids
  db_instance_size    = "db.t3.medium"
  enable_ssl          = false
  lb_https_ports      = {}
  lb_http_ports = {
    default = {
      listener_port         = 80
      target_group_port     = 9000
      target_group_protocol = "HTTP"
    }
  }
}
