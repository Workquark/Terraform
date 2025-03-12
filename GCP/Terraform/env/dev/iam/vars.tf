variable "project_id" {
  type        = string
  description = "gcp project id"
}

variable "project_number" {
  type        = string
  description = "project number"
}


variable "secrets_manager_service_account_emails" {
  type        = list(string)
  description = "secrets manager admins project service accounts"
  default     = []
}


variable "dns_admin_service_account_emails" {
  type        = list(string)
  description = "dns admins project service accounts"
  default     = []
}
