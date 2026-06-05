resource_groups = {
  "rg-microservice-dev" = {
    location = "East US"
    tags     = { environment = "dev", owner = "platform-team" }
  }
}

registries = {
  "acrmicroservicedev" = {
    location            = "East US"
    resource_group_name = "rg-microservice-dev"
    sku                 = "Standard"
    admin_enabled       = true
    tags                = { environment = "dev" }
  }
}

clusters = {
  "aks-microservice-dev" = {
    location            = "East US"
    resource_group_name = "rg-microservice-dev"
    dns_prefix          = "microdev"

    default_node_pool = {
      name       = "system"
      node_count = 1
      vm_size    = "Standard_B2s"
    }

    additional_node_pools = {
      "apppool" = {
        vm_size    = "Standard_B2s"
        node_count = 1
      }
    }

    identity = {
      type = "SystemAssigned"
    }

    network_profile = {
      network_plugin = "azure"
    }

    tags = { environment = "dev" }
  }
}
