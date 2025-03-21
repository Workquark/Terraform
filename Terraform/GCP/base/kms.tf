
# resource "google_kms_key_ring" "keyring" {
#   name     = var.name
#   location = "global"
#   depends_on = [
#     google_project_service.apis
#   ]
# }

# resource "google_kms_crypto_key" "artifact_registry" {
#   name            = "${var.name}-artifact-registry-csek"
#   key_ring        = google_kms_key_ring.keyring.id
#   rotation_period = "7776000s"

#   lifecycle {
#     prevent_destroy = true
#   }
#   depends_on = [
#     google_project_service.apis
#   ]
# }



# resource "google_kms_crypto_key" "disk_encryption_key" {
#   name            = "${var.name}-boot-disk-csek"
#   key_ring        = google_kms_key_ring.keyring.id
#   rotation_period = "7776000s"

#   lifecycle {
#     prevent_destroy = true
#   }
#   depends_on = [
#     google_project_service.apis
#   ]
# }