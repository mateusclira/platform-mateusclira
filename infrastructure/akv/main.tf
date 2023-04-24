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
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Create",
      "Delete",
      "Get",
      "Purge",
      "Recover",
      "Update",
      "GetRotationPolicy",
      "SetRotationPolicy"
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
      "Create",
      "Delete",
      "Get",
      "Purge",
      "Recover",
      "Update",
      "GetRotationPolicy",
      "SetRotationPolicy"
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

resource "azuread_application" "argo_app" {
  display_name = "argo-${var.cname}"
  owners       = [data.azurerm_client_config.current.object_id]
}

resource "azuread_service_principal" "argo_sp" {
  application_id               = azuread_application.argo_app.application_id
  app_role_assignment_required = false
  owners                       = [data.azurerm_client_config.current.object_id]
}

resource "azurerm_role_assignment" "argo" {
  scope                = data.azurerm_subscription.primary.id
  role_definition_name = "Azure Kubernetes Service RBAC Cluster Admin"
  principal_id         = azuread_service_principal.argo_sp.object_id
}

resource "azurerm_key_vault_key" "kms" {
  name         = "kms-${var.cname}"
  key_vault_id = azurerm_key_vault.main.id
  key_type     = "RSA"
  key_size     = 2048

  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey"
  ]

  rotation_policy {
    automatic {
      time_before_expiry = "P30D"
    }

    expire_after         = "P70Y"
    notify_before_expiry = "P29D"
  }

}