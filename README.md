# SonarQube Terraform Module for AWS #

This Terraform module deploys a SonarQube community server on AWS. Based on official Sonarqube Docker image <https://hub.docker.com/_/sonarqube>.

[![CircleCI](https://circleci.com/gh/cn-terraform/terraform-aws-sonarqube/tree/master.svg?style=svg)](https://circleci.com/gh/cn-terraform/terraform-aws-sonarqube/tree/master)
[![](https://img.shields.io/github/license/cn-terraform/terraform-aws-sonarqube)](https://github.com/cn-terraform/terraform-aws-sonarqube)
[![](https://img.shields.io/github/issues/cn-terraform/terraform-aws-sonarqube)](https://github.com/cn-terraform/terraform-aws-sonarqube)
[![](https://img.shields.io/github/issues-closed/cn-terraform/terraform-aws-sonarqube)](https://github.com/cn-terraform/terraform-aws-sonarqube)
[![](https://img.shields.io/github/languages/code-size/cn-terraform/terraform-aws-sonarqube)](https://github.com/cn-terraform/terraform-aws-sonarqube)
[![](https://img.shields.io/github/repo-size/cn-terraform/terraform-aws-sonarqube)](https://github.com/cn-terraform/terraform-aws-sonarqube)

## Usage

Check valid versions on:
* Github Releases: <https://github.com/cn-terraform/terraform-aws-sonarqube/releases>
* Terraform Module Registry: <https://registry.terraform.io/modules/cn-terraform/sonarqube/aws>

        module "sonarqube" {
            source              = "cn-terraform/sonarqube/aws"
            version             = "2.0.5"
            name_preffix        = var.name_preffix
            profile             = var.profile
            region              = var.region
            vpc_id              = module.networking.vpc_id
            availability_zones  = module.networking.availability_zones
            public_subnets_ids  = module.networking.public_subnets_ids
            private_subnets_ids = module.networking.private_subnets_ids
        }

The networking module should look like this:

        module "networking" {
    	    source          = "cn-terraform/networking/aws"
            version         = "2.0.4"
            name_preffix    = "base"
            profile         = "aws_profile"
            region          = "us-east-1"
            vpc_cidr_block  = "192.168.0.0/16"
            availability_zones                          = [ "us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d" ]
            public_subnets_cidrs_per_availability_zone  = [ "192.168.0.0/19", "192.168.32.0/19", "192.168.64.0/19", "192.168.96.0/19" ]
            private_subnets_cidrs_per_availability_zone = [ "192.168.128.0/19", "192.168.160.0/19", "192.168.192.0/19", "192.168.224.0/19" ]
    	}

Check versions for this module on:
* Github Releases: <https://github.com/cn-terraform/terraform-aws-networking/releases>
* Terraform Module Registry: <https://registry.terraform.io/modules/cn-terraform/networking/aws>

## Output values

* sonar_lb_id: SonarQube Load Balancer ID
* sonar_lb_arn: SonarQube Load Balancer ARN
* sonar_lb_arn_suffix: SonarQube Load Balancer ARN Suffix
* sonar_lb_dns_name: SonarQube Load Balancer DNS Name
* sonar_lb_zone_id: SonarQube Load Balancer Zone ID
