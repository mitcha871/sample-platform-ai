terraform {
  required_version = ">= 1.6.0"

  backend "s3" {
    # These values must be provided during 'tofu init -backend-config=...' 
    # or hardcoded after the bootstrap layer is created.
    # For now, we leave them as placeholders for the user.
    bucket         = "REPLACE_WITH_BOOTSTRAP_BUCKET_NAME"
    key            = "dev/vpc/terraform.tfstate"
    region         = "ap-southeast-2"
    dynamodb_table = "sample-platform-ai-locks"
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "ap-southeast-2"

  default_tags {
    tags = {
      Project     = "SamplePlatformAI"
      Environment = "Dev"
      ManagedBy   = "OpenTofu"
    }
  }
}
