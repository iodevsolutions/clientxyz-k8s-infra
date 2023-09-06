# Provider Definition 

### Terraform Remote State - This creates a data source for remote state to be used to reference downstream outputs (i.e., from vpc, security, etc)

data "aws_iam_policy" "aws_ssm_inst" {
  name = "AmazonSSMManagedInstanceCore"
}

### Resources or Modules

//  EC2 Policy Doc
data "aws_iam_policy_document" "ec2_assume_policy_doc" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

// Create EC2 Role
resource "aws_iam_role" "ec2_role" {
  name               = var.ec2_role_name
  description        = var.ec2_role_description
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_policy_doc.json
  tags               = var.ec2_role_tags
}

// Attach AWS Managed policies
resource "aws_iam_role_policy_attachment" "ec2_attach_aws_ssm_inst" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = data.aws_iam_policy.aws_ssm_inst.arn
}

// Create EC2 IAM Instance profile
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = var.ec2_profile_name
  role = aws_iam_role.ec2_role.name
}


### Outputs

// EC2 Role
output "ec2_role_id" {
  value = aws_iam_role.ec2_role.id
}

output "ec2_role_name" {
  value = aws_iam_role.ec2_role.name
}

output "ec2_role_arn" {
  value = aws_iam_role.ec2_role.arn
}

// EC2 Instance Profile
output "ec2_profile_name" {
  value = aws_iam_instance_profile.ec2_instance_profile.name
}

