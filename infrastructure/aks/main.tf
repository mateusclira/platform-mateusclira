resource "azurerm_kubernetes_cluster" "main" {
  name                = "k8s-${var.cname}"
  location            = var.region
  resource_group_name = "platform-${var.cname}"
  dns_prefix          = "k8s-${var.cname}"

  default_node_pool {
    name       = "default"
    node_count = "2"
    vm_size    = "Standard_B2s"
  }
  identity {
    type = "SystemAssigned"
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
  key_vault_id = var.kv_id
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