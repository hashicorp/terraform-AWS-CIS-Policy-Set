# ------------------------------------------------  
# Policy Set creation
# ------------------------------------------------  

locals {
  policy_set_name        = "${var.name}-policy-set"
  policy_set_description = "Policy set created via terraform to evaluate resources against Sentinel policies"
  policy_set_kind        = "sentinel"
  sentinel_version       = "0.26.0"
}

resource "tfe_policy_set" "global_policy_set" {
  count      = var.create_global_policy_set ? 1 : 0
  depends_on = [tfe_oauth_client.this]

  name                = local.policy_set_name
  description         = local.policy_set_description
  organization        = var.tfe_organization
  kind                = local.policy_set_kind
  policy_tool_version = local.sentinel_version
  agent_enabled       = true
  global              = true

  vcs_repo {
    identifier         = var.policy_github_repository
    ingress_submodules = true
    oauth_token_id     = tfe_oauth_client.this.oauth_token_id
  }
}

resource "tfe_policy_set" "workspace_scoped_policy_set" {
  count      = !var.create_global_policy_set ? 1 : 0
  depends_on = [tfe_oauth_client.this]

  name                = local.policy_set_name
  description         = local.policy_set_description
  organization        = var.tfe_organization
  kind                = local.policy_set_kind
  policy_tool_version = local.sentinel_version
  agent_enabled       = true
  workspace_ids       = var.policy_set_workspace_ids

  vcs_repo {
    identifier         = var.policy_github_repository
    ingress_submodules = true
    oauth_token_id     = tfe_oauth_client.this.oauth_token_id
  }
}

resource "tfe_oauth_client" "this" {
  name             = "${var.name}-github-tfe-oauth-client"
  api_url          = "https://api.github.com"
  http_url         = "https://github.com"
  service_provider = "github"
  oauth_token      = var.github_oauth_token
}