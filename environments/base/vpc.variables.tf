### Global Variables

variable "aws_access_key" {
  description = "AWS TF Access Key"
  default     = ""
}

variable "aws_secret_key" {
  description = "AWS TF Secret Key"
  default     = ""
}

variable "aws_region" {
  description = "Default Region"
  default     = ""
}

variable "name" {
  default = ""
}

variable "namespace" {
  default = ""
}

variable "stack" {
  default = ""
}

### VPC Specific

variable "az_list" {
  description = ""
  type        = list(string)
  default     = []
}

variable "address_space" {
  description = "Default VPC Address Space"
  default     = ""
}

variable "subnet_private_list" {
  description = ""
  type        = list(string)
  default     = []
}

variable "subnet_public_list" {
  description = ""
  type        = list(string)
  default     = []
}


variable "domain_name_servers" {
  description = "Internal AWS Provided DNS Servers to be used by DHCP"
  default     = "" // for example: AmazonProvidedDNS
}

variable "domain_name" {
  description = "Domain Suffix to be appended via DHCP"
  default     = "" // for example: alkermes.com, aws.alkermes.com
}
