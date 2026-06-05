variable "registries" {
  description = "Map of Container Registries to create"
  type = map(object({
    resource_group_name = string
    location            = string
    sku                           = optional(string, "Premium")
    admin_enabled                 = optional(bool, false)
    public_network_access_enabled = optional(bool, false)
    tags                          = optional(map(string), {})
    georeplications = optional(list(object({
      location                  = string
      regional_endpoint_enabled = optional(bool, false)
      zone_redundancy_enabled   = optional(bool, false)
      tags                      = optional(map(string), {})
    })), [])
    network_rule_set = optional(object({
      default_action = optional(string, "Deny")
      ip_rule = optional(list(object({
        action   = string
        ip_range = string
      })), [])
    }))
    retention_policy = optional(object({
      days    = optional(number, 7)
      enabled = optional(bool, true)
    }), { days = 7, enabled = true })
    trust_policy = optional(object({
      enabled = optional(bool, true)
    }), { enabled = true })
    data_endpoint_enabled = optional(bool, true)
    quarantine_policy_enabled = optional(bool, false)

  }))
}
