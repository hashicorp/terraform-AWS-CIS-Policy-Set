terraform {
  required_providers {
    tfe = {
      version = "0.55.0"
    }
  }
}

provider "tfe" {
  hostname     = var.tfe_hostname
  organization = var.tfe_organization
}