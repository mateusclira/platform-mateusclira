data "azurerm_client_config" "current" {}
data "azurerm_subscription" "primary" {}
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

   access_policy {
    tenant_id = "4565bb37-9773-4d2e-80b6-398babdc2a33"
    object_id = azurerm_role_assignment.argo.principal_id

    key_permissions = [
      "Get",
    ]

    secret_permissions = [
      "Get",
      "Set",
      "List",
      "Delete"
    ]

    storage_permissions = [
      "Get",
    ]
  }
}

resource "random_password" "k8s" {
  length           = 16
  special          = true
  override_special = "_%@"
}

resource "azurerm_key_vault_secret" "k8s" {
  name         = "k8s-${var.cname}" 
  value        = random_password.k8s.result
  key_vault_id = azurerm_key_vault.main.id
}

resource "azurerm_role_assignment" "argo" {
  scope                = data.azurerm_subscription.primary.id
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.argo_sp.object_id
}

resource "azuread_application" "argo_app" {
  display_name = "argo-${var.cname}"
  owners       = [data.azurerm_client_config.current.object_id]
}

resource "azuread_service_principal" "argo_sp" {
  application_id               = azuread_application.argo_app.application_id
  app_role_assignment_required = false
  owners                       = [data.azurerm_client_config.current.object_id]
}
