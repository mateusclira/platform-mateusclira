terraform {
  backend "azurerm" {
      resource_group_name  = "mateusclira-tfstate"
      storage_account_name = "mateuscliratfstate"
      container_name       = "mateuscliratfstatect"
      key                  = "terraform.tfstate"
  }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=2.46.0"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = ">=2.18.1"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "main" {
  name     = "platform-${var.cname}"
  location = var.region
}

module "aks" {
  source = "./aks"
  cname  = var.cname
  region = var.region

  depends_on = [
    azurerm_resource_group.main
  ]
}

module "akv" {
  source = "./akv"
  cname  = var.cname
  region = var.region

  k8s_object_id = module.aks.id

  depends_on = [
    azurerm_resource_group.main,
    module.aks
  ]
}
