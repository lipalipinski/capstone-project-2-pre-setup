variable "profile" {
  type    = string
  default = "default"
}

variable "region" {
  type    = string
  default = "eu-central-1"
}

variable "jenkins-home" {
  type    = string
  default = "/home/jenkins"
}

variable "jenkins-worker-pk-name" {
  type    = string
  default = "jenkins-worker-pk"
}
