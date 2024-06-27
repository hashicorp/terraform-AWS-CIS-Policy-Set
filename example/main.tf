module "cis_v1-2-0_policies" {
  source = "../ootb-policy"

  name                                 = "cis-1-2-0"
  github_oauth_token                   = var.gh_pac_token
  policy_github_repository             = "policy-library-aws-cis-v1.2.0-terraform"
  policy_github_repository_release_tag = "v0.1.0-alpha"
  tfe_organization                     = var.tfe_organization_name
  policy_set_workspace_names           = var.tfe_workspace_names
}

module "cis_v1-4-0_policies" {
  source = "../ootb-policy"

  name                                 = "cis-1-4-0"
  github_oauth_token                   = var.gh_pac_token
  policy_github_repository             = "policy-library-aws-cis-v1.4.0-terraform"
  policy_github_repository_release_tag = "v0.1.0-alpha"
  tfe_organization                     = var.tfe_organization_name
  policy_set_workspace_names           = var.tfe_workspace_names
}

module "cis_v3-0-0_policies" {
  source = "../ootb-policy"

  name                                 = "cis-3-0-0"
  github_oauth_token                   = var.gh_pac_token
  policy_github_repository             = "policy-library-aws-cis-v3.0.0-terraform"
  policy_github_repository_release_tag = "v0.1.0-alpha"
  tfe_organization                     = var.tfe_organization_name
  policy_set_workspace_names           = var.tfe_workspace_names
}