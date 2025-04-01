provider "google" {
  project = var.project_id
  region  = var.region
  # access_token = var.auth_token

  default_labels = {
    environment = basename(abspath(path.module))
    owner       = "joydeep"
    project     = "jrconline"
    project     = var.project_id
    github_repo = "terraform"
    managed_by  = "terraform"
  }
}

provider "twingate" {
  api_token = var.twingate_api_token
  network   = "workquark0403"
}

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.27"
    }

    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 6.27"
    }

    twingate = {
      source  = "Twingate/twingate"
      version = "~> 3.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.36.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "3.0.0-pre2"
    }

    null = {
      source  = "hashicorp/null"
      version = "~> 3.2.0"
    }

    github = {
      source  = "integrations/github"
      version = "6.6.0"
    }


  }
  backend "gcs" {
    bucket = "jrc-practice-01-dev-terraform-backend-bucket"
    prefix = "Terraform/dev/terraform.state"
  }
}

data "google_client_config" "default" {
  depends_on = [module.gke_dev]
}

provider "github" {
  owner = "Workquark"
  token = var.github_token
}

# provider "kubernetes" {
#   host                   = module.gke_dev.cluster_endpoint
#   token                  = data.google_client_config.default.access_token
#   cluster_ca_certificate = module.gke_dev.cluster_ca_certificate
# }

# provider "helm" {
#   kubernetes {
#     host                   = module.gke_dev.cluster_endpoint
#     token                  = data.google_client_config.default.access_token
#     cluster_ca_certificate = module.gke_dev.cluster_ca_certificate
#   }
# }