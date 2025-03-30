variable "network_configuration" {
  type = object({
    vpc_name              = string
    vpc_cidr              = string
    secondary_cidr_blocks = list(string)
    public_subnets        = list(string)
    private_subnets       = list(string)
    intra_subnets         = list(string)
  })

  description = "network configuration"
}



