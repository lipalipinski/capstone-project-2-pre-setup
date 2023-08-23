# ====== jenkins controller ======

resource "aws_iam_instance_profile" "jenkins-controller" {
  name = "jenkins-controller"
  role = aws_iam_role.jenkins-controller.name

  tags = {
    Name = "jenkins-controller"
  }
}

resource "aws_iam_role" "jenkins-controller" {
  name = "jenkins-controller"
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
  permissions_boundary = var.gd-boundry-policy

  tags = {
    Name = "jenkins-controller"
  }
}

resource "aws_iam_role_policy_attachment" "jenkins-ctrl" {
  role       = aws_iam_role.jenkins-controller.name
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
}

resource "aws_iam_role_policy_attachment" "jenkins-secrets-policy-attach" {
  role       = aws_iam_role.jenkins-controller.name
  policy_arn = aws_iam_policy.jenkins_secrets_manager.arn
}

# ====== jenkins worker ======

resource "aws_iam_instance_profile" "jenkins-worker" {
  name = "jenkins-worker"
  role = aws_iam_role.jenkins-worker.name

  tags = {
    Name = "jenkins-worker"
  }
}

resource "aws_iam_role" "jenkins-worker" {
  name = "jenkins-worker"
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
  permissions_boundary = var.gd-boundry-policy

  tags = {
    Name = "jenkins-worker"
  }
}

resource "aws_iam_role_policy_attachment" "jenkins-worker-tf-backend" {
  role       = aws_iam_role.jenkins-worker.name
  policy_arn = aws_iam_policy.tf_backend_access.arn
}

# ====== policies ======

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

resource "aws_iam_policy" "tf_backend_access" {
  name        = "tf_backend_access"
  description = "Policies to use S3 and DynamoDB terraform backend"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : "s3:ListBucket",
        "Resource" : "arn:aws:s3:::${var.tf_backend_s3}"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ],
        "Resource" : "arn:aws:s3:::${var.tf_backend_s3}/${var.tf_app_backend_s3_path}/*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "dynamodb:DescribeTable",
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:DeleteItem"
        ],
        "Resource" : "arn:aws:dynamodb:*:*:table/${var.tf_backend_dynamodb_table}"
      }
    ]
  })
}