terraform {
  backend "s3" {
    bucket = "clientxyz-terraform-states"
    key    = "k8s-infra/aws-k8s-infra-us-east-2-dev"
    region = "us-east-2"
  }
}