output "cluster_ids" {
  value = { for k, v in azurerm_kubernetes_cluster.this : k => v.id }
}

output "cluster_fqdns" {
  value = { for k, v in azurerm_kubernetes_cluster.this : k => v.fqdn }
}

output "kube_configs" {
  value     = { for k, v in azurerm_kubernetes_cluster.this : k => v.kube_config_raw }
  sensitive = true
}
