output "resource_group_id" {
  description = "Resource ID of the network resource group."
  value       = module.network.resource_group_id
}

output "virtual_network_id" {
  description = "Resource ID of the virtual network."
  value       = module.network.virtual_network_id
}

output "subnet_id" {
  description = "Resource ID of the subnet."
  value       = module.network.subnet_id
}
