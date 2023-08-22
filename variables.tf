variable "profile" {
  type    = string
  default = "default"
}

variable "region" {
  type    = string
  default = "eu-central-1"
}

variable "tf_bucket_name" {
  type    = string
  default = "tf-backend-jlpinski-1"
}

variable "tf_state_key" {
  type    = string
  default = "tf/gdu-tf-assesment/terraform.tfstate"
}

variable "tf_dynamodb_name" {
  type    = string
  default = "tf-lock-jlpinski-1"
}

variable "jenkins-home" {
  type    = string
  default = "/home/jenkins"
}

variable "jenkins-worker-pk-name" {
  type    = string
  default = "jenkins-worker-pk"
}
