resource "local_file" "kubeconfig" {
  depends_on   = [azurerm_kubernetes_cluster.main]
  filename     = "kubeconfig"
  content      = azurerm_kubernetes_cluster.main.kube_config_raw
}

output "k8s_object_id" {
  value = azurerm_kubernetes_cluster.main.identity[0].principal_id
}