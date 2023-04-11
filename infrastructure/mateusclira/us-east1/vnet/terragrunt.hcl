terraform {
  source = "tfr:///Azure/network/azurerm//?version=5.2.0"
}

include {
  path = find_in_parent_folders()
}

locals {
  location   = read_terragrunt_config(find_in_parent_folders("location.hcl"))
  account    = read_terragrunt_config(find_in_parent_folders("account.hcl"))
}

inputs = {
  resource_group_name = "mateusclira-tfstate"

  vnet_name = "${local.account.locals.account_name}-vnet"

  address_spaces      = ["10.0.0.0/16"]
  subnet_prefixes     = ["10.0.1.0/20", "10.0.2.0/20", "10.0.3.0/20"]
  subnet_names        = ["subnet1", "subnet2", "subnet3"]

  subnet_service_endpoints = {
    "subnet1" = ["Microsoft.Storage", "Microsoft.Sql", "Microsoft.KeyVault", "Microsoft.Aks"]
    "subnet2" = ["Microsoft.Storage", "Microsoft.Sql", "Microsoft.KeyVault", "Microsoft.Aks"]
    "subnet3" = ["Microsoft.Storage", "Microsoft.Sql", "Microsoft.KeyVault", "Microsoft.Aks"]
  }
}
