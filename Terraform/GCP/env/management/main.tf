############################################
##                BASE                    ##
############################################

module "base" {
  source = "../../base"

  project_id = data.google_project.this.project_id

  environment = local.environment
  name        = local.name
  region      = "europe-west1"

  #################################
  #     CONDITIONAL VARIABLES     #
  #################################

  create_dns = true ## requires also var.cloud_domains to be set if true

  #####################
  # NETWORK VARIABLES #
  #####################
  network_routing_mode = "REGIONAL"

  # private_service_access_address = "10.5.10.0" # First address of private service access

  subnetworks = var.subnetworks

  subnetwork_secondary_ranges = var.subnetwork_secondary_ranges

  firewall_destination_ranges = ["10.80.0.0/16"]
  firewall_source_ranges      = ["10.81.0.0/16"]

  #####################
  # ARTIFACT REGISTRY #
  #####################
  artifact_registries = [

  ]

  #######################
  # CLOUD DNS VARIABLES #
  #######################

  cloud_domains = {
    "druidsoft.in." = []
  }

  #####################
  # WORKLOAD IDENTITY #
  #####################
  github_action_service_account_name = "github"
  git_repos = [
    # "<github-org>/<github-repo>",
  ]

  github_action_service_account_roles = [
    # "roles/resourcemanager.projectIamAdmin",
    # "roles/compute.admin",
    # "roles/cloudkms.admin",
    # "roles/storage.objectUser",
    # "roles/storage.admin",
    # "roles/artifactregistry.admin",
    # "roles/secretmanager.admin",
    # "roles/dns.admin",
    # "roles/container.clusterAdmin",
    # "roles/iam.workloadIdentityPoolAdmin",
    # "roles/iam.serviceAccountAdmin",
    # "roles/iam.roleViewer",
    # "roles/iam.serviceAccountUser",
    # "roles/iam.serviceAccountTokenCreator",
    # "roles/dns.admin"
  ]

  external_dns_service_account_roles = [
    "roles/"
  ]

  ###################################################
  ### ARGOCD GITHUB APP OAUTH SECRETS AND CREDS  ####
  ###################################################
  github_app_oauth_clientid      = var.github_app_oauth_clientid
  github_app_oauth_client_secret = var.github_app_oauth_client_secret
  github_app_installation_id     = var.github_app_installation_id
  github_app_id                  = var.github_app_id
  github_app_oauth_private_key   = var.github_app_oauth_private_key

  #########################
  # GOOGLE CLOUD STORAGE  #
  #########################

  bucket_names = ["velero-backup"]
  # # cloud_storage_admins = ["group:team@<domain>"]
  # cloud_storage_admins = ["user:<user>@<domain>"]

  # bucket_admins = {
  #   velero-backup = "<user>@<domain>"
  # }
}

############################################
##                TWINGATE                ##
############################################

module "twingate" {
  source = "../../modules/twingate"

  name                  = local.name
  twingate_network_name = "workquark0403"

  remote_network_name = "${local.name}-${local.environment}-vpc-network"
  environment         = local.environment

  zone_names = data.google_compute_zones.available.names
  project_id = data.google_project.this.project_id

  ################
  #   TWINGATE   #
  ################

  twingate_instances_count  = 2
  twingate_api_token        = var.twingate_api_token
  twingate_access_group_ids = [var.twingate_admin_group_id]
  twingate_image_version    = "1.73.0"
  twingate_subnet_name      = "ops-${local.environment}-subnet-1"
  twingate_machine_type     = "e2-micro"
  # twingate_allowed_firewall_ports = ["80"]

  master_ipv4_cidr_block           = local.master_ipv4_cidr_block
  private_endpoint_subnetwork_cidr = local.private_endpoint_subnetwork_cidr

  depends_on = [
    module.base
  ]
}

#########################################
##             GKE                     ##
#########################################

module "gke_dev" {
  source       = "../../modules/gke"
  cluster_name = "${local.name}-${local.environment}-gke-cluster"

