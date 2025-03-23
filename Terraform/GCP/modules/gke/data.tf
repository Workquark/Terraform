data "google_client_config" "default" {
  depends_on = [module.gke]
}

