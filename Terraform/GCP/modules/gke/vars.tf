
##################
## GKE VARIABLES #
##################

variable "domain" {
  type        = string
  description = "domain name"
}


variable "project_id" {
  type        = string
  description = "description"
  default     = "type"
}

variable "cluster_name" {
  type        = string
  description = "gke cluster name"
}

variable "authenticator_security_group" {
  type        = string
  description = "Authenticator security group"
  default     = ""
}

variable "network_configuration" {
  type = object({
    network_name                 = string
    subnetwork                   = string
    private_endpoint_subnetwork  = string
    ip_range_pods_subnetwork     = list(string)
    ip_range_services_subnetwork = list(string)
    master_ipv4_cidr_block       = string
    master_authorized_networks   = list(map(string))
  })

  description = "description"
}

variable "node_pools" {
  type        = list(map(any))
  description = "List of maps containing node pools"

  default = [
    {
      name = "default-node-pool"
    },
  ]
}

variable "zones" {
  type        = list(string)
  description = "list of zones for the cluster"
  default     = []
}


# variable "fleet_project" {
#   type        = string
#   description = "description"
# }

variable "name" {
  type        = string
  description = "description"
}

variable "environment" {
  type        = string
  description = "description"
}

variable "region" {
  type        = string
  description = "description"
}

variable "kubernetes_version" {
  type        = string
  description = "kubernetes version"
}

variable "release_channel" {
  type        = string
  description = "kubernetes release channel"
}


# variable "network_name" {
#   type        = string
#   description = "description"
# }

# variable "master_ipv4_cidr_block" {
#   type        = string
#   description = "gke master ipv4 cidr block"
#   default     = "type"
# }

variable "gke_node_pool_default_labels" {
  type        = map(string)
  description = "gke default labels"
}

# variable "master_authorized_networks" {
#   type        = list(map(string))
#   description = "gke master authorized networks"
# }

variable "gke_service_account_name" {
  type        = string
  description = "gke service account name"
}

# variable "gke_private_endpoint_subnetwork" {
#   type        = string
#   description = "cluster private endpoint subnetwork"
# }

# variable "gke_cluster_subnetwork" {
#   type        = string
#   description = "cluster node subnetwork"
# }

# variable "gke_cluster_ip_range_pods_subnetwork" {
#   type        = string
#   description = "cluster pod ip range"
# }

# variable "gke_cluster_ip_range_services_subnetwork" {
#   type        = string
#   description = "cluster services ip range"
# }