  project_id = data.google_project.this.project_id
  region     = data.google_client_config.this.region

  domain = "druidsoft.in"

  # zones = ["europe-west1-b", "europe-west1-c"]

  kubernetes_version = "1.32.2"
  release_channel    = "REGULAR"

  name                     = local.name
  environment              = local.environment
  gke_service_account_name = "${local.name}-${local.environment}-gke"

  gke_private_endpoint_subnetwork          = "gke-${local.environment}-private-endpoint-subnet-1"
  gke_cluster_subnetwork                   = "gke-${local.environment}-cluster-subnet-1"
  gke_cluster_ip_range_pods_subnetwork     = "gke-${local.environment}-cluster-pod-subnet-1"
  gke_cluster_ip_range_services_subnetwork = "gke-${local.environment}-cluster-service-subnet-1"

  network_name = "${local.name}-${local.environment}-vpc-network"

  master_ipv4_cidr_block = "10.127.0.16/28"
  master_authorized_networks = [
    {
      display_name : "twingate_network",
      cidr_block : "10.80.21.240/28" # ops subnet
    },
    {
      cidr_block   = "10.80.0.0/16"
      display_name = "${local.name}_network"
    },
    {
      cidr_block   = "10.81.0.0/16"
      display_name = "argocd"
    }
  ]

  node_pools = [
    {
      name         = "${local.environment}-node-pool"
      machine_type = "e2-standard-2"

      min_count          = 1
      max_count          = 100
      initial_node_count = 1

      local_ssd_count = 0

      spot         = true
      disk_size_gb = 100
      disk_type    = "pd-standard"
      image_type   = "UBUNTU_CONTAINERD" # "COS_CONTAINERD"
      enable_gcfs  = false
      enable_gvnic = false
      auto_repair  = true
      auto_upgrade = true
      # service_account    = "project-service-account@<PROJECT ID>.iam.gserviceaccount.com"
      preemptible = false

      # node_config = {
      #   dynamic "workload_metadata_config" {
      #     node_metadata = "GKE_METADATA_SERVER"
      #   }
      # }
    }
  ]

  gke_node_pool_default_labels = {
    "environment" : local.environment
    "project" : local.name
    "ownership" : local.ownership
    "managed_by" : local.managed_by
    "disk_type" : "ubuntu_containerd"
  }

  depends_on = [
    module.base
  ]
}

############################################
##                GKE IAM                 ##
############################################

# module "iam" {
#   source         = "./iam"
#   project_id     = data.google_project.this.project_id
#   project_number = data.google_project.this.number

#   # dns_admin_service_account_emails       = module.base.dns_admin_service_account_emails
#   # secrets_manager_service_account_emails = module.base.secrets_manager_service_account_emails
#   # depends_on                             = [module.gke_sandbox]
# }



####################################################################
##                GCP NETWORK CONNECTIVITY CENTER                 ##
####################################################################

# module "network_connectivity_center" {
#   source  = "terraform-google-modules/network/google//modules/network-connectivity-center"
#   version = "10.0.0"

#   project_id          = "${local.name}-management"
#   export_psc          = true
#   ncc_hub_description = "${local.name} management network connectivity center for all spoke projects and vpcs"
#   ncc_hub_name        = "central-management-hub"

#   vpc_spokes = {
#     "${module.base.network_name}" = {
#       uri                   = module.base.network_self_link
#       include_export_ranges = ["10.30.21.0/24"]
#     }
#   }
# }

# resource "google_network_connectivity_spoke" "primary" {
#   name        = "${local.name}-dev"
#   location    = "global"
#   description = "${local.name} dev spoke"
#   labels = {
#     label-one = "${local.name}-dev"
#   }

#   hub = google_network_connectivity_hub.basic_hub.id
#   linked_vpc_network {
#     include_export_ranges = [
#       "10.30.21.0/24"
#     ]
#     uri = module.base.network_self_link
#   }
# }