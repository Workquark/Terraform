locals {
  ownership  = "joydeep"
  managed_by = "terraform"
  # fleet_project                    = "aviatize-management"
  name                             = "jrc-online"
  environment                      = basename(abspath(path.module))
  master_ipv4_cidr_block           = "10.127.0.64/28"
  private_endpoint_subnetwork_cidr = "10.30.21.0/28" # GKE private endpoint subnet
  # hub_labels = {
  #   hub-project = "aviatize-management"
  # }
}
