locals {
  # workload_identity_principalsets = [for git_repo in var.git_repos : "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.this.name}/attribute.repository/${git_repo}"]

  principals = [
    "principal://iam.googleapis.com/projects/${data.google_project.this.number}/locations/global/workloadIdentityPools/${data.google_project.this.project_id}.svc.id.goog/subject/ns/cert-manager/sa/cert-manager",
    "principal://iam.googleapis.com/projects/${data.google_project.this.number}/locations/global/workloadIdentityPools/${data.google_project.this.project_id}.svc.id.goog/subject/ns/external-dns-public/sa/external-dns-public",
  ]

  dns_admin_service_account_emails = [
    "external-dns@${data.google_project.this.project_id}.iam.gserviceaccount.com",
    "cert-manager@${data.google_project.this.project_id}.iam.gserviceaccount.com"
  ]

  dns_names = [for dns, domain in var.cloud_domains : trimsuffix(replace(dns, ".", "-"), "-")]
}
