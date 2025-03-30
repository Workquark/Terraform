# The following dependencies must be available:

# Terraform >= 0.13.0
# Terraform Provider for GCP plugin >= v4.40

####################################
##        CLOUD DNS ZONE          ##
####################################

module "cloud_dns_zone" {
  for_each = { for k, dns in var.cloud_domains : k => dns if local.create_dns }
  # for_each = var.cloud_domains

  source     = "terraform-google-modules/cloud-dns/google"
  version    = "~> 5.3"
  project_id = var.project_id
  type       = "public"
  name       = trimsuffix(replace(each.key, ".", "-"), "-") # Replace all . with - in the domains.Also trimsuffix the ending "-" in the replacement string.
  domain     = each.key

  recordsets = each.value

  # dnssec_config =  {
  #   state = "on"

  #   default_key_specs_key = {
  #     algorithm = "rsasha256"
  #     key_length = 2048
  #     key_type = "zoneSigning"
  #     kind = "dnsKeySpec"
  #   }
  # }
}


module "cloud_private_dns_zone" {
  for_each = var.cloud_domains

  source  = "terraform-google-modules/cloud-dns/google"
  version = "5.3.0"

  project_id = var.project_id
  type       = "private"
  name       = "private-${trimsuffix(replace(each.key, ".", "-"), "-")}"
  domain     = "private.${each.key}"

  private_visibility_config_networks = [module.vpc.network_self_link]

  # dnssec_config =  {
  #   state = "on"

  #   default_key_specs_key = {
  #     algorithm = "rsasha256"
  #     key_length = 2048
  #     key_type = "zoneSigning"
  #     kind = "dnsKeySpec"
  #   }
  # }
}
