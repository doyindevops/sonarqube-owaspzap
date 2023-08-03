terraform {
  backend "s3" {
    bucket = "infra-bucket-10"
    key = "infra/state.tfstate"
    region = "eu-west-3"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.3"
    }
  }
}
