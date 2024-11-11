module "cis_v1-2-0_policies" {
  source = "./pre-written-policy"

  for_each                             = { for idx, value in var.policy_github_repository : idx => value }

  name                                 = "${var.name}-${each.key}"
  policy_github_repository             = each.value
  tfe_organization                     = var.tfe_organization
  policy_set_workspace_names           = var.policy_set_workspace_names
}