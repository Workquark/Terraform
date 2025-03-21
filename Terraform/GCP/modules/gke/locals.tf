locals {

  gke_github_runners_pool_labels = {
    "nodeType" : "github-runner"
  }

  gke_node_pool_default_labels = {
    "environment" : var.environment
    "project" : "${var.name}"
    "ownership" : "joydeep"
    "disk_type" : "ubuntu_containerd"
    "managed_by" : "terraform"
  }

}
