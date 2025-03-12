variable "project_id" {
  type        = string
  description = "project id"
}

variable "region" {
  type        = string
  description = "The project region name"
}

variable "name" {
  type        = string
  description = "The project name"
}

variable "environment" {
  type        = string
  description = "The resource deployment environment name"
}

variable "artifact_registry_enable_immutable_tags" {
  type        = bool
  description = "Artifact registry immutable tag. If enabled a tag can be used only once and cannot be deleted. Default is false"
  default     = false
}

variable "artifact_registries" {
  type = list(string)
}

variable "project_apis" {
  type        = list(string)
  description = "list of project apis to be enabled"
  default = [
    "iam.googleapis.com",
    "container.googleapis.com",
    "compute.googleapis.com",
    "cloudkms.googleapis.com",
    "secretmanager.googleapis.com"
  ]
}

###########################
### CLOUD DNS VARIABLES ###
###########################


variable "cloud_domains" {
  type = map(list(object({
    name    = string
    type    = string
    ttl     = number
    records = optional(list(string), null)

    routing_policy = optional(object({
      wrr = optional(list(object({
        weight  = number
        records = list(string)
      })), [])
      geo = optional(list(object({
        location = string
        records  = list(string)
      })), [])
    }))
    }))
  )

  description = "cloud dns name. should not include (.) instead include (-)"
  default     = {}
}

##########################
### WORKLOAD IDENTITY  ###
##########################

variable "git_repos" {
  type        = list(string)
  description = "list of git repositories to give access for github workload identity"
}

variable "github_action_service_account_roles" {
  type        = list(string)
  description = "list of github action roles to be provided for github action service account"
}

variable "github_action_service_account_name" {
  type        = string
  description = "github action service account name"
}

##########################
### EXTERNAL DNS GKE  ####
##########################

variable "external_dns_service_account_roles" {
  type        = list(string)
  description = "list of roles for external-dns"
}

###################################################
### ARGOCD GITHUB DEX OAUTH SECRETS AND CREDS  ####
###################################################


variable "github_app_oauth_clientid" {
  type        = string
  description = "github oauth app client id"
}

variable "github_app_oauth_client_secret" {
  type        = string
  description = "github oauth app client secret"
}

variable "github_app_installation_id" {
  type        = string
  description = "github app installation id"
}

variable "github_app_id" {
  type        = string
  description = "github app installation id"
}

variable "github_app_oauth_private_key" {
  type        = string
  description = "github app private key"
}


#############################
### GOOGLE CLOUD STORAGE  ###
#############################

variable "bucket_names" {
  type        = list(string)
  description = "list of bucket names to be created"
}


# variable "bucket_admins" {
#   type        = map(string)
#   description = "comman separated string as map key for bucket admin"
# }

# variable "cloud_storage_admins" {
#   type        = list(string)
#   description = "cloud storage admins as list"
# }

variable "provision_management_cluster" {
  type        = bool
  description = "set to true if management cluster needs to be provisioned"
  default     = true
}


################################
##          NETWORK            #
################################

variable "subnetworks" {
  type = list(object({
    subnet_name           = string
    subnet_ip             = string
    subnet_private_access = bool
    description           = string
    subnet_region         = string

    subnet_flow_logs                 = string
    subnet_flow_logs_interval        = string
    subnet_flow_logs_sampling        = number
    subnet_flow_logs_metadata        = string
    subnet_flow_logs_metadata_fields = list(string)
    subnet_flow_logs_filter          = string
  }))
  description = "description"
}

variable "subnetwork_secondary_ranges" {
  type = map(list(object({
    range_name    = string
    ip_cidr_range = string
  })))
  description = "description"
}

variable "firewall_destination_ranges" {
  type        = list(string)
  description = "Internal Firewall destination ranges"
}


variable "firewall_source_ranges" {
  type        = list(string)
  description = "Internal Firewall Source ranges"
}

variable "network_routing_mode" {
  type        = string
  description = "description"
}

##############################
##          IAM             ##
##############################

variable "cross_project_principalsets" {
  type        = list(string)
  description = "additional principalsets if required in cross project"
  default     = []
}

