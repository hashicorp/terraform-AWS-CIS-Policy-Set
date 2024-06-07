provider "tfe" {
  hostname     = var.tfe_hostname
  organization = var.tfe_organization
}

provider "github" {
  token = var.github_oauth_token
}