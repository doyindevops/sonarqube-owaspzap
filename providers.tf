terraform {
  backend "s3"{
    bucket = "infra-bucket-devsecops"
    key = "infra/state.tfstate"
    region = "eu-west-3"
    role = "aws_iam_role.github-runner-role.name"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.1.0"
    }
  }
}
