locals {
  policy_set_name        = "${var.name}-policy-set"
  policy_set_description = "Policy set created via terraform to evaluate resources against Sentinel policies"
  policy_set_kind        = "sentinel"
  sentinel_version       = "0.26.0"

  unzipped_policy_dir = "${path.module}/unzipped"
  policy_owner        = "hashicorp"
}

resource "null_resource" "download_release" {
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

      latest_tag=$(curl -s https://api.github.com/repos/hashicorp/${var.policy_github_repository}/tags | jq -r '.[0].name')

      zip_url="https://api.github.com/repos/hashicorp/${var.policy_github_repository}/zipball/refs/tags/$latest_tag"

      curl -L -o "$DOWNLOAD_DIR/$latest_tag.zip" "$zip_url"

      unzip -o "$DOWNLOAD_DIR/$latest_tag.zip" -d $TEMP_DIR
      
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

data "tfe_workspace_ids" "workspaces" {
  names        = var.policy_set_workspace_names
  organization = var.tfe_organization
}

resource "tfe_policy_set" "workspace_scoped_policy_set" {
  depends_on = [data.tfe_slug.this]

  name                = local.policy_set_name
  description         = local.policy_set_description
  organization        = var.tfe_organization
  kind                = local.policy_set_kind
  policy_tool_version = local.sentinel_version
  agent_enabled       = true
  workspace_ids       = values(data.tfe_workspace_ids.workspaces.ids)

  slug = data.tfe_slug.this
}

# ------------------------------------------------  
# Cleanup
# ------------------------------------------------  

resource "null_resource" "cleanup" {
  depends_on = [
    tfe_policy_set.workspace_scoped_policy_set
  ]

  triggers = {
    timestamp = timestamp()
  }

  provisioner "local-exec" {
    command = <<EOT
      UNZIP_DIR="${local.unzipped_policy_dir}"

      rm -rf $UNZIP_DIR
    EOT
  }
}