output "cluster_endpoint" {
  value = module.gke.endpoint
}

output "cluster_ca_certificate" {
  description = "ca certificate for cluster"
  value       = module.gke.ca_certificate
}
