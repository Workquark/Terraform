locals {
  ownership  = "joydeep"
  managed_by = "terraform"

  name                             = "jrc-online"
  environment                      = basename(abspath(path.module))
  master_ipv4_cidr_block           = "10.127.0.64/28"
  private_endpoint_subnetwork_cidr = "10.80.21.0/28" # GKE private endpoint subnet
}
