
###############################################
##              IAM BINDINGS                 ##
## - IAM SERVICE ACCOUNT TOKEN CREATOR       ##
## - DNS READER                              ##
## - DNS ADMIN                               ##
## - IAM SERVICE ACCOUNT TOKEN CREATOR       ##
###############################################

# terraform-provider-google >= 5.37
# terraform-provider-google-beta >= 5.37
module "project_iam_bindings" {
  source  = "terraform-google-modules/iam/google//modules/projects_iam"
  version = "~> 8.0"

  projects = [var.project_id]
  mode     = "additive"

  bindings = {
    "roles/iam.serviceAccountTokenCreator" = local.principals
    "roles/dns.reader"                     = local.principals
    "roles/dns.admin"                      = [for sa in local.dns_admin_service_account_emails : format("serviceAccount:%s", sa)]
    "roles/iam.serviceAccountTokenCreator" = [
      for sa in concat(local.dns_admin_service_account_emails, local.secrets_manager_service_account_emails) : format("serviceAccount:%s", sa)
    ]
  }
}
