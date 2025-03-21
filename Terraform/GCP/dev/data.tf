data "google_project" "this" {}
data "google_client_config" "this" {}
data "google_compute_default_service_account" "default_compute_service_account" {}
data "google_compute_zones" "available" {}

# data "twingate_remote_network" "network" {
#   name = "${local.name}-${local.environment}-vpc-network"
# }

# data "twingate_group" "admin" {
#   id = var.twingate_admin_group_id
# }