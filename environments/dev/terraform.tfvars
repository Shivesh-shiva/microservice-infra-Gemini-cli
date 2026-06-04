resource_groups = {
  "rg-microservices-dev" = {
    location = "East US"
    tags = {
      environment = "development"
      project     = "microservices"
      managed_by  = "gemini-cli-pipeline"
    }
  }
}

registries = {
  "acrmicrodev001" = {
    resource_group_name = "rg-microservices-dev"
    location            = "East US"
    sku                 = "Standard"
    admin_enabled       = true
  }
}

clusters = {
  "aks-micro-dev-001" = {
    resource_group_name = "rg-microservices-dev"
    location            = "East US"
    dns_prefix          = "aksdev"
    kubernetes_version  = "1.27"
    
    default_node_pool = {
      name                = "systempool"
      node_count          = 1
      vm_size             = "Standard_DS2_v2"
      enable_auto_scaling = false
    }

    network_profile = {
      network_plugin = "kubenet"
    }

    identity = {
      type = "SystemAssigned"
    }
    
    tags = {
      environment = "development"
    }
  }
}
