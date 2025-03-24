locals {
  principals = [
    "principal://iam.googleapis.com/projects/${var.project_number}/locations/global/workloadIdentityPools/${var.project_id}.svc.id.goog/subject/ns/cert-manager/sa/cert-manager",
    "principal://iam.googleapis.com/projects/${var.project_number}/locations/global/workloadIdentityPools/${var.project_id}.svc.id.goog/subject/ns/external-dns-public/sa/external-dns-public",
  ]

  dns_admin_service_account_emails = [
    "external-dns@${var.project_id}.iam.gserviceaccount.com",
    "cert-manager@${var.project_id}.iam.gserviceaccount.com"
  ]

  secrets_manager_service_account_emails = [
    "external-secrets@${var.project_id}.iam.gserviceaccount.com"
  ]
}