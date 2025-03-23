# Terraform plugins
# Be sure you have the compiled plugins on $HOME/.terraform.d/plugins/


# terraform-provider-google >= 5.37
# terraform-provider-google-beta >= 5.37

module "dns_zones_iam_binding" {
  source  = "terraform-google-modules/iam/google//modules/dns_zones_iam"
  version = "~> 8.0"

  project = var.project_id

  managed_zones = [for dns_name in toset(local.dns_names) : dns_name]
  # mode = "authoritative" default - additive

  bindings = {
    "roles/dns.admin" = [for sa in local.dns_admin_service_account_emails : format("serviceAccount:%s", sa)]
  }

  depends_on = [
    module.cloud_dns_zone
    # module.secrets_manager_admins,
    # module.dns_admins
  ]
}
