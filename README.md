# Azure Terraform Modules

This repository contains best-practice Terraform modules for Azure Resource Group, AKS, and ACR.

## Key Features

- **Resource Group Module**: Supports multiple resource groups using `for_each`.
- **ACR Module**: Supports multiple registries, SKU selection, and georeplication using `dynamic` blocks.
- **AKS Module**: Supports multiple clusters, dynamic network profiles, identity configurations, and additional node pools via a flattened `for_each` iteration.
- **Modern Terraform Features**:
    - `optional()` attributes for concise variable definitions.
    - `dynamic` blocks for conditional nested configurations.
    - `for_each` with nested maps for highly configurable deployments.

## Directory Structure

```text
.
├── modules/
│   ├── resource_group/
│   ├── acr/
│   └── aks/
└── examples/
    └── basic/
```

## Usage

Check the `examples/basic/main.tf` for a complete example of how to integrate these modules.
