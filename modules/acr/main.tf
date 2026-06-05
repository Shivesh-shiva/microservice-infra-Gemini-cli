resource "azurerm_container_registry" "this" {
  # Azure Container Registry resource managed by the module
  for_each = var.registries

  name                = each.key
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  sku                 = each.value.sku
  admin_enabled       = each.value.admin_enabled

  dynamic "georeplications" {
    for_each = each.value.georeplications
    content {
      location                = georeplications.value.location
      zone_redundancy_enabled = georeplications.value.zone_redundancy_enabled
      tags                    = georeplications.value.tags
    }
  }

  tags = each.value.tags
}
