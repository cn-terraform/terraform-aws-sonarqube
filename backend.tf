terraform {
  backend "s3" {
    bucket = "movai.terraform"
    key    = "aws-sonarqube.tfstate"
    region = "us-east-1"
  }
}