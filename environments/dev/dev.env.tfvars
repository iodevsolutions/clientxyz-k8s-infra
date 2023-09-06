### Global Variables
aws_region = "us-east-2"
stack      = "dev"

### IAM Specific

ec2_role_name        = "ClientXYZDevEC2Role"
ec2_role_description = "ClientXYZ DEV EC2 Server Role"
ec2_policy_doc_name  = "ClientXYZDevEC2Policy"
ec2_role_tags = {
  Name        = "ClientXYZDevEC2Role",
  Description = "ClientXYZ DEV EC2 Server Role",
  DeployedBy  = "Teraform"
  Stack       = "dev"
}
ec2_profile_name = "ClientXYZDevEC2Profile"

### VPC Specific
name      = "k8s"
namespace = "clientxyz"

az_list             = ["us-east-2a", "us-east-2b"]
address_space       = "25.1.0.0/16"
subnet_private_list = ["25.1.64.0/20", "25.1.80.0/20"]
subnet_public_list  = ["25.1.0.0/20", "25.1.16.0/20"]

domain_name_servers = ["AmazonProvidedDNS"]
domain_name         = "us-east-2.compute.internal"
