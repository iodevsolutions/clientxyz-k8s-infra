### Provider Definition ###

provider "aws" {
  region = var.aws_region
}

### Data Sources - This creates a data source for remote state to be used to reference downstream outputs (i.e., from vpc, security, etc)


### Resources and Modules

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.1"

  name = "${var.namespace}-${var.name}-${var.stack}-use2-vpc"
  cidr = var.address_space

  azs                          = var.az_list
  private_subnets              = var.subnet_private_list
  private_subnet_suffix        = "sn-private"
  public_subnets               = var.subnet_public_list
  public_subnet_suffix         = "sn-public"
  enable_nat_gateway           = true
  enable_vpn_gateway           = false
  create_database_subnet_group = false

  // DNS and DHCP Options
  enable_dns_hostnames             = true
  enable_dns_support               = true
  dhcp_options_domain_name         = var.domain_name
  dhcp_options_domain_name_servers = var.domain_name_servers
  enable_dhcp_options              = true

  // Tagging 
  tags = {
    DeployedBy = "Terraform",
    Stack      = var.stack
  }
}


### Outputs

output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = module.vpc.private_subnets
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.vpc.public_subnets
}
