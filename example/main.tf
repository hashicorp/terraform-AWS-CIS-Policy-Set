module "cis_v1-2-0_policies" {
  source = "../pre-written-policy"

  name                                 = "testing9"
  policy_github_repository             = "policy-library-aws-networking-terraform"
  tfe_organization                     = "team-rnd-india-test-org"
  policy_set_workspace_names           = ["demo"]
}