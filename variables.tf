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
  default = "terraform-backend-jlpinski-7"
}

variable "dynamodb_name" {
  type    = string
  default = "terraform-lock-jlpinski-7"
}

variable "jenkins-home" {
  type = string
  default = "/home/jenkins"
}

variable "jenkins-worker-pk-name" {
  type    = string
  default = "jenkins-worker-pk"
}
