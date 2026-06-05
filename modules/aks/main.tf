resource "azurerm_kubernetes_cluster" "this" {
  for_each = var.clusters

  name                = each.key
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  dns_prefix          = each.value.dns_prefix
  kubernetes_version  = each.value.kubernetes_version

  default_node_pool {
    name           = each.value.default_node_pool.name
    node_count     = each.value.default_node_pool.node_count
    vm_size        = each.value.default_node_pool.vm_size
    zones          = each.value.default_node_pool.zones
    vnet_subnet_id = each.value.default_node_pool.vnet_subnet_id
  }

  dynamic "identity" {
    for_each = each.value.identity != null ? [each.value.identity] : []
    content {
      type = identity.value.type
    }
  }

  dynamic "network_profile" {
    for_each = each.value.network_profile != null ? [each.value.network_profile] : []
    content {
      network_plugin    = network_profile.value.network_plugin
      network_policy    = network_profile.value.network_policy
      load_balancer_sku = network_profile.value.load_balancer_sku
    }
  }

  dynamic "key_vault_secrets_provider" {
    for_each = each.value.key_vault_secrets_provider_enabled ? [1] : []
    content {
      secret_rotation_enabled = true
    }
  }

  dynamic "ingress_application_gateway" {
    for_each = each.value.ingress_application_gateway_enabled ? [1] : []
    content {
      gateway_id = each.value.ingress_application_gateway_id
    }
  }

  tags = each.value.tags
}

resource "azurerm_kubernetes_cluster_node_pool" "additional" {
  # Flattening the additional node pools across all clusters
  for_each = {
    for pair in flatten([
      for cluster_name, cluster in var.clusters : [
        for pool_name, pool in cluster.additional_node_pools : {
          cluster_name = cluster_name
          pool_name    = pool_name
          config       = pool
        }
      ]
    ]) : "${pair.cluster_name}-${pair.pool_name}" => pair
  }

  name                  = each.value.pool_name
  kubernetes_cluster_id = azurerm_kubernetes_cluster.this[each.value.cluster_name].id
  vm_size               = each.value.config.vm_size
  node_count            = each.value.config.node_count
  zones                 = each.value.config.zones
  vnet_subnet_id        = each.value.config.vnet_subnet_id
}
