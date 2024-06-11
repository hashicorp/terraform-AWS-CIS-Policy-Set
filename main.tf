module "sentinel_policy_library" {
  source                               = "./modules/policies"
  name                                 = "cis"
  tfe_organization                     = "<ORG_NAME>"
  github_oauth_token                   = "<TOKEN>"
  policy_github_repository             = ["policy-library-aws-cis-v1.2.0-terraform", "policy-library-aws-cis-v1.4.0-terraform"]
  policy_set_workspace_names           = ["<WORKSPACE_NAME>"]
  policy_github_repository_release_tag = "<TAG>"
}