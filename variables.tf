variable "tfe_organization" {
  description = "The TFE organization where Sentinel based policy sets will be created. These policies will run against all the workspaces present in the organization"
  type        = string
}

variable "policy_set_workspace_names" {
  description = "List of workspace names to scope the policy set to."
  type        = list(string)
}

variable "name" {
  description = "Common prefix prepended to all the resources getting created with this module."
  type        = string
}

variable "policy_github_repository" {
  description = "List of name of the GitHub repositories where the policies reside. These name should not include the GitHub organization."
  type        = list(string)
  default     = [ "policy-library-cis-aws-cloudtrail-terraform", "policy-library-cis-aws-ec2-terraform", "policy-library-cis-aws-efs-terraform", "policy-library-cis-aws-iam-terraform", "policy-library-cis-aws-rds-terraform", "policy-library-cis-aws-s3-terraform", "policy-library-cis-aws-kms-terraform", "policy-library-cis-aws-vpc-terraform" ] 
}