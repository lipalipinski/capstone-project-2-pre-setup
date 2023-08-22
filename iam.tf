data "aws_caller_identity" "current" {}

resource "aws_iam_instance_profile" "jenkins-controller-profile" {
  name = "jenkins-controller-profile"
  role = aws_iam_role.jenkins-controller-role.name

  tags = {
    Name = "jenkins-controller-profile"
  }
}

resource "aws_iam_role" "jenkins-controller-role" {
  name = "jenkins-controller-role"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "ec2.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })

  # set to meet GD policy
  permissions_boundary = "arn:aws:iam::113304117666:policy/DefaultBoundaryPolicy"

  tags = {
    Name = "jenkins-controller-role"
  }
}

resource "aws_iam_policy_attachment" "jenkins-ctrl" {
  name       = "jenkins-ctrl"
  roles      = [aws_iam_role.jenkins-controller-role.name]
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
}

resource "aws_iam_policy_attachment" "jenkins-secrets-policy-attach" {
  name       = "jenkins-ctrl"
  roles      = [aws_iam_role.jenkins-controller-role.name]
  policy_arn = aws_iam_policy.jenkins_secrets_manager.arn
}

resource "aws_iam_policy" "jenkins_secrets_manager" {
  name        = "jenkins_secrets_manager"
  description = "Policies needed for Jenkins AWS Secrets Manager Credentials Provider plugin"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "AllowJenkinsToGetSecretValues",
        "Effect" : "Allow",
        "Action" : "secretsmanager:GetSecretValue",
        "Resource" : "*"
      },
      {
        "Sid" : "AllowJenkinsToListSecrets",
        "Effect" : "Allow",
        "Action" : "secretsmanager:ListSecrets"
        "Resource" : "*"
      }
    ]
  })

  tags = {
    Name = "jenkins_secrets_manager"
  }
}