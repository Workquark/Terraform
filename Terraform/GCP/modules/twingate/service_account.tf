

resource "twingate_service_account" "github_actions" {
  name = "github"
}

resource "time_rotating" "key_rotation" {
  rotation_days = 365
}

resource "time_static" "key_rotation" {
  rfc3339 = time_rotating.key_rotation.rfc3339
}

resource "twingate_service_account_key" "twingate_service_account_key" {
  name               = "Github Actions PROD key (automatically rotating)"
  service_account_id = twingate_service_account.github_actions.id
  lifecycle {
    replace_triggered_by = [time_static.key_rotation]
  }
}



# resource "github_actions_secret" "github_actions_twingate_secret" {
#   repository      = "Workquark/Terraform"
#   secret_name     = "TWINGATE_SERVICE_ACCOUNT_SECRET_KEY"
#   plaintext_value = twingate_service_account_key.github_key_with_rotation.token
# }