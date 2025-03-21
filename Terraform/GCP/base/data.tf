data "google_project" "this" {}
data "google_client_config" "this" {}
data "google_compute_default_service_account" "default_compute_service_account" {}
data "google_compute_zones" "available" {}

# data "twingate_remote_network" "network" {
#   name = module.vpc.network_name
# }

# data "google_compute_subnetwork" "ops_subnet" {
#   name   = var.twingate_subnet_name
#   region = data.google_client_config.this.region
# }