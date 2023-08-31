module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  name   = "petclinic-jlipinski"
  cidr   = "10.1.0.0/16"

  azs              = data.aws_availability_zones.azs.names
  database_subnets = ["10.1.30.0/24", "10.1.31.0/24"]
  public_subnets   = ["10.1.10.0/24", "10.1.11.0/24"]
  private_subnets  = ["10.1.20.0/24"]

  enable_nat_gateway = true

  private_subnet_suffix = "private"
  private_subnet_tags = {
    Tier = "private"
  }

  public_subnet_suffix = "public"
  public_subnet_tags = {
    Tier = "public"
  }

  tags = {
    # Name = "jlipinski-petclinic"
  }
}

# get all AZ's in region
data "aws_availability_zones" "azs" {
  provider = aws

  # only AZ no wavelength etc
  filter {
    name   = "zone-type"
    values = ["availability-zone"]
  }
}