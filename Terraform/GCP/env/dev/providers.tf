provider "google" {
  project      = var.project_id
  region       = var.region
  access_token = var.auth_token

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
      version = "6.12.0"
    }

    google-beta = {
      source  = "hashicorp/google-beta"
      version = "6.12.0"
    }

    twingate = {
      source  = "Twingate/twingate"
      version = "~> 3.0"
    }

    null = {
      source  = "hashicorp/null"
      version = "~> 3.2.0"
    }
  }
  backend "gcs" {
    bucket = "jrc-practice-01-dev-terraform-backend-bucket"
    prefix = "Terraform/dev/terraform.state"
  }
}
