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
    object_id = var.k8s_object_id

    key_permissions = [
      "Get",
    ]

    secret_permissions = [
      "Get",
    ]

    storage_permissions = [
      "Get",
    ]
  }
}

resource "random_string" "main" {
  length  = 12
  special = true
  upper   = true
}

resource "azurerm_key_vault_secret" "k8s" {
  name         = "k8s-secret"
  value        = "${random_string.main.result}"
  key_vault_id = azurerm_key_vault.main.id
}

resource "kubernetes_secret" "argoSecret" {
  metadata {
    name = "argo-secret"
  }
  data = {
    "argo-secret-name" = base64encode(azurerm_key_vault_secret.k8s.value)
  }
  type = "Opaque"
}
