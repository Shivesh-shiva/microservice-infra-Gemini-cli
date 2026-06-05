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
