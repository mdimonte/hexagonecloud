# Exercise 3 Solution - Outputs

output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.main.name
}

output "vnet_id" {
  description = "ID of the virtual network"
  value       = azurerm_virtual_network.main.id
}

output "vnet_name" {
  description = "Name of the virtual network"
  value       = azurerm_virtual_network.main.name
}

output "vnet_address_space" {
  description = "Address space of the virtual network"
  value       = azurerm_virtual_network.main.address_space
}

output "subnet_ids" {
  description = "Map of subnet names to IDs"
  value       = { for k, v in azurerm_subnet.subnets : k => v.id }
}

output "subnet_details" {
  description = "Detailed information about subnets"
  value = { for k, v in azurerm_subnet.subnets : k => {
    id               = v.id
    name             = v.name
    address_prefixes = v.address_prefixes
  } }
}

output "nsg_id" {
  description = "ID of the network security group"
  value       = azurerm_network_security_group.main.id
}

output "network_info" {
  description = "Complete network infrastructure information"
  value = {
    vnet = {
      id            = azurerm_virtual_network.main.id
      name          = azurerm_virtual_network.main.name
      address_space = azurerm_virtual_network.main.address_space
    }
    subnets = { for k, v in azurerm_subnet.subnets : k => {
      id               = v.id
      address_prefixes = v.address_prefixes
    } }
    nsg = {
      id   = azurerm_network_security_group.main.id
      name = azurerm_network_security_group.main.name
    }
  }
}
