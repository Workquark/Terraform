terraform {
  required_providers {
    twingate = {
      source  = "Twingate/twingate"
      version = "3.0.11"
    }

    github = {
      source  = "integrations/github"
      version = "6.6.0"
    }
  }
}
