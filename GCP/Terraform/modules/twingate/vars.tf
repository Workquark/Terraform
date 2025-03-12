variable "project_id" {
  type        = string
  description = "description"
}

variable "name" {
  type        = string
  description = "description"
}

variable "environment" {
  type        = string
  description = "description"
}

variable "network_name" {
  type        = string
  description = "description"
}

variable "zone_names" {
  type        = list(string)
  description = "description"
}


#################################
#           TWINGATE            #
#################################

variable "twingate_instances_count" {
  type        = number
  description = "Number of twingate connector instances"
  default     = 2
}

variable "twingate_subnet_name" {
  type        = string
  description = "Subnet in which twingate connector will be provisioned"
}

variable "twingate_api_token" {
  type        = string
  description = "twingate api token"
}

variable "twingate_image_version" {
  type        = string
  description = "description"

}

variable "twingate_machine_type" {
  type        = string
  description = "twingate machine type"
  default     = "e2-micro"
}

variable "twingate_access_group_ids" {
  type        = list(string)
  description = "description"
}

# variable "twingate_remote_network_id" {
#   type        = string
#   description = "description"
# }




###############
# GKE OUTPUTS #
###############

variable "master_ipv4_cidr_block" {
  type        = string
  description = "description"
  default     = ""
}

variable "private_endpoint_subnetwork_cidr" {
  type        = string
  description = "gke control plane private endpoint cidr block"
  default     = ""
}