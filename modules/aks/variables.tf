variable "clusters" {
  description = "Map of AKS clusters to create"
  type = map(object({
    resource_group_name = string
    location            = string
    dns_prefix          = string
    kubernetes_version  = optional(string)
    sku_tier            = optional(string, "Free")
    tags                = optional(map(string), {})
    
    default_node_pool = object({
      name                = string
      node_count          = optional(number, 1)
      vm_size             = optional(string, "Standard_DS2_v2")
      enable_auto_scaling = optional(bool, false)
      min_count           = optional(number)
      max_count           = optional(number)
      type                = optional(string, "VirtualMachineScaleSets")
      vnet_subnet_id      = optional(string)
    })

    additional_node_pools = optional(map(object({
      vm_size             = string
      node_count          = optional(number, 1)
      enable_auto_scaling = optional(bool, false)
      min_count           = optional(number)
      max_count           = optional(number)
      vnet_subnet_id      = optional(string)
      mode                = optional(string, "User")
    })), {})

    network_profile = optional(object({
      network_plugin    = optional(string, "kubenet")
      network_policy    = optional(string)
      load_balancer_sku = optional(string, "standard")
      service_cidr      = optional(string)
      dns_service_ip    = optional(string)
      docker_bridge_cidr = optional(string)
    }))

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
