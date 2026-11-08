terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 6.0"
    }
  }

  backend "s3" {
    bucket = "devops-mini-app"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
  required_version = ">= 1.11"
}