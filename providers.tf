terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  profile = var.profile
  region  = var.region

  default_tags {
    tags = {
      Name    = "default"
      Owner   = "jlipinski"
      Project = "2023_internship_waw"
    }
  }
}
