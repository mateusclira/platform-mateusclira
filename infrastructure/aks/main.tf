resource "azurerm_kubernetes_cluster" "main" {
  name                = "k8s-${var.cname}"
  location            = var.region
  resource_group_name = "platform-${var.cname}"
  dns_prefix          = "k8s-${var.cname}"

  default_node_pool {
    name       = "default"
    node_count = "1"
    vm_size    = "Standard_B2s"
  }
  identity {
    type = "SystemAssigned"
  }
}
