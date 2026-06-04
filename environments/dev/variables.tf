variable "resource_groups" {
  description = "Resource groups configuration"
  type        = any
  default     = {}
}

variable "registries" {
  description = "ACR configuration"
  type        = any
  default     = {}
}

variable "clusters" {
  description = "AKS clusters configuration"
  type        = any
  default     = {}
}
