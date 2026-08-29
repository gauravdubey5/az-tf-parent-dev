module "resource_groups" {
  for_each = var.resource_groups
  source   = "git::https://github.com/gauravdubey5/az-tf-child-dev.git//modules/azurerm-resource-groups?ref=v2.0.0"

  resource_group_name = each.value.name
  location            = each.value.location
}

module "virtual_networks" {
  depends_on = [module.resource_groups]
  for_each   = var.virtual_networks

  source              = "git::https://github.com/gauravdubey5/az-tf-child-dev.git//modules/azurerm-virtual-networks?ref=v2.0.0"
  vnet_name           = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  address_space       = each.value.address_space
}

module "subnets" {
  depends_on = [module.virtual_networks]
  for_each   = var.subnets

  source               = "git::https://github.com/gauravdubey5/az-tf-child-dev.git//modules/azurerm-subnets?ref=v2.0.0"
  resource_group_name  = each.value.resource_group_name
  virtual_network_name = each.value.virtual_network_name
  subnets              = { (each.key) = { name = each.value.name, address_prefixes = each.value.address_prefixes } }
}

module "network_security_groups" {
  depends_on = [module.subnets]
  for_each   = var.network_security_groups

  source              = "git::https://github.com/gauravdubey5/az-tf-child-dev.git//modules/azurerm-network-security-group?ref=v2.0.0"
  nsg_name            = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  security_rules      = each.value.security_rules
}

module "route_tables" {
  depends_on = [module.subnets]
  for_each   = var.route_tables

  source              = "git::https://github.com/gauravdubey5/az-tf-child-dev.git//modules/azurerm-route-table?ref=v2.0.0"
  route_table_name    = each.value.name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  routes              = each.value.routes
}

module "public_ips" {
  depends_on = [module.resource_groups]
  for_each   = var.public_ips

  source              = "git::https://github.com/gauravdubey5/az-tf-child-dev.git//modules/azurerm-public-ip?ref=v2.0.0"
  public_ip_name      = each.value.name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  allocation_method   = each.value.allocation_method
  sku                 = each.value.sku
}

module "nat_gateways" {
  depends_on = [
    module.public_ips,
    module.subnets
  ]
  for_each = var.nat_gateways

  source              = "git::https://github.com/gauravdubey5/az-tf-child-dev.git//modules/azurerm-nat-gateway?ref=v2.0.0"
  nat_gateway_name    = each.value.name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  public_ip_id        = one([for key, public_ip in var.public_ips : module.public_ips[key].public_ip_id if public_ip.name == each.value.public_ip_name])
  subnet_id           = one([for key, subnet in var.subnets : module.subnets[key].subnet_ids[subnet.name] if subnet.name == each.value.subnet_name])
}

module "bastions" {
  depends_on = [
    module.public_ips,
    module.subnets
  ]
  for_each = var.bastions

  source              = "git::https://github.com/gauravdubey5/az-tf-child-dev.git//modules/azurerm-bastion?ref=v2.0.0"
  bastion_name        = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  public_ip_id        = one([for key, public_ip in var.public_ips : module.public_ips[key].public_ip_id if public_ip.name == each.value.public_ip_name])
  subnet_id           = one([for key, subnet in var.subnets : module.subnets[key].subnet_ids[subnet.name] if subnet.name == each.value.subnet_name])
}

module "load_balancers" {
  depends_on = [
    module.public_ips,
    module.virtual_machines
  ]
  for_each = var.load_balancers

  source              = "git::https://github.com/gauravdubey5/az-tf-child-dev.git//modules/azurerm-load-balancer?ref=v2.0.0"
  lb_name             = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  public_ip_id        = one([for key, public_ip in var.public_ips : module.public_ips[key].public_ip_id if public_ip.name == each.value.public_ip_name])
}

module "application_gateways" {
  depends_on = [
    module.public_ips,
    module.subnets
  ]
  for_each = var.application_gateways

  source                   = "git::https://github.com/gauravdubey5/az-tf-child-dev.git//modules/azurerm-application-gateway?ref=v2.0.0"
  application_gateway_name = each.value.name
  location                 = each.value.location
  resource_group_name      = each.value.resource_group_name
  public_ip_id             = one([for key, public_ip in var.public_ips : module.public_ips[key].public_ip_id if public_ip.name == each.value.public_ip_name])
  subnet_id                = one([for key, subnet in var.subnets : module.subnets[key].subnet_ids[subnet.name] if subnet.name == each.value.subnet_name])
}

module "storage_accounts" {
  depends_on = [module.resource_groups]
  for_each   = var.storage_accounts

  source               = "git::https://github.com/gauravdubey5/az-tf-child-dev.git//modules/azurerm-storage-account?ref=v2.0.0"
  storage_account_name = each.value.name
  location             = each.value.location
  resource_group_name  = each.value.resource_group_name
  account_tier         = each.value.account_tier
  replication_type     = each.value.replication_type
}

module "key_vaults" {
  depends_on = [module.resource_groups]
  for_each   = var.key_vaults

  source              = "git::https://github.com/gauravdubey5/az-tf-child-dev.git//modules/azurerm-key-vault?ref=v2.0.0"
  key_vault_name      = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
}

module "managed_disks" {
  depends_on = [module.resource_groups]
  for_each   = var.managed_disks

  source               = "git::https://github.com/gauravdubey5/az-tf-child-dev.git//modules/azurerm-managed-disk?ref=v2.0.0"
  disk_name            = each.value.name
  location             = each.value.location
  resource_group_name  = each.value.resource_group_name
  disk_size_gb         = each.value.disk_size_gb
  storage_account_type = each.value.storage_account_type
}

module "virtual_machines" {
  depends_on = [
    module.subnets,
    module.public_ips,
    module.managed_disks
  ]
  for_each = var.virtual_machines

  source              = "git::https://github.com/gauravdubey5/az-tf-child-dev.git//modules/azurerm-virtual-machines?ref=v2.0.0"
  vm_name             = each.value.vm_name
  location            = each.value.location
  resource_group_name = each.value.rg_name
  subnet_id           = one([for key, subnet in var.subnets : module.subnets[key].subnet_ids[subnet.name] if subnet.name == each.value.nic_subnet_name])
  vm_size             = each.value.vm_size
  admin_username      = each.value.admin_username
  public_key          = each.value.public_key
}