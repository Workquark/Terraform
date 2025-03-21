
# ####################################
# ##        ARTIFACT REGISTRY       ##
# ####################################

# resource "google_artifact_registry_repository" "this" {
#   for_each      = toset(var.artifact_registries)
#   location      = var.region
#   repository_id = each.value
#   description   = "${each.value} artifact docker registry"
#   format        = "DOCKER"

#   cleanup_policy_dry_run = true

#   # kms_key_name  = google_kms_crypto_key.artifact_registry.name

#   cleanup_policies {
#     id     = "delete-prerelease"
#     action = "DELETE"
#     condition {
#       tag_state    = "TAGGED"
#       tag_prefixes = ["v0.0.1-pre"]
#       older_than   = "86400s"
#     }
#   }
#   cleanup_policies {
#     id     = "keep-tagged-release"
#     action = "KEEP"
#     condition {
#       tag_state             = "TAGGED"
#       tag_prefixes          = ["v0.0.1"]
#       package_name_prefixes = ["dev"]
#     }
#   }
#   cleanup_policies {
#     id     = "keep-minimum-versions"
#     action = "KEEP"
#     most_recent_versions {
#       package_name_prefixes = ["dev"]
#       keep_count            = 5
#     }
#   }

#   docker_config {
#     immutable_tags = var.artifact_registry_enable_immutable_tags
#   }

#   depends_on = [
#     google_kms_crypto_key.artifact_registry
#   ]
# }
