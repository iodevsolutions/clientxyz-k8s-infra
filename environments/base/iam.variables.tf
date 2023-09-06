### Global Variables

### IAM Specific

variable "ec2_role_name" {
  description = "EC2 Role Name"
  default     = ""
}

variable "ec2_role_description" {
  description = "EC2 Role Description"
  default     = ""
}

variable "ec2_policy_doc_name" {
  description = "EC2 Policy Doc Name"
  default     = ""
}

variable "ec2_role_tags" {
  type    = map(any)
  default = {}
}

variable "ec2_profile_name" {
  description = "EC2 Instance Profile Name"
  default     = ""
}

