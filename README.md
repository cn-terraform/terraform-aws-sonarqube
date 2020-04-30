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

## Output values

* sonar_lb_id: SonarQube Load Balancer ID
* sonar_lb_arn: SonarQube Load Balancer ARN
* sonar_lb_arn_suffix: SonarQube Load Balancer ARN Suffix
* sonar_lb_dns_name: SonarQube Load Balancer DNS Name
* sonar_lb_zone_id: SonarQube Load Balancer Zone ID
