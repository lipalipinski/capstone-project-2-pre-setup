data "aws_caller_identity" "current" {}

data "aws_ami_ids" "jenkins-controller" {
  owners = [data.aws_caller_identity.current.account_id]

  sort_ascending = true

  filter {
    name   = "name"
    values = ["jenkins-controller-jlipinski-*"]
  }
}

data "aws_ami_ids" "jenkins-worker" {
  owners = [data.aws_caller_identity.current.account_id]

  sort_ascending = true

  filter {
    name   = "name"
    values = ["jenkins-worker-jlipinski-*"]
  }
}