# output "github_service_account" {
#   description = "github service account email"
#   value       = module.github.email
# }

output "network_self_link" {
  value = module.vpc.network_self_link
}

output "network_name" {
  value = module.vpc.network_name
}

output "global_static_ip" {
  description = "global static ip"
  value       = google_compute_global_address.global_static_ip.address
}

output "global_static_ip_name" {
  description = "global static ip"
  value       = google_compute_global_address.global_static_ip.name
}

# output "endpoints" {
#   value       = module.gke.endpoints
# }


# output "dev_master_ipv4_cidr_block" {
#   description = "description"
#   value       = module.gke.dev_master_ipv4_cidr_block
# }


# output "management_master_ipv4_cidr_block" {
#   description = "description"
#   value       = module.gke.management_master_ipv4_cidr_block
# }


output "dns_names" {
  description = "description"
  value       = [for dns in module.cloud_dns_zone : dns.name]
}

output "dns_admins" {
  description = "description"
  value       = module.dns_admins.service_accounts
}

output "secrets_manager_admins" {
  description = "description"
  value       = module.secrets_manager_admins.service_accounts
}

output "secrets_manager_service_account_emails" {
  description = "description"
  value       = module.secrets_manager_admins.emails_list
}


output "dns_admin_service_account_emails" {
  description = "description"
  value       = module.dns_admins.emails_list
}
