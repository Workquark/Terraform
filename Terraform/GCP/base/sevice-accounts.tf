
###################################################################
##         DNS ADMIN KUBERNETES SERVICE ACCOUNTS                 ##
## ROLE BINDINGS                                                 ##
## - DNS ADMIN                                                   ##
## - IAM SERVICE ACCOUNT TOKEN CREATOR                           ##
##                                                               ##
## SERVICE ACCOUNTS                                              ## 
## - External DNS                                                ##
## - External Secrets                                            ## 
###################################################################

module "dns_admins" {
  source     = "terraform-google-modules/service-accounts/google"
  version    = "~> 4.4"
  project_id = var.project_id

  descriptions = [
    "Service account for external dns in gke",
    "Service account for cert-manager in gke"
  ]

  names = ["external-dns", "cert-manager"]

  project_roles = [
    "${var.project_id}=>roles/iam.serviceAccountTokenCreator",
    "${var.project_id}=>roles/dns.admin"
  ]
}

###############################################################################
##         SECRETS MANAGER ADMIN KUBERNETES SERVICE ACCOUNTS                 ##
## ROLE BINDINGS                                                             ##
## - SECRETS MANAGER ADMIN                                                   ##
## - IAM SERVICE ACCOUNT TOKEN CREATOR                                       ##
##                                                                           ##
## SERVICE ACCOUNTS                                                          ## 
## - External Secrets                                                        ## 
###############################################################################

module "secrets_manager_admins" {
  source     = "terraform-google-modules/service-accounts/google"
  version    = "~> 4.4"
  project_id = var.project_id

  descriptions = ["Service account for external secrets in gke"]

  names = ["external-secrets"]

  project_roles = [
    "${var.project_id}=>roles/iam.serviceAccountTokenCreator",
    "${var.project_id}=>roles/secretmanager.admin"
  ]
}
