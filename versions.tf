terraform {
  required_version = ">= 0.13"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.74.2"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.1.0"
    }
  }
}
