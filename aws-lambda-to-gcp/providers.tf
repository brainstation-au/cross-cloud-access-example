terraform {
  required_providers {
    archive = {
      source  = "hashicorp/archive"
      version = "2.4.2"
    }

    aws = {
      source  = "hashicorp/aws"
      version = "5.52.0"
    }

    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.106.1"
    }

    google = {
      source  = "hashicorp/google"
      version = "5.35.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "terraform-backend"
    storage_account_name = "terradata"
    container_name       = "cross-cloud-access-examples"
    key                  = "aws-lambda-to-gcp.tfstate"
    subscription_id      = "a41dafcb-2936-42b5-8796-d761f0cbe41e"
  }

  required_version = ">= 1.7.4"
}

provider "archive" {}

provider "aws" {
  region = var.aws_region
  default_tags {
    tags = local.tags
  }
}

provider "google" {
  project        = var.google_project_id
  region         = "australia-southeast1"
  default_labels = local.tags
}
