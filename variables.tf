variable "profile" {
  type    = string
  default = "default"
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "bucket_name" {
  type    = string
  default = "terraform-backend-jlpinski-3"
}

variable "dynamodb_name" {
  type    = string
  default = "terraform-lock-jlpinski-3"
}
