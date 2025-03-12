##########################################
##              GKE MODULE              ##
##########################################

module "gke" {

  source = "terraform-google-modules/kubernetes-engine/google//modules/beta-private-cluster"

  version            = "35.0.1"
  kubernetes_version = var.kubernetes_version #"1.29.6"

  name = var.cluster_name

  deletion_protection = false

  gateway_api_channel = "CHANNEL_STANDARD"
  release_channel     = var.release_channel # "REGULAR"

  # Required variables
  project_id = var.project_id
  region     = var.region

  zones = var.zones


  # fleet_project_grant_service_agent = true
  # fleet_project                     = var.project_id

  authenticator_security_group = var.authenticator_security_group == "" ? "gke-security-groups@aviatize.com" : var.authenticator_security_group
  # authenticator_security_group = "gke-security-groups@aviatize.com"

  network                     = var.network_name
  private_endpoint_subnetwork = var.gke_private_endpoint_subnetwork
  subnetwork                  = var.gke_cluster_subnetwork                   # "gke-cluster-subnet-1"
  ip_range_pods               = var.gke_cluster_ip_range_pods_subnetwork     #"gke-cluster-pod-subnet-1"
  ip_range_services           = var.gke_cluster_ip_range_services_subnetwork # "gke-cluster-service-subnet-1"

  service_account_name = var.gke_service_account_name

  enable_l4_ilb_subsetting = true

  # Other variables
  http_load_balancing        = true
  network_policy             = true
  horizontal_pod_autoscaling = true
  gce_pd_csi_driver          = true

  filestore_csi_driver = true

  stack_type = "IPV4"

  enable_private_endpoint  = true
  enable_private_nodes     = true
  remove_default_node_pool = true

  enable_cost_allocation          = true
  enable_shielded_nodes           = true
  enable_vertical_pod_autoscaling = true

  grant_registry_access = true
  registry_project_ids  = [var.project_id]

  master_global_access_enabled = true
  enable_intranode_visibility  = true
  gke_backup_agent_config      = true

  master_ipv4_cidr_block = var.master_ipv4_cidr_block

  master_authorized_networks = var.master_authorized_networks

  network_tags = ["aviatize-${var.environment}"]

  # cluster_resource_labels = local.default_labels
  node_metadata = "GKE_METADATA_SERVER"

  node_pools = var.node_pools

  node_pools_oauth_scopes = {
    all = [
      "https://www.googleapis.com/auth/cloud-platform"
      # "https://www.googleapis.com/auth/logging.write",
      # "https://www.googleapis.com/auth/monitoring",
    ]
  }

  node_pools_labels = {
    all = {}

    default-pool = var.gke_node_pool_default_labels
    # longhorn     = merge(local.default_labels, local.longhorn_labels)
  }

  # node_pools_metadata = {
  #   all = {}

  #   default-node-pool = {
  #     node-pool-metadata-custom-value = "my-node-pool"
  #   }
  # }

  # node_pools_taints = {
  #   all = []

  #   # default-pool = [
  #   #   {
  #   #     key    = "workload"
  #   #     value  = true
  #   #     effect = "PREFER_NO_SCHEDULE"
  #   #   },
  #   # ]

  #   longhorn = [
  #     {
  #       key   = "longhorn"
  #       value = true
  #       # effect = "PREFER_NO_SCHEDULE"
  #       effect = "NO_SCHEDULE"
  #     },
  #   ]
  # }

  node_pools_tags = {
    all = []

    default-node-pool = [
      "default-node-pool",
    ]
  }

  # depends_on = [
  #   google_project_iam_binding.container_host_service_agent_user
  # ]
}


###############################################################################
##        IAM POLICY BINDING TO SERVICE ACCOUNTS AND WORKLOAD IDENTITY       ##
###############################################################################

module "projects_iam_bindings" {
  source  = "terraform-google-modules/iam/google//modules/projects_iam"
  version = "~> 8.0"

  projects = [var.project_id]

  bindings = {
    # "roles/artifactregistry.admin"         = var.iam_member_emails
    # "roles/iam.serviceAccountTokenCreator" = var.iam_member_emails
    # "roles/iam.serviceAccountUser"         = var.iam_member_emails
    # "roles/run.admin"                      = var.iam_member_emails

    # The below one is used not this .

    "roles/iam.workloadIdentityUser" = [
      # "serviceAccount:github@${var.project_id}.iam.gserviceaccount.com",
      "serviceAccount:${var.project_id}.svc.id.goog[external-dns-public/external-dns-public]",
      "serviceAccount:${var.project_id}.svc.id.goog[external-dns-private/external-dns-private]",
      "serviceAccount:${var.project_id}.svc.id.goog[external-secrets/external-secrets]",
      "serviceAccount:${var.project_id}.svc.id.goog[cert-manager/cert-manager]",
      "serviceAccount:${var.project_id}.svc.id.goog[velero-system/velero-server]",
      "serviceAccount:${var.project_id}.svc.id.goog[argocd/argocd-server]",
      "serviceAccount:${var.project_id}.svc.id.goog[argocd/argocd-application-controller]"
    ]

    # "roles/storage.objectAdmin"             = var.iam_member_emails
    # "roles/compute.networkAdmin"            = var.iam_member_emails
    # "roles/container.clusterAdmin"          = var.iam_member_emails
    # "roles/logging.logWriter"               = var.iam_member_emails
    # "roles/resourcemanager.projectIamAdmin" = var.iam_member_emails
    # "roles/compute.admin"                   = var.iam_member_emails
    # "roles/dns.admin"                       = var.iam_member_emails
    # "roles/iam.roleViewer"                  = var.iam_member_emails
    # "roles/storage.admin"                   = var.iam_member_emails
    # "roles/cloudsql.admin"                  = var.iam_member_emails
  }

  depends_on = [module.gke]
}
