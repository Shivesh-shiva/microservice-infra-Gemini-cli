variable "resource_groups" {
  # Map of resource groups to be managed by the module
  description = "A map of resource groups to create"
  type = map(object({
    location = string
    tags     = optional(map(string), {})
  }))
}

variable "registries" {
  description = "A map of Azure Container Registries to create"
  type = map(object({
    location            = string
    resource_group_name = string
    sku                 = optional(string, "Standard")
    admin_enabled       = optional(bool, false)
    georeplications = optional(list(object({
      location                = string
      zone_redundancy_enabled = optional(bool, false)
      tags                    = optional(map(string), {})
    })), [])
    tags = optional(map(string), {})
  }))
}

variable "clusters" {
  description = "A map of AKS clusters to create"
  type = map(object({
    location            = string
    resource_group_name = string
    dns_prefix          = string
    kubernetes_version  = optional(string)

    default_node_pool = object({
      name           = string
      node_count     = number
      vm_size        = string
      zones          = optional(list(string))
      vnet_subnet_id = optional(string)
    })

    additional_node_pools = optional(map(object({
      vm_size        = string
      node_count     = number
      zones          = optional(list(string))
      vnet_subnet_id = optional(string)
    })), {})

    identity = optional(object({
      type = string
    }), { type = "SystemAssigned" })

    network_profile = optional(object({
      network_plugin    = optional(string, "azure")
      network_policy    = optional(string)
      load_balancer_sku = optional(string, "standard")
    }))

    key_vault_secrets_provider_enabled  = optional(bool, false)
    ingress_application_gateway_enabled = optional(bool, false)
    ingress_application_gateway_id      = optional(string)

    tags = optional(map(string), {})
  }))
}
