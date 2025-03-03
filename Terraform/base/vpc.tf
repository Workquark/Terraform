module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "sample-vpc"
  cidr = "10.0.0.0/16"

  azs = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
  private_subnets = [
    "10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24",
    "100.64.1.0/24", "100.64.2.0/24", "100.64.3.0/24"
  ]
  public_subnets = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  secondary_cidr_blocks = ["100.64.0.0/16"]

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = "1"
    "subnet-type"                     = "private"
  }

  public_subnet_tags = {
    "kubernetes.io/role/elb" = "1"
    "subnet-type"            = "public"
  }

  enable_nat_gateway = true
  enable_vpn_gateway = false
  single_nat_gateway = true

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}