## Terraform config to create policy sets for OOTB sentinel policies

This repository contains terraform configs to create Policy sets for OOTB policies written in Sentinel. Once applied, all runs within specific/all workspaces will be subjected to policy evaluations between the `plan` and `apply` phases.

### Steps to run the configuration

- Identify the name of the `GitHub` repository where policies are hosted.
- Identify the name of the TFE/TFC organization where the policy set will get created.
- Create a [Personal Access Token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens) in GitHub with `repo:read` permissions on the chosen repo in Step 1.
- Place the inputs in a separate `input.tfvars` file. To create a policy set that is global to the organization, add the following inputs
```hcl
name                     = "test"
tfe_organization         = "<your-tfe-org>"
create_global_policy_set = true
policy_github_repository = "<policy-github-repo>"
github_oauth_token       = "<your-pat-token>"
```
- To create a policy set that is scoped to certain workspaces, add the following inputs
```hcl
name                     = "test"
tfe_organization         = "<your-tfe-org>"
policy_set_workspace_ids = [ "workspace_id_1", "workspace_id_2" ]
policy_github_repository = "<policy-github-repo>"
github_oauth_token       = "<your-pat-token>"
```
- Run `terraform plan -var-file=input.tfvars` to view the plan.
- Run `terraform apply -var-file=input.tfvars` to apply the changes.
- After successful creation, you should see sentinel policies getting evaluated in every run of every workspace where the policy set is scoped to.