locals {
  account      = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  location     = read_terragrunt_config(find_in_parent_folders("location.hcl"))
  azure_region = local.location.locals.location
  account_name = local.account.locals.account_name
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "azurerm" {
  features {}
}
EOF
}

remote_state {
  backend = "azurerm"
  config = {
    storage_account_name   = "mateuscliratfstate"
    key                    = "dhmfJ5huYQIB5WK2RJ8JL7NhE7UUa+DWsnqWdrY8tzoioz2xbnda79H3UZgtvjmCU/PEWvHcf+A9+AStP0TDxw=="
    container_name         = "mateuscliratfstatect"
    resource_group_name    = "mateusclira-tfstate"
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}
