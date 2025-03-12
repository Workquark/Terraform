########################################
##        GOOGLE NETWORK MODULE       ##
########################################

module "vpc" {
  source  = "terraform-google-modules/network/google//modules/vpc"
  version = "~> 9.3"

  project_id   = data.google_project.this.project_id
  network_name = "${var.name}-${var.environment}-vpc-network"

  # shared_vpc_host = true
  routing_mode = var.network_routing_mode

  mtu = 1460
}

################################################
##        GOOGLE NETWORK SUBNETS MODULE       ##
################################################


module "subnets" {
  source  = "terraform-google-modules/network/google//modules/subnets"
  version = "~> 9.3"

  project_id   = data.google_project.this.project_id
  network_name = module.vpc.network_name

  subnets          = var.subnetworks
  secondary_ranges = var.subnetwork_secondary_ranges
}

################################################################
##        GOOGLE CLOUD ROUTER FOR OUTBOUND CONNECTIVITY       ##
################################################################

# Software
# The following dependencies must be available:

# Terraform v1.3 and above
# Terraform Provider for GCP plugin v4.51 and above
module "cloud_router" {
  source  = "terraform-google-modules/cloud-router/google"
  version = "~> 6.2"

  name   = "${module.vpc.network_name}-router"
  region = data.google_client_config.this.region

  nats = [{
    name                               = "${module.vpc.network_name}-nat-gateway"
    source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
    # source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

    # subnetworks = [
    #   {
    #     name                    = module.vpc.this.network.self_link
    #     source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
    #   }
    # ]
  }]

  bgp = {
    asn = 64514
    # advertise_mode = "DEFAULT"
    # keepalive_interval = 20
    advertised_groups = ["ALL_SUBNETS"]
  }

  project = data.google_project.this.project_id
  network = module.vpc.network_name
}

##############################################
##        GOOGLE CLOUD FIREWALL RULES       ##
##############################################


module "firewall_rules" {
  source  = "terraform-google-modules/network/google//modules/firewall-rules"
  version = "9.2.0"

  project_id   = data.google_project.this.project_id
  network_name = module.vpc.network_name

  ingress_rules = [
    {
      name               = "${module.vpc.network_name}-gke-ingress-rule"
      description        = "allow all internal traffic across the vpc"
      direction          = "INGRESS"
      priority           = null
      destination_ranges = var.firewall_destination_ranges
      source_ranges      = var.firewall_source_ranges
      # source_tags             = null
      # source_service_accounts = null
      # target_tags             = null
      # target_service_accounts = null
      allow = [
        {
          protocol = "tcp"
        },
        {
          protocol = "udp"
        },
        {
          protocol = "icmp"
        }
      ]
      deny = []
      log_config = {
        metadata = "INCLUDE_ALL_METADATA"
      }
    }
  ]
}