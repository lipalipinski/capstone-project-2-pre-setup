module "secrets-manager" {
  source  = "terraform-aws-modules/secrets-manager/aws"
  version = "1.1.1"

  name          = "jenkins-worker-private-key"
  secret_string = file("files/ssh/jenkins-worker-kp")
}