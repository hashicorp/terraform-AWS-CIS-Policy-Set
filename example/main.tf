module "cis_v1-2-0_policies" {
  source = "../pre-written-policy"

  name                                 = "cis-1-2-0"
  policy_github_repository             = "policy-library-aws-cis-v1.2.0-terraform"
  tfe_organization                     = "<your-tfe-org>"
  policy_set_workspace_names           = ["target_workspace_1"]
}