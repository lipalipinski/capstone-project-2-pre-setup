terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
  backend "s3" {
    bucket            = var.tf_bucket_name
    key               = var.tf_state_key
    region            = var.region
    dynamodb_endpoint = "dynamodb.us-east-1.amazonaws.com"
    dynamodb_table    = var.tf_dynamodb_name
  }
}

provider "aws" {
  profile = var.profile
  region  = var.region

  default_tags {
    tags = {
      Name    = "jlipinski-petclinic"
      Owner   = "jlipinski"
      Project = "2023_internship_waw"
    }
  }
}
