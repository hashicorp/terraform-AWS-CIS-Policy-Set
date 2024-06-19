module "cis_v1-2-0_policies" {
  source = "../ootb-policy"

  name                                 = "cis-1.2.0"
  github_oauth_token                   = "your-gh-pat-token"
  policy_github_repository             = "policy-library-aws-cis-v1.2.0-terraform"
  policy_github_repository_release_tag = "v0.1.0-alpha"
  tfe_organization                     = "test-ganes-org-4"
  policy_set_workspace_names           = []
}