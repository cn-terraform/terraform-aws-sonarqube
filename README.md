# SonarQube Terraform Module for AWS #

This Terraform module deploys a SonarQube community server on AWS. Based on official Sonarqube Docker image <https://hub.docker.com/_/sonarqube>.

[![CircleCI](https://circleci.com/gh/cn-terraform/terraform-aws-sonarqube.svg?style=svg)](https://circleci.com/gh/cn-terraform/terraform-aws-sonarqube)
[![](https://img.shields.io/github/license/cn-terraform/terraform-aws-sonarqube)](https://github.com/cn-terraform/terraform-aws-sonarqube)
[![](https://img.shields.io/github/issues/cn-terraform/terraform-aws-sonarqube)](https://github.com/cn-terraform/terraform-aws-sonarqube)
[![](https://img.shields.io/github/issues-closed/cn-terraform/terraform-aws-sonarqube)](https://github.com/cn-terraform/terraform-aws-sonarqube)
[![](https://img.shields.io/github/languages/code-size/cn-terraform/terraform-aws-sonarqube)](https://github.com/cn-terraform/terraform-aws-sonarqube)
[![](https://img.shields.io/github/repo-size/cn-terraform/terraform-aws-sonarqube)](https://github.com/cn-terraform/terraform-aws-sonarqube)

## Usage

Check valid versions on:
* Github Releases: <https://github.com/cn-terraform/terraform-aws-sonarqube/releases>
* Terraform Module Registry: <https://registry.terraform.io/modules/cn-terraform/sonarqube/aws>

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12 |

## Providers

| Name | Version |
|------|---------|
| aws | n/a |
| random | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| availability\_zones | List of Availability Zones | `list(string)` | n/a | yes |
| db\_instance\_size | DB instance size | `string` | `"db.r4.large"` | no |
| db\_name | Default DB name | `string` | `"sonar"` | no |
| db\_password | DB password | `string` | `""` | no |
| db\_username | Default DB username | `string` | `"sonar"` | no |
| name\_prefix | Name prefix for resources on AWS | `string` | n/a | yes |
| private\_subnets\_ids | List of Private Subnets IDs | `list(string)` | n/a | yes |
| public\_subnets\_ids | List of Public Subnets IDs | `list(string)` | n/a | yes |
| region | AWS Region the infrastructure is hosted in | `string` | n/a | yes |
| vpc\_id | ID of the VPC | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| sonar\_lb\_arn | SonarQube Load Balancer ARN |
| sonar\_lb\_arn\_suffix | SonarQube Load Balancer ARN Suffix |
| sonar\_lb\_dns\_name | SonarQube Load Balancer DNS Name |
| sonar\_lb\_id | SonarQube Load Balancer ID |
| sonar\_lb\_zone\_id | SonarQube Load Balancer Zone ID |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
