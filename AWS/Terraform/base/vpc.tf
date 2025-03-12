resource "aws_security_group" "twingate" {
  name        = "${local.name}-twingate"
  description = "Allow PostgreSQL inbound traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "TLS from VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1" #"tcp"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = local.tags
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "sample-vpc"
  cidr = "10.0.0.0/16"

  azs = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
  private_subnets = [
    "10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"
  ]

  intra_subnets  = ["100.64.1.0/24", "100.64.2.0/24", "100.64.3.0/24"]
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

  default_security_group_egress = [
    {

    }
  ]

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}