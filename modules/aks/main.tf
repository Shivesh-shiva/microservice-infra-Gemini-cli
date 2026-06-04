resource "azurerm_kubernetes_cluster" "this" {
  for_each = var.clusters

  name                = each.key
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  dns_prefix          = each.value.dns_prefix
  kubernetes_version  = each.value.kubernetes_version
  sku_tier            = each.value.sku_tier
  tags                = each.value.tags

  default_node_pool {
    name                = each.value.default_node_pool.name
    node_count          = each.value.default_node_pool.node_count
    vm_size             = each.value.default_node_pool.vm_size
    enable_auto_scaling = each.value.default_node_pool.enable_auto_scaling
    min_count           = each.value.default_node_pool.min_count
    max_count           = each.value.default_node_pool.max_count
    type                = each.value.default_node_pool.type
    vnet_subnet_id      = each.value.default_node_pool.vnet_subnet_id
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
      service_cidr      = network_profile.value.service_cidr
      dns_service_ip    = network_profile.value.dns_service_ip
      docker_bridge_cidr = network_profile.value.docker_bridge_cidr
    }
  }

  dynamic "azure_active_directory_role_based_access_control" {
    for_each = each.value.azure_active_directory_role_based_access_control != null ? [each.value.azure_active_directory_role_based_access_control] : []
    content {
      managed                = azure_active_directory_role_based_access_control.value.managed
      azure_rbac_enabled     = azure_active_directory_role_based_access_control.value.azure_rbac_enabled
      admin_group_object_ids = azure_active_directory_role_based_access_control.value.admin_group_object_ids
    }
  }
}

locals {
  # Flattening the nested map of additional node pools for each cluster
  # Format: { "cluster_name.pool_name" => { cluster_key, pool_key, pool_config } }
  additional_node_pools = flatten([
    for cluster_key, cluster_val in var.clusters : [
      for pool_key, pool_val in cluster_val.additional_node_pools : {
        cluster_key = cluster_key
        pool_key    = pool_key
        config      = pool_val
      }
    ]
  ])
}

resource "azurerm_kubernetes_cluster_node_pool" "this" {
  for_each = {
    for pool in local.additional_node_pools : "${pool.cluster_key}.${pool.pool_key}" => pool
  }

  name                  = each.value.pool_key
  kubernetes_cluster_id = azurerm_kubernetes_cluster.this[each.value.cluster_key].id
  vm_size               = each.value.config.vm_size
  node_count            = each.value.config.node_count
  enable_auto_scaling   = each.value.config.enable_auto_scaling
  min_count             = each.value.config.min_count
  max_count             = each.value.config.max_count
  vnet_subnet_id        = each.value.config.vnet_subnet_id
  mode                  = each.value.config.mode
}
