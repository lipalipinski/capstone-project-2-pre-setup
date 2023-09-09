variable "profile" {
  type    = string
  default = "default"
}

variable "region" {
  type    = string
  default = "eu-central-1"
}

variable "tf_backend_s3" {
  # !!! var can't be used in backend configuration, remember to change manually
  type    = string
  default = "tf-backend-jlipinski-1"
}

variable "tf_backend_s3_path" {
  # !!! var can't be used in backend configuration, remember to change manually
  type    = string
  default = "tf/gdu-tf-assesment/terraform.tfstate"
}

variable "tf_app_backend_s3_path" {
  # !!! var can't be used in backend configuration, remember to change manually
  type    = string
  default = "tf/petclinic-app"
}

variable "tf_backend_dynamodb_table" {
  # !!! var can't be used in backend configuration, remember to change manually
  type    = string
  default = "tf-lock-jlipinski-1"
}

variable "gd-boundry-policy" {
  # set to meet GD AWS policy
  type    = string
  default = "arn:aws:iam::113304117666:policy/DefaultBoundaryPolicy"
}

variable "jenkins-home" {
  # dir for jenkins instalation
  type    = string
  default = "/home/jenkins"
}

variable "jenkins-worker-pk-name" {
  type    = string
  default = "jenkins-worker-pk"
}
