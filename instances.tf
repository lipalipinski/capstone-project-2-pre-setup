module "jenkins-controller" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.2.1"

  name                 = "jenkins-controller"
  iam_instance_profile = aws_iam_instance_profile.jenkins-controller-profile.name

  instance_type          = "t2.micro"
  ami                    = "ami-053b0d53c279acc90"
  subnet_id              = module.vpc.public_subnets[0]
  vpc_security_group_ids = [aws_security_group.jenkins-ctrl-sg.id]

  associate_public_ip_address = true

  user_data_replace_on_change = true
  user_data                   = <<EOF
#!/bin/bash

# set global env vars
echo 'export JENKINS_HOME="${var.jenkins-home}"' >> /etc/profile.d/vars.sh
echo 'export JENKINS_WORKER_PK_NAME="${var.jenkins-worker-pk-name}"' >> /etc/profile.d/vars.sh
source /etc/profile.d/vars.sh

# add jenkins worker to /etc/hosts
echo "${module.jenkins-worker.private_ip} jenkins-worker" >> /etc/hosts

# bootstrap script
${file("files/jenkins-controller-boot.sh")}
EOF

  depends_on = [module.jenkins-worker-private-key]

  tags = {
    Group = "jenkins_controller"
  }
}

module "jenkins-worker" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.2.1"

  name     = "jenkins-worker"
  key_name = module.jenkins-worker-kp.key_pair_name

  instance_type          = "t2.micro"
  ami                    = "ami-053b0d53c279acc90"
  subnet_id              = module.vpc.private_subnets[0]
  vpc_security_group_ids = [aws_security_group.jenkins-worker-sg.id]
  user_data_replace_on_change = true
  user_data                   = <<EOF
#!/bin/bash
${file("files/jenkins-worker-boot.sh")}
EOF

  tags = {
    Group = "jenkins_worker"
  }
}

module "jenkins-worker-kp" {
  source  = "terraform-aws-modules/key-pair/aws"
  version = "2.0.2"

  key_name   = "jenkins-worker-kp"
  public_key = file("files/ssh/jenkins-worker-kp.pub")
}