variable "profile" {
  type    = string
  default = "default"
}

variable "region" {
  type    = string
  default = "eu-central-1"
}

variable "gd-boundry-policy" {
  # set to meet GD AWS policy
  type = string
  default = "arn:aws:iam::113304117666:policy/DefaultBoundaryPolicy"
}

variable "jenkins-ami" {
  type    = string
  default = "ami-04e601abe3e1a910f"
}

variable "jenkins-home" {
  type    = string
  default = "/home/jenkins"
}

variable "jenkins-worker-pk-name" {
  type    = string
  default = "jenkins-worker-pk"
}
