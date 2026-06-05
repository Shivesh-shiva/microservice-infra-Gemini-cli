variable "clusters" {
  description = "Map of AKS clusters to create"
  type = map(object({
    resource_group_name = string
    location            = string
    dns_prefix          = string
    kubernetes_version              = optional(string)
    sku_tier                        = optional(string, "Standard")
    api_server_authorized_ip_ranges = optional(list(string), [])
    private_cluster_enabled         = optional(bool, true)
    azure_policy_enabled            = optional(bool, true)
    local_account_disabled          = optional(bool, true)
    automatic_channel_upgrade       = optional(string, "patch")
    tags                            = optional(map(string), {})

    default_node_pool = object({
      name                   = string
      node_count             = optional(number, 3)
      vm_size                = optional(string, "Standard_D2s_v3")
      enable_auto_scaling    = optional(bool, true)
      min_count              = optional(number, 3)
      max_count              = optional(number, 5)
      type                   = optional(string, "VirtualMachineScaleSets")
      vnet_subnet_id         = optional(string)
      max_pods               = optional(number, 50)
      os_disk_type           = optional(string, "Ephemeral")
      enable_host_encryption = optional(bool, true)
    })

    additional_node_pools = optional(map(object({
      vm_size                = string
      node_count             = optional(number, 1)
      enable_auto_scaling    = optional(bool, false)
      min_count              = optional(number)
      max_count              = optional(number)
      vnet_subnet_id         = optional(string)
      mode                   = optional(string, "User")
      max_pods               = optional(number, 50)
      os_disk_type           = optional(string, "Ephemeral")
      enable_host_encryption = optional(bool, true)
    })), {})

    network_profile = optional(object({
      network_plugin     = optional(string, "azure")
      network_policy     = optional(string, "azure")
      load_balancer_sku  = optional(string, "standard")
      service_cidr       = optional(string)
      dns_service_ip     = optional(string)
      docker_bridge_cidr = optional(string)
    }))

    oms_agent = optional(object({
      log_analytics_workspace_id = string
    }))

    key_vault_secrets_provider = optional(object({
      secret_rotation_enabled = optional(bool, true)
    }), { secret_rotation_enabled = true })


    identity = optional(object({
      type = optional(string, "SystemAssigned")
    }), { type = "SystemAssigned" })

    azure_active_directory_role_based_access_control = optional(object({
      managed                = optional(bool, true)
      azure_rbac_enabled     = optional(bool, true)
      admin_group_object_ids = optional(list(string), [])
    }))
  }))
}
