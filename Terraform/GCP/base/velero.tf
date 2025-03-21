# locals {
#   velero_permissions = [
#     "compute.disks.get",
#     "compute.disks.create",
#     "compute.disks.createSnapshot",
#     "compute.snapshots.get",
#     "compute.snapshots.create",
#     "compute.snapshots.useReadOnly",
#     "compute.snapshots.delete",
#     "compute.zones.get",
#     "iam.serviceAccounts.getAccessToken",
#     "iam.serviceAccounts.get",
#     "iam.serviceAccounts.getOpenIdToken",
#     "iam.serviceAccounts.implicitDelegation",
#     "iam.serviceAccounts.list",
#     "iam.serviceAccounts.signBlob",
#     "iam.serviceAccounts.signJwt",
#     "storage.objects.create",
#     "storage.objects.delete",
#     "storage.objects.get",
#     "storage.objects.list",
#     "storage.objects.update"
#   ]
# }

# # Terraform plugins
# # Terraform >= 0.13.0
# # terraform-provider-google 2.5
# # terraform-provider-google-beta 2.5


# module "velero_role" {
#   source  = "terraform-google-modules/iam/google//modules/custom_role_iam"
#   version = "~> 8.0"

#   target_id   = var.project_id
#   role_id     = "velero.server"
#   title       = "Velero Server"
#   description = "Velero Server Custom Role"

#   permissions = local.velero_permissions
# }

# module "velero_service_account" {
#   source     = "terraform-google-modules/service-accounts/google"
#   version    = "~> 4.4"
#   project_id = var.project_id

#   descriptions = ["velero service account for gke"]

#   # prefix     = "velero"
#   names = ["velero"]
#   project_roles = [
#     "${var.project_id}=>projects/${var.project_id}/roles/${module.velero_role.custom_role_id}",
#     "${var.project_id}=>roles/iam.serviceAccountTokenCreator",
#   ]

#   depends_on = [
#     module.velero_role
#   ]
# }
