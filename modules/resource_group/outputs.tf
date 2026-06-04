output "resource_group_names" {
  value = { for k, v in azurerm_resource_group.this : k => v.name }
}

output "resource_group_locations" {
  value = { for k, v in azurerm_resource_group.this : k => v.location }
}

output "resource_groups" {
  value = azurerm_resource_group.this
}
