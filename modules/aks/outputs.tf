output "cluster_ids" {
  value = { for k, v in azurerm_kubernetes_cluster.this : k => v.id }
}

output "kube_configs" {
  value     = { for k, v in azurerm_kubernetes_cluster.this : k => v.kube_config_raw }
  sensitive = true
}
