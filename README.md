## POC CODE - NO LONGER IN USE ##

## Terraform module to create policy sets for Pre-written sentinel policies

This repository hosts a terraform module [pre-written-policy](./pre-written-policy/) to create Policy sets for Pre-written policies written in Sentinel. Once applied, all runs within specific/all workspaces will be subjected to policy evaluations between the `plan` and `apply` phases.

### Steps to run the configuration

- Set the `TFE_TOKEN` environment to TFC/TFE's API token. This can either be an user token or organization scoped token.
- Identify the name of the `GitHub` repository where policies are hosted.
- Identify the name of the TFE/TFC organization where the policy set will get created.
- Create a [Personal Access Token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens) in GitHub with `repo:read` permissions on the chosen repo in Step 1.
- Use the above mentioned inputs to invoke the module for deploying the policy set to TFE/TFC.
```hcl
module "cis_v1-2-0_policies" {
  source = "../pre-written-policy"

  name                                 = "cis-1-2-0"
  policy_github_repository             = "policy-library-aws-cis-v1.2.0-terraform"
  tfe_organization                     = "<your-tfe-org>"
  policy_set_workspace_names           = ["target_workspace_1"]
}
```
- Run `terraform plan` to view the plan.
- Run `terraform apply` to apply the changes.
- After successful creation, you should see sentinel policies getting evaluated in every run of every workspace where the policy set is scoped to.
