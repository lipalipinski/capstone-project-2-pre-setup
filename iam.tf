data "aws_caller_identity" "current" {}

resource "aws_iam_instance_profile" "jenkins-controller-profile" {
  name = "jenkins-controller-profile"
  role = aws_iam_role.jenkins-controller-role.name
}

resource "aws_iam_policy_attachment" "jenkins-ctrl" {
  name       = "jenkins-ctrl"
  roles      = [aws_iam_role.jenkins-controller-role.name]
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
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
}