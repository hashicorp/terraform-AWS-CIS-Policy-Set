terraform {
  required_providers {
    tfe = {
      source = "hashicorp/tfe"
      version = "0.55.0"
    }
    github = {
      source = "integrations/github"
      version = "6.2.1"
    }
  }
}
