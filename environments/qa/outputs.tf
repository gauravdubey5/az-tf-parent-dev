output "resource_group" {

  value = module.resource_group.resource_group_name

}

output "virtual_network" {

  value = module.virtual_network.vnet_name

}

output "subnets" {

  value = module.subnets.subnet_ids

}