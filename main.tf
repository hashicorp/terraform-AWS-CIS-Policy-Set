locals {
  policy_set_name        = "${var.name}-policy-set"
  policy_set_description = "Policy set created via terraform to evaluate resources against Sentinel policies"
  policy_set_kind        = "sentinel"
  sentinel_version       = "0.26.0"

  unzipped_policy_dir = "${path.module}/unzipped"
  policy_owner        = "hashicorp"
}

# ------------------------------------------------  
# Fetch GitHub release assets for policy repo
# ------------------------------------------------  
data "github_release" "this" {
  repository  = var.policy_github_repository
  owner       = local.policy_owner
  retrieve_by = "tag"
  release_tag = var.policy_github_repository_release_tag
}

resource "null_resource" "download_release" {
  depends_on = [data.github_release.this]

  triggers = {
    timestamp = timestamp()
  }

  provisioner "local-exec" {
    command = <<EOT
      DOWNLOAD_DIR="${path.module}/downloads"
      UNZIP_DIR="${local.unzipped_policy_dir}"
      TEMP_DIR="${path.module}/temp_unzip"

      mkdir -p $DOWNLOAD_DIR
      mkdir -p $UNZIP_DIR
      mkdir -p $TEMP_DIR

      curl -L -o "$DOWNLOAD_DIR/${var.policy_github_repository}-${var.policy_github_repository_release_tag}.zip" -H "Authorization: Bearer ${var.github_oauth_token}" ${data.github_release.this.zipball_url}

      unzip -o "$DOWNLOAD_DIR/${var.policy_github_repository}-${var.policy_github_repository_release_tag}.zip" -d $TEMP_DIR
      
      mv $TEMP_DIR/*/* $UNZIP_DIR

      rm -rf $TEMP_DIR
      rm -rf $DOWNLOAD_DIR
    EOT
  }
}

# ------------------------------------------------  
# Policy Set creation
# ------------------------------------------------  

data "tfe_slug" "this" {
  depends_on = [null_resource.download_release]

  source_path = local.unzipped_policy_dir
}

resource "tfe_policy_set" "global_policy_set" {
  count      = var.create_global_policy_set ? 1 : 0
  depends_on = [data.tfe_slug.this]

  name                = local.policy_set_name
  description         = local.policy_set_description
  organization        = var.tfe_organization
  kind                = local.policy_set_kind
  policy_tool_version = local.sentinel_version
  agent_enabled       = true
  global              = true

  slug = data.tfe_slug.this
}

resource "tfe_policy_set" "workspace_scoped_policy_set" {
  count      = !var.create_global_policy_set ? 1 : 0
  depends_on = [data.tfe_slug.this]

  name                = local.policy_set_name
  description         = local.policy_set_description
  organization        = var.tfe_organization
  kind                = local.policy_set_kind
  policy_tool_version = local.sentinel_version
  agent_enabled       = true
  workspace_ids       = var.policy_set_workspace_ids

  slug = data.tfe_slug.this
}

# ------------------------------------------------  
# Cleanup (Conditional)
# ------------------------------------------------  

locals {
  cleanup_command = <<EOT
    UNZIP_DIR="${local.unzipped_policy_dir}"

    rm -rf $UNZIP_DIR
  EOT
}

resource "null_resource" "cleanup_1" {
  count = var.create_global_policy_set ? 1 : 0
  depends_on = [
    tfe_policy_set.global_policy_set[0]
  ]

  triggers = {
    timestamp = timestamp()
  }

  provisioner "local-exec" {
    command = local.cleanup_command
  }
}

resource "null_resource" "cleanup_2" {
  count = !var.create_global_policy_set ? 1 : 0
  depends_on = [
    tfe_policy_set.workspace_scoped_policy_set[0]
  ]

  triggers = {
    timestamp = timestamp()
  }

  provisioner "local-exec" {
    command = local.cleanup_command
  }
}