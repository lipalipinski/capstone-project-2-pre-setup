/*
remember to prepare keys maually in files/secrets
secrets tagged with jenkins:credentials:type will be retrieved by 
Jenkins Secrets Manager Credentials Proovider Plugin
https://plugins.jenkins.io/aws-secrets-manager-credentials-provider/
*/

module "jenkins-worker-private-key" {
  source  = "terraform-aws-modules/secrets-manager/aws"
  version = "1.1.1"

  name          = var.jenkins-worker-pk-name
  secret_string = file("files/secrets/jenkins-worker-kp")

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
  secret_string = file("files/secrets/app-server-kp")

  # setting to 0 enables instant delete
  recovery_window_in_days = 0

  tags = {
    Name                           = "app-server-private-key"
    "jenkins:credentials:type"     = "sshUserPrivateKey"
    "jenkins:credentials:username" = "ubuntu"
  }
}

# github token for repo access and webhooks
module "jenkins-petclinic-token-user" {
  source  = "terraform-aws-modules/secrets-manager/aws"
  version = "1.1.1"

  name          = "jenkins-petclinic-token-user"
  secret_string = file("files/secrets/gh-token")

  # setting to 0 enables instant delete
  recovery_window_in_days = 0

  tags = {
    Name                           = "jenkins-petclinic-token-user"
    "jenkins:credentials:type"     = "usernamePassword"
    # user to bind in Jenkins Credentials
    "jenkins:credentials:username" = "lipalipinski"
  }
}

module "jenkins-petclinic-token" {
  # for Jenkins GitHub plugin
  # to be set in jenkins-casc.yaml
  source  = "terraform-aws-modules/secrets-manager/aws"
  version = "1.1.1"

  name          = "jenkins-petclinic-token"
  secret_string = file("files/secrets/gh-token")

  # setting to 0 enables instant delete
  recovery_window_in_days = 0

  tags = {
    Name                       = "jenkins-petclinic-token"
    "jenkins:credentials:type" = "string"
  }
}