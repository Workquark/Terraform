# # The following dependencies must be available:

# # Terraform >= 0.13.0
# # For Terraform v0.11 see the Compatibility section above
# # Terraform Provider for GCP plugin >= v4.42

# module "gcs_buckets" {
#   source  = "terraform-google-modules/cloud-storage/google"
#   version = "~> 8.0"

#   project_id      = var.project_id
#   names           = var.bucket_names
#   prefix          = "${var.name}-${var.environment}"
#   set_admin_roles = true

#   versioning = {
#     velero-backup = true
#   }

#   public_access_prevention = "enforced"

#   # encryption_key_names

#   lifecycle_rules = [{
#     action = {
#       type = "Delete"
#     }
#     condition = {
#       age        = 180
#       with_state = "ANY"
#       # matches_prefix = var.project_id
#     }
#   }]

#   # admins = var.cloud_storage_admins
#   # bucket_admins = var.bucket_admins
# }