module "resource_groups" {
  source          = "git::https://github.com/gauravdubey5/az-tf-child-dev.git//modules/azurerm-resource-groups?ref=v2.0.0"
  resource_groups = var.resource_groups
}

module "virtual_networks" {
  depends_on = [module.resource_groups]

  source           = "git::https://github.com/gauravdubey5/az-tf-child-dev.git//modules/azurerm-virtual-networks?ref=v2.0.0"
  virtual_networks = var.virtual_networks
}

module "subnets" {
  depends_on = [module.virtual_networks]

  source  = "git::https://github.com/gauravdubey5/az-tf-child-dev.git//modules/azurerm-subnets?ref=v2.0.0"
  subnets = var.subnets
}

module "network_security_groups" {
  depends_on = [module.subnets]

  source                  = "git::https://github.com/gauravdubey5/az-tf-child-dev.git//modules/azurerm-network-security-group?ref=v2.0.0"
  network_security_groups = var.network_security_groups
}

module "route_tables" {
  depends_on = [module.subnets]

  source       = "git::https://github.com/gauravdubey5/az-tf-child-dev.git//modules/azurerm-route-table?ref=v2.0.0"
  route_tables = var.route_tables
}

module "public_ips" {
  depends_on = [module.resource_groups]

  source     = "git::https://github.com/gauravdubey5/az-tf-child-dev.git//modules/azurerm-public-ip?ref=v2.0.0"
  public_ips = var.public_ips
}

module "nat_gateways" {
  depends_on = [
    module.public_ips,
    module.subnets
  ]

  source       = "git::https://github.com/gauravdubey5/az-tf-child-dev.git//modules/azurerm-nat-gateway?ref=v2.0.0"
  nat_gateways = var.nat_gateways
}

module "bastions" {
  depends_on = [
    module.public_ips,
    module.subnets
  ]

  source   = "git::https://github.com/gauravdubey5/az-tf-child-dev.git//modules/azurerm-bastion?ref=v2.0.0"
  bastions = var.bastions
}

module "load_balancers" {
  depends_on = [
    module.public_ips,
    module.virtual_machines
  ]

  source         = "git::https://github.com/gauravdubey5/az-tf-child-dev.git//modules/azurerm-load-balancer?ref=v2.0.0"
  load_balancers = var.load_balancers
}

module "application_gateways" {
  depends_on = [
    module.public_ips,
    module.subnets
  ]

  source               = "git::https://github.com/gauravdubey5/az-tf-child-dev.git//modules/azurerm-application-gateway?ref=v2.0.0"
  application_gateways = var.application_gateways
}

module "storage_accounts" {
  depends_on = [module.resource_groups]

  source           = "git::https://github.com/gauravdubey5/az-tf-child-dev.git//modules/azurerm-storage-account?ref=v2.0.0"
  storage_accounts = var.storage_accounts
}

module "key_vaults" {
  depends_on = [module.resource_groups]

  source     = "git::https://github.com/gauravdubey5/az-tf-child-dev.git//modules/azurerm-key-vault?ref=v2.0.0"
  key_vaults = var.key_vaults
}

module "managed_disks" {
  depends_on = [module.resource_groups]

  source        = "git::https://github.com/gauravdubey5/az-tf-child-dev.git//modules/azurerm-managed-disk?ref=v2.0.0"
  managed_disks = var.managed_disks
}

module "virtual_machines" {
  depends_on = [
    module.subnets,
    module.public_ips,
    module.managed_disks
  ]

  source           = "git::https://github.com/gauravdubey5/az-tf-child-dev.git//modules/azurerm-virtual-machines?ref=v2.0.0"
  virtual_machines = var.virtual_machines
}