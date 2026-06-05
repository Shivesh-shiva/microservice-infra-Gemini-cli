module "resource_groups" {
  source          = "../../modules/resource_group"
  resource_groups = var.resource_groups
}

import {
  to = module.resource_groups.azurerm_resource_group.this["rg-microservices-dev"]
  id = "/subscriptions/${var.ARM_SUBSCRIPTION_ID}/resourceGroups/rg-microservices-dev"
}

module "acr" {
  source     = "../../modules/acr"
  registries = var.registries

  depends_on = [module.resource_groups]
}

module "aks" {
  source   = "../../modules/aks"
  clusters = var.clusters

  depends_on = [module.resource_groups]
}
