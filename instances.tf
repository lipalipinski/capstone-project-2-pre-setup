module "ec2-instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.2.1"

  name          = "jenkins-controller"
  instance_type = "t2.micro"
  subnet_id     = module.vpc.public_subnets[0]

}