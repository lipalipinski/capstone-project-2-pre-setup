module "jenkins-worker-private-key" {
  source  = "terraform-aws-modules/secrets-manager/aws"
  version = "1.1.1"

  name          = var.jenkins-worker-pk-name
  secret_string = file("files/ssh/jenkins-worker-kp")

  # setting to 0 enables instant delete
  recovery_window_in_days = 0

  tags = {
    Name                           = "jenkins-worker-private-key"
    "jenkins:credentials:type"     = "sshUserPrivateKey"
    "jenkins:credentials:username" = "ubuntu"
  }
}

module "app-server-private-key" {
  source  = "terraform-aws-modules/secrets-manager/aws"
  version = "1.1.1"

  name          = "app-server-pk"
  secret_string = file("files/ssh/app-server-kp")

  # setting to 0 enables instant delete
  recovery_window_in_days = 0

  tags = {
    Name                           = "app-server-private-key"
    "jenkins:credentials:type"     = "sshUserPrivateKey"
    "jenkins:credentials:username" = "ubuntu"
  }
}