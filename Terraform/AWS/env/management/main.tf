module "base" {
  source = "../../base"

  network_configuration = {
    vpc_name              = "sample-vpc"
    vpc_cidr              = "10.0.0.0/16"
    secondary_cidr_blocks = ["100.64.0.0/16"]
    public_subnets        = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
    private_subnets       = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
    intra_subnets         = ["100.64.1.0/24", "100.64.2.0/24", "100.64.3.0/24"]
  }
}