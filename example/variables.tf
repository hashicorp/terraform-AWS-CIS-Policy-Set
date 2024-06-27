variable "gh_pac_token" {
  description = "A GitHub OAuth / Personal Access Token."
}

variable "tfe_organization_name" {
  description = "The default organization that resources should belong to"
}

variable "tfe_workspace_names" {
  description = "The list of workspaces to be included in the policy set scope"
}