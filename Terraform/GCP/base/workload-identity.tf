# ################################################
# ##        GOOGLE WORKLOAD IDENTITY POOL       ##
# ################################################

# resource "google_iam_workload_identity_pool" "this" {
#   display_name              = "Github"
#   workload_identity_pool_id = "github"

#   lifecycle {
#     prevent_destroy = true
#   }
# }

# #########################################################
# ##        GOOGLE WORKLOAD IDENTITY POOL PROVIDER       ##
# #########################################################

# resource "google_iam_workload_identity_pool_provider" "this" {
#   workload_identity_pool_provider_id = "github-provider"
#   workload_identity_pool_id          = google_iam_workload_identity_pool.this.workload_identity_pool_id
#   display_name                       = "GITHub provider"

#   attribute_mapping = {
#     "attribute.actor"      = "assertion.actor"
#     "attribute.repository" = "assertion.repository"
#     "google.subject"       = "assertion.sub"
#   }

#   oidc {
#     allowed_audiences = []
#     issuer_uri        = "https://token.actions.githubusercontent.com"
#   }

#   lifecycle {
#     prevent_destroy = true
#   }

#   depends_on          = [google_iam_workload_identity_pool.this]
#   attribute_condition = "assertion.repository_owner == '<github-organization-name>'"
#   # attribute_condition = "attribute.from.subject == \"serviceAccount:github@${var.project_id}.iam.gserviceaccount.com\""
# }

# # Software
# # The following dependencies must be available:

# # Terraform >= 0.13.0
# # Terraform Provider for GCP plugin >= v2.0
# # https://registry.terraform.io/modules/terraform-google-modules/service-accounts/google/4.4.0

# #############################################################
# ##        GITHUB SERVICE ACCOUNT TO USE IN PIPELINES       ##
# #############################################################

# module "github" {
#   source  = "terraform-google-modules/service-accounts/google"
#   version = "~> 4.4"

#   description   = "Service account for github"
#   project_id    = var.project_id
#   names         = [var.github_action_service_account_name]
#   project_roles = [for role in var.github_action_service_account_roles : "${var.project_id}=>${role}"]
# }

# resource "google_service_account_iam_binding" "this" {
#   service_account_id = module.github.service_account.id
#   role               = "roles/iam.workloadIdentityUser"

#   members = local.workload_identity_principalsets

#   # members = [
#   #   "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.this.name}/attribute.repository/${var.git_repo}"
#   # ]
# }
