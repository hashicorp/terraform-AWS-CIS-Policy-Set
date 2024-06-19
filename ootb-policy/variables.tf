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

variable "github_oauth_token" {
  description = "OAuth token having read access to the repository inputted via 'var.policy_github_repository'"
  type        = string
}

variable "name" {
  description = "Common suffix/prefix prepended/appended to all the resources getting created with this module."
  type        = string
}

variable "policy_github_repository" {
  description = "The name of the GitHub repository where the policies reside. This name should not include the GitHub organization."
  type        = string

  validation {
    error_message = "Policy GitHub repository must belong to one of the supported repositories."
    condition     = contains(["policy-library-aws-cis-v1.2.0-terraform", "policy-library-aws-cis-v1.4.0-terraform", "policy-library-aws-cis-v3.0.0-terraform"], var.policy_github_repository)
  }
}

variable "policy_github_repository_release_tag" {
  description = "The release tag that will be used to download the policy repo's zipball asset"
  type        = string
}