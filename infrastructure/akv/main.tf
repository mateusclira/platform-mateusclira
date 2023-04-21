data "azurerm_client_config" "current" {}
data "azurerm_kubernetes_cluster" "current" {
  name                = "k8s-${var.cname}"
  resource_group_name = "platform-${var.cname}"
}

resource "azurerm_key_vault" "main" {
  name                        = "kv-${var.cname}"
  location                    = var.region
  resource_group_name         = "platform-${var.cname}"
  enabled_for_disk_encryption = true
  tenant_id                   = "4565bb37-9773-4d2e-80b6-398babdc2a33"
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = "4565bb37-9773-4d2e-80b6-398babdc2a33"
    object_id = data.azurerm_kubernetes_cluster.current.identity.0.principal_id

    key_permissions = [
      "Get",
    ]

    secret_permissions = [
      "Get",
      "Set",
      "List"
    ]

    storage_permissions = [
      "Get",
    ]
  }

    access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get"
    ]

    secret_permissions = [
      "Get",
      "Set",
      "List"
    ]

    storage_permissions = [
      "Get"
    ]
  }
}
