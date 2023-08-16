module "jenkins-controller" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.2.1"

  name = "jenkins-controller"

  instance_type          = "t2.micro"
  ami                    = "ami-0261755bbcb8c4a84"
  subnet_id              = module.vpc.public_subnets[0]
  vpc_security_group_ids = [aws_security_group.jenkins-ctrl-sg.id]

  associate_public_ip_address = true

  user_data_replace_on_change = true
  user_data                   = <<EOF
#!/bin/bash

# 
# sed -i "/#\$nrconf{restart} = 'i';/s/.*/\$nrconf{restart} = 'a';/" /etc/needrestart/needrestart.conf
apt-get update -y && apt-get upgrade 
apt-get install -y unzip glibc-source groff less
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install
EOF
}

module "jenkins-worker" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.2.1"

  name = "jenkins-worker"

  instance_type          = "t2.micro"
  ami                    = "ami-0261755bbcb8c4a84"
  subnet_id              = module.vpc.private_subnets[0]
  vpc_security_group_ids = [aws_security_group.jenkins-worker-sg.id]
}