locals {
  policy_set_name        = "${var.name}-policy-set"
  policy_set_description = "Policy set created via terraform to evaluate resources against Sentinel policies"
  policy_set_kind        = "sentinel"
  sentinel_version       = "latest"

  unzipped_policy_dir = "${path.module}/unzipped"
  policy_owner        = "HashiCorp"
}

# ------------------------------------------------
# Fetch GitHub release assets for policy repo
# ------------------------------------------------
data "github_release" "this" {
  for_each    = toset(var.policy_github_repository)
  repository  = each.key
  owner       = local.policy_owner
  retrieve_by = "tag"
  release_tag = var.policy_github_repository_release_tag
}

resource "null_resource" "download_release" {
  for_each   = toset(var.policy_github_repository)
  depends_on = [data.github_release.this]

  triggers = {
    timestamp = timestamp()
  }

  provisioner "local-exec" {
    command = <<EOT
      DOWNLOAD_DIR="${path.module}/downloads"
      UNZIP_DIR="${local.unzipped_policy_dir}/${each.key}"

      mkdir -p $DOWNLOAD_DIR
      mkdir -p $UNZIP_DIR

      curl -Z -L -o "$DOWNLOAD_DIR/${each.key}-${var.policy_github_repository_release_tag}.zip" -H "Authorization: Bearer ${var.github_oauth_token}" ${data.github_release.this[each.key].zipball_url}

      unzip -o "$DOWNLOAD_DIR/${each.key}-${var.policy_github_repository_release_tag}.zip" -d $UNZIP_DIR

      mv $UNZIP_DIR/*/* $UNZIP_DIR

      rm -rf $DOWNLOAD_DIR

    EOT
  }
}

# ------------------------------------------------
# Policy Set creation
# ------------------------------------------------

data "tfe_slug" "this" {
  depends_on = [null_resource.download_release]
  for_each   = toset(keys(null_resource.download_release))

  source_path = "${local.unzipped_policy_dir}/${each.key}"
}

data "tfe_workspace_ids" "workspaces" {
  names        = var.policy_set_workspace_names
  organization = var.tfe_organization
}

resource "tfe_policy_set" "global_policy_set" {
  depends_on = [data.tfe_slug.this]
  for_each   = data.tfe_slug.this

  name                = replace(each.key, ".", "_")
  description         = local.policy_set_description
  organization        = var.tfe_organization
  kind                = local.policy_set_kind
  policy_tool_version = local.sentinel_version
  agent_enabled       = true
  workspace_ids       = values(data.tfe_workspace_ids.workspaces.ids)

  slug = each.value
}