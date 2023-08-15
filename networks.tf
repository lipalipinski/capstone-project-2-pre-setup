module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  name   = "petclinic-jlipinski"
  cidr   = "10.1.0.0/16"

  azs             = data.aws_availability_zones.azs.names
  public_subnets  = ["10.1.10.0/24"]
  private_subnets = ["10.1.20.0/24"]

  enable_nat_gateway = true
}

# get all AZ's in region
data "aws_availability_zones" "azs" {
  provider = aws
  filter {
    name   = "zone-type"
    values = ["availability-zone"]
  }
}