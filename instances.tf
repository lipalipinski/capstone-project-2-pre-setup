module "jenkins-controller" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.2.1"

  name = "jenkins-controller"

  instance_type          = "t2.micro"
  ami                    = "ami-08a52ddb321b32a8c"
  subnet_id              = module.vpc.public_subnets[0]
  vpc_security_group_ids = [aws_security_group.jenkins-ctrl-sg.id]

  associate_public_ip_address = true

  user_data_replace_on_change = true
  user_data                   = <<EOF
#!/bin/bash
yum update -y 
yum remove -y awscli
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install
cat <<EOF1 > /etc/yum.repos.d/adoptium.repo
[Adoptium]
name=Adoptium
baseurl=https://packages.adoptium.net/artifactory/rpm/amazonlinux/2/x86_64                                                        
enabled=1
gpgcheck=1
gpgkey=https://packages.adoptium.net/artifactory/api/gpg/key/public
EOF1
yum install -y temurin-17-jdk
wget -O /etc/yum.repos.d/jenkins.repo \
  https://pkg.jenkins.io/redhat-stable/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
yum upgrade -y
yum install -y jenkins
systemctl daemon-reload
systemctl enable jenkins
systemctl start jenkins
EOF
}

module "jenkins-worker" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.2.1"

  name = "jenkins-worker"

  instance_type          = "t2.micro"
  subnet_id              = module.vpc.private_subnets[0]
  vpc_security_group_ids = [aws_security_group.jenkins-worker-sg.id]
}