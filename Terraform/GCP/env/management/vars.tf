variable "project_id" {
  type        = string
  description = "GCP project id"
}

variable "region" {
  type        = string
  description = "GCP region"
}

variable "auth_token" {
  type        = string
  description = "`gcloud auth application-default login` auth token using `gcloud auth print-access-token`"
}

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

#########################################
### TWINGATE SECRET AND CREDENTIALS  ####
#########################################

variable "twingate_api_token" {
  type        = string
  description = "twingate api token"
}


variable "twingate_admin_group_id" {
  type        = string
  description = "twingate admin group id"
}


###################################################
### ARGOCD GITHUB DEX OAUTH SECRETS AND CREDS  ####
###################################################
variable "github_token" {
  type        = string
  description = "github token"
}


variable "github_app_oauth_clientid" {
  type        = string
  description = "github oauth app client id"
  default     = ""
}

variable "github_app_oauth_client_secret" {
  type        = string
  description = "github oauth app client secret"
  default     = ""
}

# Ref - https://stackoverflow.com/questions/74462420/where-can-we-find-github-apps-installation-id

variable "github_app_id" {
  type        = string
  description = "This is github app id"
  default     = ""
}

variable "github_app_installation_id" {
  type        = string
  description = "github app installation id . used for github action runner scale set"
  default     = ""
}

variable "github_app_oauth_private_key" {
  type        = string
  description = "github app private key"
  default     = ""
}
