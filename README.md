## Terraform Module to onboard Pre-written Sentinel Policies for AWS Foundations Benchmark

This repository contains the Terraform module for pre-written policies, designed to streamline the onboarding of pre-written Sentinel policies into your Terraform environment. This module enables the creation of `Policy Sets` for pre-written Sentinel policies for AWS Foundations Benchmark, ensuring consistent compliance and governance across your Terraform workflows.

### Steps to run the configuration

- Set the `TFE_TOKEN` environment to TFC/TFE's API token. This can either be an user token or organization scoped token.
- Identify the name of the TFE/TFC organization where the policy set will get created.
- By default, the module supports eight policy repositories, which are hosted in the following locations.
    - [policy-library-CIS-Policy-Set-for-AWS-Terraform](https://github.com/hashicorp/policy-library-CIS-Policy-Set-for-AWS-Terraform)
    - [policy-library-FSBP-Policy-Set-for-AWS-Terraform](https://github.com/hashicorp/policy-library-FSBP-Policy-Set-for-AWS-Terraform/)
- Users have the flexibility to modify or extend the default policy repositories. You can specify custom policy repositories using the optional `policy_github_repository` parameter. This parameter accepts a list of GitHub repository names, but **note that the repositories must be hosted under the HashiCorp organization**.
- Use the below mentioned inputs to invoke the module for deploying the policy set to TFE/TFC.
```hcl
module "policy_set" {
  source = "./pre-written-policy"

  name                                 = "<your-policy-set>"
  tfe_organization                     = "<your-tfe-org>"
  policy_set_workspace_names           = ["target_workspace_1"]
}
```
- Run `terraform plan` to view the plan.
- Run `terraform apply` to apply the changes.
- After successful creation, you should see Sentinel policies getting evaluated in every run of every workspace where the policy set is scoped to.

## Authors

HashiCorp Engineering Team.

## License

Business Source License 1.1. See LICENSE for full details.
