resource "time_sleep" "wait_10_seconds_2" {
  depends_on = [kubectl_manifest.agent_pool]
  lifecycle {
    replace_triggered_by = [
      null_resource.always_run
    ]
  }

  create_duration = "10s"
}

data "tfe_agent_pool" "pool" {
  depends_on   = [time_sleep.wait_10_seconds_2]
  name         = "${var.prefix}-${var.agent_pool_name}"
  organization = var.tf_organization_name
}

resource "tfe_workspace" "ws" {
  count = var.workspace_count

  name         = "${var.prefix}-agent-workspace-${count.index}"
  organization = var.tf_organization_name
  project_id   = tfe_project.this.id
  tag_names    = [var.prefix, "demo"]

  vcs_repo {
    identifier     = var.vcs_repo_identifier
    oauth_token_id = var.vcs_oauth_token_id
  }
}

resource "tfe_workspace_settings" "ws_settings" {
  count = var.workspace_count

  workspace_id   = tfe_workspace.ws[count.index].id
  execution_mode = "agent"
  agent_pool_id  = data.tfe_agent_pool.pool.id
}