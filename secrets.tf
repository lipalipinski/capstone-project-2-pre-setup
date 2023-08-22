module "jenkins-worker-private-key" {
  source  = "terraform-aws-modules/secrets-manager/aws"
  version = "1.1.1"

  name          = var.jenkins-worker-pk-name
  secret_string = file("files/ssh/jenkins-worker-kp")

  # setting to 0 enables instant delete
  recovery_window_in_days = 0

  tags = {
    "jenkins:credentials:type"     = "sshUserPrivateKey"
    "jenkins:credentials:username" = "ubuntu"
  }
}