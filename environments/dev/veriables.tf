variable "resource_groups" {
  description = "Azure Resource Groups"

  type = map(object({
    name       = string
    location   = string
    managed_by = string
  }))
}

variable "virtual_networks" {
  description = "Azure Virtual Networks"

  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
    address_space       = list(string)
  }))
}

variable "subnets" {
  description = "Azure Subnets"

  type = map(object({
    name                 = string
    resource_group_name  = string
    virtual_network_name = string
    address_prefixes     = list(string)
  }))
}

variable "network_security_groups" {
  description = "Azure Network Security Groups"

  type = map(object({
    name                = string
    location            = string
    resource_group_name = string

    security_rules = map(object({
      priority                   = number
      direction                  = string
      access                     = string
      protocol                   = string
      source_port_range          = string
      destination_port_range     = string
      source_address_prefix      = string
      destination_address_prefix = string
    }))
  }))

  default = {}
}

variable "route_tables" {
  description = "Azure Route Tables"

  type = map(object({
    name                = string
    location            = string
    resource_group_name = string

    routes = map(object({
      address_prefix         = string
      next_hop_type          = string
      next_hop_in_ip_address = optional(string)
    }))
  }))

  default = {}
}

variable "public_ips" {
  description = "Azure Public IPs"

  type = map(object({
    name                = string
    resource_group_name = string
    location            = string
    allocation_method   = string
    sku                 = optional(string, "Standard")
  }))

  default = {}
}

variable "nat_gateways" {
  description = "Azure NAT Gateways"

  type = map(object({
    name                 = string
    location             = string
    resource_group_name  = string
    public_ip_name       = string
    subnet_name          = string
    virtual_network_name = string
  }))

  default = {}
}

variable "bastions" {
  description = "Azure Bastion Hosts"

  type = map(object({
    name                 = string
    location             = string
    resource_group_name  = string
    public_ip_name       = string
    subnet_name          = string
    virtual_network_name = string
  }))

  default = {}
}

variable "load_balancers" {
  description = "Azure Load Balancers"

  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
    public_ip_name      = string
  }))

  default = {}
}

variable "application_gateways" {
  description = "Azure Application Gateways"

  type = map(object({
    name                 = string
    location             = string
    resource_group_name  = string
    subnet_name          = string
    virtual_network_name = string
    public_ip_name       = string
  }))

  default = {}
}

variable "storage_accounts" {
  description = "Azure Storage Accounts"

  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
    account_tier        = string
    replication_type    = string
  }))

  default = {}
}

variable "key_vaults" {
  description = "Azure Key Vaults"

  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
  }))

  default = {}
}

variable "managed_disks" {
  description = "Azure Managed Disks"

  type = map(object({
    name                 = string
    location             = string
    resource_group_name  = string
    disk_size_gb         = number
    storage_account_type = string
  }))

  default = {}
}

variable "virtual_machines" {
  description = "Azure Virtual Machines"

  type = map(object({
    nic_name        = string
    location        = string
    rg_name         = string
    nic_subnet_name = string
    nic_vnet_name   = string
    nic_pip_name    = string

    vm_name        = string
    vm_size        = string
    admin_username = string
    admin_password = string
    public_key     = string

    ip_nic_name = string
  }))

  default = {}
}