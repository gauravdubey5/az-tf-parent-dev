output "resource_group" {

  value = { for key, resource_group in module.resource_groups : key => resource_group.resource_group_name }

}

output "virtual_network" {

  value = { for key, virtual_network in module.virtual_networks : key => virtual_network.vnet_name }

}

output "subnets" {

  value = { for key, subnet in module.subnets : key => subnet.subnet_ids }

}