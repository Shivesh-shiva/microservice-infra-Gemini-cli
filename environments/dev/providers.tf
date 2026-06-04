terraform {
  required_version = ">= 1.3.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }

  # Uncomment and configure the backend when the storage account is ready
  # backend "azurerm" {
  #   resource_group_name  = "rg-terraform-mgmt"
  #   storage_account_name = "sttfstate"
  #   container_name       = "tfstate"
  #   key                  = "dev.terraform.tfstate"
  #   use_oidc             = true
  # }
}

provider "azurerm" {
  features {}
  use_oidc = true
}
