terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.110.0"
    }

    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }

    google = {
      source  = "hashicorp/google"
      version = "5.31.1"
    }
  }

  backend "azurerm" {
    resource_group_name  = "terraform-backend"
    storage_account_name = "terradata"
    container_name       = "cross-cloud-access-examples"
    key                  = "azure-job-to-gcp.tfstate"
    subscription_id      = "a41dafcb-2936-42b5-8796-d761f0cbe41e"
  }

  required_version = "1.8.4"
}

provider "azurerm" {
  features {}
  subscription_id = var.azure_subscription_id
}

provider "docker" {
  registry_auth {
    address  = local.image_registry
    username = var.docker_hub_username
    password = var.docker_hub_access_token
  }
}

provider "google" {
  project        = var.google_project_id
  region         = var.google_cloud_region
  default_labels = local.tags
}
