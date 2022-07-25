terraform {
  required_version = ">= 1.1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
  }
  cloud {
    organization = "terraformtestlabs"
    workspaces {
      name = "terraformtestlabs"
    }
  }
}

provider "azurerm" {
  features {}
}

module "windows_virtual_network" {
  source = "./modules/windows_virtual_network"
}

module "azure_firewall" {
  source = "./modules/azure_firewall"
}

module "internal_central_hub" {
  source = "./modules/internal_central_hub"
}