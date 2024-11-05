variable "tfe_hostname" {
  description = "Host name for the TFE instance. Defaults to TFC i.e. app.terraform.io if unspecified"
  type        = string
  default     = ""
}

variable "tfe_organization" {
  description = "The TFE organization where Sentinel based policy sets will be created. These policies will run against all the workspaces present in the organization"
  type        = string
}

variable "policy_set_workspace_names" {
  description = "List of workspace names to scope the policy set to."
  type        = list(string)
}

variable "name" {
  description = "Common suffix/prefix prepended/appended to all the resources getting created with this module."
  type        = string
}

variable "policy_github_repository" {
  description = "The name of the GitHub repository where the policies reside. This name should not include the GitHub organization."
  type        = string
}