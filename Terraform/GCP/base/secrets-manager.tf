# Software
# The following dependencies must be available:

# Terraform v0.13
# Terraform Provider for GCP plugin v3.0

resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "-_"
}

module "secret-manager" {
  source     = "GoogleCloudPlatform/secret-manager/google"
  version    = "~> 0.5"
  project_id = var.project_id
  secrets = [
    {
      name                  = "argocd-dex-oauth-secret"
      automatic_replication = true
      secret_data = jsonencode({
        clientID     = var.github_app_oauth_clientid
        clientSecret = var.github_app_oauth_client_secret
      })
    },
    # {
    #   name                  = "github-action-runners-config-secret"
    #   automatic_replication = true
    #   secret_data = jsonencode({
    #     github_app_installation_id = var.github_app_installation_id
    #     github_app_id              = var.github_app_id
    #     github_app_private_key     = var.github_app_oauth_private_key
    #   })
    # },
    # {
    #   name                  = "valkey-password-secret"
    #   automatic_replication = true
    #   secret_data = jsonencode({
    #     password = random_password.password.result
    #   })
    # }
  ]
}