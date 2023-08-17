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
  user_data                   = file("files/jenkins-controller-boot.sh")
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
}

module "jenkins-worker-kp" {
  source  = "terraform-aws-modules/key-pair/aws"
  version = "2.0.2"

  key_name   = "jenkins-worker-kp"
  public_key = file("files/ssh/jenkins-worker-kp.pub")
}