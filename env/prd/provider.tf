terraform {
  required_version = ">=1.11.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.100"
    }
  }
}

# Provider
provider "aws" {
  profile = "default"
  region  = local.region
  default_tags {
    tags = {
      project = local.project
    }
  }
}
