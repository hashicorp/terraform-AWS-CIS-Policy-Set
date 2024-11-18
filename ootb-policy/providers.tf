// Copyright (c) HashiCorp, Inc.
// SPDX-License-Identifier: BUSL-1.1

terraform {
  required_providers {
    tfe = {
      version = "0.55.0"
    }
    github = {
      version = "6.2.1"
    }
  }
}

provider "tfe" {
  hostname     = var.tfe_hostname
  organization = var.tfe_organization
}

provider "github" {
  token = var.github_oauth_token
}