module "jenkins-controller" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.2.1"

  name                 = "jenkins-controller"
  iam_instance_profile = aws_iam_instance_profile.jenkins-controller.name

  instance_type = "t3.medium"
  ami           = reverse(data.aws_ami_ids.jenkins-controller.ids)[0]
  monitoring    = true

  subnet_id              = module.vpc.public_subnets[0]
  vpc_security_group_ids = [aws_security_group.jenkins-ctrl-sg.id]

  root_block_device = [
    {
      encrypted   = true
      volume_type = "gp3"
      volume_size = 25
    },
  ]

  user_data_replace_on_change = true
  user_data                   = <<EOF
#!/bin/bash

# set global env vars
echo 'export JENKINS_HOME="${var.jenkins-home}"' >> /etc/profile.d/vars.sh
echo 'export JENKINS_WORKER_PK_NAME="${var.jenkins-worker-pk-name}"' >> /etc/profile.d/vars.sh
source /etc/profile.d/vars.sh

# add jenkins worker to /etc/hosts
echo "${module.jenkins-worker[0].private_ip} jenkins-worker-1" >> /etc/hosts
echo "${module.jenkins-worker[1].private_ip} jenkins-worker-2" >> /etc/hosts

# bootstrap script
${file("files/jenkins-controller-boot.sh")}
EOF

  depends_on = [module.jenkins-worker-private-key]

  tags = {
    Name  = "jenkins_controller"
    Group = "jenkins_controller"
  }
}

resource "aws_eip" "jenkins-controller" {
  instance = module.jenkins-controller.id
  domain   = "vpc"

  tags = {
    Name = "jenkins-controller-eip"
  }
}

module "jenkins-worker" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.2.1"

  count = 2
  name                 = "jenkins-worker-${count.index + 1}"
  iam_instance_profile = aws_iam_instance_profile.jenkins-worker.name
  key_name             = module.jenkins-worker-kp.key_pair_name

  instance_type = "t3.medium"
  ami           = reverse(data.aws_ami_ids.jenkins-worker.ids)[0]
  monitoring    = true

  subnet_id              = module.vpc.private_subnets[0]
  vpc_security_group_ids = [aws_security_group.jenkins-worker-sg.id]

  root_block_device = [
    {
      encrypted   = true
      volume_type = "gp3"
      volume_size = 25
    },
  ]

  user_data_replace_on_change = true
  user_data                   = <<EOF
#!/bin/bash

# bootstrap script
${file("files/jenkins-worker-boot.sh")}
EOF

  tags = {
    Name  = "jenkins-worker-${count.index + 1}"
    Group = "jenkins_worker"
  }
}

module "jenkins-worker-kp" {
  source  = "terraform-aws-modules/key-pair/aws"
  version = "2.0.2"

  key_name   = "jenkins-worker-kp"
  public_key = file("files/secrets/jenkins-worker-kp.pub")

  tags = {
    Name = "jenkins-worker-kp"
  }
}

module "app-server-kp" {
  source  = "terraform-aws-modules/key-pair/aws"
  version = "2.0.2"

  key_name   = "app-server-kp"
  public_key = file("files/secrets/app-server-kp.pub")

  tags = {
    Name = "app-server-kp"
  }
}