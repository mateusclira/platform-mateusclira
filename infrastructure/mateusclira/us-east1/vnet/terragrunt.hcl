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
  resource_group_name = "platform-mateusclira"

  vnet_name = "${local.account.locals.account_name}-vnet"

  address_space   = "10.0.0.0/16"
  subnet_prefixes = ["10.0.0.0/20", "10.0.32.0/20", "10.0.64.0/20"]
  subnet_names    = ["subnet1", "subnet2", "subnet3"]

  subnet_service_endpoints = {
    "subnet1" = ["Microsoft.Storage", "Microsoft.Sql", "Microsoft.KeyVault", "Microsoft.ContainerRegistry"]
    "subnet2" = ["Microsoft.Storage", "Microsoft.Sql", "Microsoft.KeyVault", "Microsoft.ContainerRegistry"]
    "subnet3" = ["Microsoft.Storage", "Microsoft.Sql", "Microsoft.KeyVault", "Microsoft.ContainerRegistry"]
  }
}
