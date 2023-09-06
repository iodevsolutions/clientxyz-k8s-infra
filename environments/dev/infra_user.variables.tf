### Infra User Specific

variable "infra_user_policy_name" {
  description = "IAM User Policy Name for Infra User - DEV"
  default     = "ClientXYZInfraUserDevPolicy"
}

variable "infra_user_group_name" {
  description = "IAM User Group Name Infra Users"
  default     = "clientxyz_infra_user_group_dev"
}

variable "infra_user_name" {
  description = "IAM User Name for Infra User - DEV"
  default     = "clientxyz_infra_dev"
}

