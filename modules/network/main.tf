module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "valheim-vpc"
  cidr = "10.10.10.0/24"

  azs             = [var.availability_zone]
  public_subnets  = ["10.10.10.0/24"]

  enable_ipv6 = true

  public_subnet_tags = {
    Name = "valheim-public"
  }

  vpc_tags = {
    Name = "valheim-vpc"
  }
}