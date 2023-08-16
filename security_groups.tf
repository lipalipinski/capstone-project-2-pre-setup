module "security-group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.0"

  name        = "jenkins-ctrl-sg"
  description = "SG for Jenkins controller"
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      description = "http 80"
      cidr_blocks = "0.0.0.0/0"

      protocol = 6
      from_port = 80
      to_port   = 80
    },
    {
      description = "https 443"
      cidr_blocks = "0.0.0.0/0"

      protocol = 6
      from_port = 443
      to_port   = 443
    },
    {
      description = "ssh 22"
      cidr_blocks = "0.0.0.0/0"

      protocol = 6
      from_port = 22
      to_port   = 22
    }
  ]
}