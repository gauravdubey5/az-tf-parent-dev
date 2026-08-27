module "network" {
  source = "git::https://github.com/gauravdubey5/az-tf-child-dev.git?ref=v1.0.0"

  resource_group_name = var.resource_group_name
  location            = var.location
  vnet_name           = var.vnet_name
  address_space       = var.address_space
  subnet_name         = var.subnet_name
  subnet_prefixes     = var.subnet_prefixes
  tags                = var.tags
}
