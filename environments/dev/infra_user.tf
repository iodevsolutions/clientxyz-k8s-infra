### Resources or Modules

data "aws_iam_policy_document" "infra_user_policy_doc" {

  statement {
    sid    = "TerraformStateList"
    effect = "Allow"
    actions = [
      "s3:ListBucket"
    ]
    resources = ["arn:aws:s3:::clientxyz-terraform-states"]
  }

  statement {
    sid    = "TerraformStateWrite"
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject"
    ]
    resources = [
      "arn:aws:s3:::clientxyz-terraform-states/k8s-compute/aws-k8s-compute-us-east-2-dev"
    ]
  }

  statement {
    sid    = "TerraformRemoteState"
    effect = "Allow"
    actions = [
      "s3:GetObject"
    ]
    resources = [
      "arn:aws:s3:::clientxyz-terraform-states/k8s-infra/aws-k8s-infra-us-east-2-dev"
    ]
  }

  statement {
    sid    = "NonResourceBasedReadOnlyPermissions"
    effect = "Allow"
    actions = [
      "ec2:Describe*",
      "ec2:CreateKeyPair",
      "ec2:CreateSecurityGroup",
      "iam:GetInstanceProfile",
      "iam:ListInstanceProfiles",
      "kms:DescribeKey"
    ]
    resources = [
      "*"
    ]
  }

  statement {
    sid    = "IAMPassroleToInstance"
    effect = "Allow"
    actions = [
      "iam:PassRole"
    ]
    resources = [
      "arn:aws:iam::926667236670:role/${aws_iam_role.ec2_role.name}"
    ]
  }

  statement {
    sid    = "AllowInstanceActions"
    effect = "Allow"
    actions = [
      "ec2:RebootInstances",
      "ec2:StopInstances",
      "ec2:TerminateInstances",
      "ec2:StartInstances",
      "ec2:AttachVolume",
      "ec2:DetachVolume",
      "ec2:CreateTags"
    ]
    resources = [
      "arn:aws:ec2:us-east-2:926667236670:instance/*"
    ]
    condition {
      test     = "StringEquals"
      variable = "ec2:InstanceProfile"
      values = [
        "arn:aws:iam::926667236670:instance-profile/${aws_iam_instance_profile.ec2_instance_profile.name}"
      ]
    }
  }

  statement {
    sid    = "EC2RunInstances"
    effect = "Allow"
    actions = [
      "ec2:RunInstances"
    ]
    resources = [
      "arn:aws:ec2:us-east-2:926667236670:instance/*"
    ]
    condition {
      test     = "StringEquals"
      variable = "ec2:InstanceProfile"
      values = [
        "arn:aws:iam::926667236670:instance-profile/${aws_iam_instance_profile.ec2_instance_profile.name}"
      ]
    }
  }

  statement {
    sid    = "EC2RunInstancesSubnet"
    effect = "Allow"
    actions = [
      "ec2:RunInstances"
    ]
    resources = [
      "arn:aws:ec2:us-east-2:926667236670:subnet/*"
    ]
    condition {
      test     = "StringEquals"
      variable = "ec2:vpc"
      values = [
        "arn:aws:ec2:us-east-2:926667236670:vpc/${module.vpc.vpc_id}"
      ]
    }
  }

  statement {
    sid    = "RemainingRunInstancePermissions"
    effect = "Allow"
    actions = [
      "ec2:RunInstances"
    ]
    resources = [
      "arn:aws:ec2:us-east-2:926667236670:volume/*",
      "arn:aws:ec2:us-east-2::image/*",
      "arn:aws:ec2:us-east-2::snapshot/*",
      "arn:aws:ec2:us-east-2:926667236670:network-interface/*",
      "arn:aws:ec2:us-east-2:926667236670:key-pair/*",
      "arn:aws:ec2:us-east-2:926667236670:security-group/*"
    ]
  }

  statement {
    sid    = "EC2VpcNonresourceSpecificActions"
    effect = "Allow"
    actions = [
      "ec2:DeleteNetworkAcl",
      "ec2:DeleteNetworkAclEntry",
      "ec2:DeleteRoute",
      "ec2:DeleteRouteTable",
      "ec2:AuthorizeSecurityGroupEgress",
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:RevokeSecurityGroupEgress",
      "ec2:RevokeSecurityGroupIngress",
      "ec2:DeleteSecurityGroup"
    ]
    resources = [
      "*"
    ]
    condition {
      test     = "StringEquals"
      variable = "ec2:vpc"
      values = [
        "arn:aws:ec2:us-east-2:926667236670:vpc/${module.vpc.vpc_id}"
      ]
    }
  }
}

resource "aws_iam_policy" "infra_user_policy" {
  name   = var.infra_user_policy_name
  policy = data.aws_iam_policy_document.infra_user_policy_doc.json
}

// create iam group for infra_user
resource "aws_iam_group" "infra_user_group" {
  name = var.infra_user_group_name
}

resource "aws_iam_group_policy_attachment" "infra_user_policy_attach" {
  group      = aws_iam_group.infra_user_group.name
  policy_arn = aws_iam_policy.infra_user_policy.arn
}

module "infra_user" {
  source  = "Flaconi/iam-user/aws"
  version = "1.0.0"
  name    = var.infra_user_name
  tags = tomap({
    Name       = var.infra_user_name,
    DeployedBy = "Terraform",
    Stack      = var.stack
  })
}

// add infra_user user to group
resource "aws_iam_user_group_membership" "infra_user_add_to_group" {
  user = module.infra_user.iam_user_id

  groups = [
    aws_iam_group.infra_user_group.name
  ]
}


### Outputs

output "access_key" {
  value = module.infra_user.iam_access_key_id
}

output "secret_key" {
  sensitive = true
  value     = module.infra_user.iam_access_key_secret
}

output "user_id" {
  value = module.infra_user.iam_user_id
}

output "user_arn" {
  value = module.infra_user.iam_user_arn
}

