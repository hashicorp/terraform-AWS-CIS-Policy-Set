## Terraform module to create policy sets for Pre-written Sentinel policies

This repository hosts a terraform module [pre-written-policy](./pre-written-policy/) to create Policy sets for Pre-written policies written in Sentinel. Once applied, all runs within specific/all workspaces will be subjected to policy evaluations between the `plan` and `apply` phases.

### Steps to run the configuration

- Set the `TFE_TOKEN` environment to TFC/TFE's API token. This can either be an user token or organization scoped token.
- Identify the name of the TFE/TFC organization where the policy set will get created.
- By default, the module supports eight policy repositories, which are hosted in the following locations.
    - [policy-library-cis-aws-cloudtrail-terraform](https://github.com/hashicorp/policy-library-cis-aws-cloudtrail-terraform)
    - [policy-library-cis-aws-ec2-terraform](https://github.com/hashicorp/policy-library-cis-aws-ec2-terraform)
    - [policy-library-cis-aws-efs-terraform](https://github.com/hashicorp/policy-library-cis-aws-efs-terraform)
    - [policy-library-cis-aws-iam-terraform](https://github.com/hashicorp/policy-library-cis-aws-iam-terraform)
    - [policy-library-cis-aws-rds-terraform](https://github.com/hashicorp/policy-library-cis-aws-rds-terraform)
    - [policy-library-cis-aws-s3-terraform](https://github.com/hashicorp/policy-library-cis-aws-s3-terraform)
    - [policy-library-cis-aws-kms-terraform](https://github.com/hashicorp/policy-library-cis-aws-kms-terraform)
    - [policy-library-cis-aws-vpc-terraform](https://github.com/hashicorp/policy-library-cis-aws-vpc-terraform)
- Users have the flexibility to modify or extend the default policy repositories. You can specify custom policy repositories using the optional `policy_github_repository` parameter. This parameter accepts a list of GitHub repository names, but **note that the repositories must be hosted under the HashiCorp organization**.
- Use the below mentioned inputs to invoke the module for deploying the policy set to TFE/TFC.
```hcl
module "cis_v1-2-0_policies" {
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