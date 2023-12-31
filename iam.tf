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

# needed for jenkins access to parameter store
resource "aws_iam_role_policy_attachment" "jenkins-controller-ssm-read" {
  role       = aws_iam_role.jenkins-controller.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess"
}

# for jenkins ec2 plugin
resource "aws_iam_role_policy_attachment" "jenkins-controller-ec2-plugin" {
  role       = aws_iam_role.jenkins-controller.name
  policy_arn = aws_iam_policy.jenkins-create-ec2.arn
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

resource "aws_iam_role_policy_attachment" "jenkins-worker-ecr-token" {
  role       = aws_iam_role.jenkins-worker.name
  policy_arn = aws_iam_policy.get_ecr_token.arn
}

resource "aws_iam_role_policy_attachment" "jenkins-worker-tf-backend" {
  role       = aws_iam_role.jenkins-worker.name
  policy_arn = aws_iam_policy.tf_backend_access.arn
}

resource "aws_iam_role_policy_attachment" "jenkins-worker-create-policy" {
  role       = aws_iam_role.jenkins-worker.name
  policy_arn = aws_iam_policy.create_iam_role.arn
}

resource "aws_iam_role_policy_attachment" "jenkins-worker-kms-read" {
  role       = aws_iam_role.jenkins-worker.name
  policy_arn = aws_iam_policy.kms_read.arn
}

resource "aws_iam_role_policy_attachment" "jenkins-worker-secretsmanager-read-write" {
  role       = aws_iam_role.jenkins-worker.name
  policy_arn = aws_iam_policy.secrets_manager_read_write.arn
}

resource "aws_iam_role_policy_attachment" "jenkins-worker-ec2-full" {
  role       = aws_iam_role.jenkins-worker.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

resource "aws_iam_role_policy_attachment" "jenkins-worker-ssm-read" {
  role       = aws_iam_role.jenkins-worker.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "jenkins-rds-full" {
  role       = aws_iam_role.jenkins-worker.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonRDSFullAccess"
}

resource "aws_iam_role_policy_attachment" "jenkins-worker-vpc-full" {
  role       = aws_iam_role.jenkins-worker.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonVPCFullAccess"
}

# ====== app server ======
resource "aws_iam_instance_profile" "app-server" {
  name = "app-server"
  role = aws_iam_role.app-server.name

  tags = {
    Name = "app-server"
  }
}

resource "aws_iam_role" "app-server" {
  name = "app-server"
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
    Name = "app-server"
  }
}

resource "aws_iam_role_policy_attachment" "app-runner-ecr" {
  role       = aws_iam_role.app-server.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSAppRunnerServicePolicyForECRAccess"
}

resource "aws_iam_role_policy_attachment" "app-server-ecr-token" {
  role       = aws_iam_role.app-server.name
  policy_arn = aws_iam_policy.get_ecr_token.arn
}

resource "aws_iam_role_policy_attachment" "secrets-manager-get-secret" {
  role       = aws_iam_role.app-server.name
  policy_arn = aws_iam_policy.secrets-manager-get-secret.arn
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

resource "aws_iam_policy" "secrets_manager_read_write" {
  name        = "secrets_manager_read_write"
  description = "secrets manager read write"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "secretsmanager:*",
        ],
        "Resource" : "*"
      }
    ]
  })
}

resource "aws_iam_policy" "secrets-manager-get-secret" {
  name        = "secrets-manager-get-secret"
  description = "get secret from secrets manager"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "secretsmanager:GetSecretValue",
          "kms:Decrypt",
        ],
        "Resource" : "*"
      }
    ]
  })
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
        "Resource" : "arn:aws:s3:::${var.tf_backend_s3}/*/*"
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

resource "aws_iam_policy" "get_ecr_token" {
  name        = "get_ecr_token"
  description = "Get auth token for ECR"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "GetECRAuthToken",
        "Effect" : "Allow",
        "Action" : "ecr:GetAuthorizationToken",
        "Resource" : "*"
      },
    ]
  })

  tags = {
    Name = "get_ecr_token"
  }
}

resource "aws_iam_policy" "create_iam_role" {
  name        = "create_iam_role"
  description = "Create IAM role"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "CreateIAMRole",
        "Effect" : "Allow",
        "Action" : [
          "iam:AddRoleToInstanceProfile",
          "iam:AttachRolePolicy",
          "iam:CreatePolicy",
          "iam:CreateRole",
          "iam:CreateInstanceProfile",
          "iam:DeleteRole",
          "iam:DeleteInstanceProfile",
          "iam:DetachRolePolicy",
          "iam:GetInstanceProfile",
          "iam:GetPolicy",
          "iam:GetPolicyVersion",
          "iam:GetRole",
          "iam:ListAttachedRolePolicies",
          "iam:ListInstanceProfilesForRole",
          "iam:ListPolicies",
          "iam:ListRolePolicies",
          "iam:PassRole",
          "iam:RemoveRoleFromInstanceProfile",
          "iam:TagInstanceProfile",
          "iam:TagPolicy",
          "iam:TagRole",
        ],
        "Resource" : "*"
      },
    ]
  })

  tags = {
    Name = "create_iam_role"
  }
}

resource "aws_iam_policy" "kms_read" {
  name        = "kms_read"
  description = "get kms keys"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "kms:Describe*",
          "kms:Get*",
          "kms:List*",
        ],
        "Resource" : "*"
      }
    ]
  })
}

resource "aws_iam_policy" "jenkins-create-ec2" {
  name        = "jenkins-create-ec2"
  description = "permiisions for jenkins ec2 plugin"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "Stmt1312295543082",
        "Action" : [
          "ec2:DescribeSpotInstanceRequests",
          "ec2:CancelSpotInstanceRequests",
          "ec2:GetConsoleOutput",
          "ec2:RequestSpotInstances",
          "ec2:RunInstances",
          "ec2:StartInstances",
          "ec2:StopInstances",
          "ec2:TerminateInstances",
          "ec2:CreateTags",
          "ec2:DeleteTags",
          "ec2:DescribeInstances",
          "ec2:DescribeInstanceTypes",
          "ec2:DescribeKeyPairs",
          "ec2:DescribeRegions",
          "ec2:DescribeImages",
          "ec2:DescribeAvailabilityZones",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeSubnets",
          "iam:ListInstanceProfilesForRole",
          "iam:PassRole",
          "ec2:GetPasswordData"
        ],
        "Effect" : "Allow",
        "Resource" : "*"
      }
    ],
  })
}