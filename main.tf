terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws",
      version = "5.49.0"
    }
  }

  backend "s3" {
    bucket = "rocketseat-iac-state"
    key    = "state/terraform.tfstate"
    region = "us-east-2"
  }
}

provider "aws" {
  region = "us-east-2"
}

resource "aws_s3_bucket" "rocketseat-iac-state" {
  bucket        = "rocketseat-iac-state"
  force_destroy = true

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    "IAC" = "True"
  }
}

resource "aws_s3_bucket_versioning" "rocketseat-iac-state" {
  bucket = "rocketseat-iac-state"

  versioning_configuration {
    status = "Enabled"
  }
}