resource "google_project_service" "apis" {
  for_each = toset(var.project_apis)
  project  = var.project_id
  service  = each.key

  timeouts {
    create = "30m"
    update = "40m"
  }

  disable_on_destroy = false
}