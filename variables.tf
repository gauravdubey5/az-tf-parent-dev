variable "subscription_id" {
  description = "Azure subscription ID used by the azurerm provider."
  type        = string
  sensitive   = true
}

variable "resource_group_name" {
  description = "Name of the resource group."
  type        = string
}

variable "location" {
  description = "Azure region for all resources."
  type        = string
  default     = "East US"
}

variable "vnet_name" {
  description = "Name of the virtual network."
  type        = string
}

variable "address_space" {
  description = "CIDR ranges assigned to the virtual network."
  type        = list(string)

  validation {
    condition     = length(var.address_space) > 0
    error_message = "address_space must contain at least one CIDR range."
  }
}

variable "subnet_name" {
  description = "Name of the subnet."
  type        = string
}

variable "subnet_prefixes" {
  description = "CIDR ranges assigned to the subnet."
  type        = list(string)

  validation {
    condition     = length(var.subnet_prefixes) > 0
    error_message = "subnet_prefixes must contain at least one CIDR range."
  }
}

variable "tags" {
  description = "Tags applied to every managed resource."
  type        = map(string)
  default     = {}
}
