terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws",
      version = "~> 3.27"
    }
  }
  backend "s3" {
    bucket = "aravind-terraform-bucket"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
  required_version = ">= 0.14.9"
}