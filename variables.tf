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
  default     = [ "policy-library-CIS-Policy-Set-for-AWS-CloudTrail-Terraform", "policy-library-CIS-Policy-Set-for-AWS-EC2-Terraform", "policy-library-CIS-Policy-Set-for-AWS-EFS-Terraform", "policy-library-CIS-Policy-Set-for-AWS-IAM-Terraform", "policy-library-CIS-Policy-Set-for-AWS-KMS-Terraform", "policy-library-CIS-Policy-Set-for-AWS-S3-Terraform", "policy-library-CIS-Policy-Set-for-AWS-VPC-Terraform", "policy-library-CIS-Policy-Set-for-AWS-RDS-Terraform" ] 
}