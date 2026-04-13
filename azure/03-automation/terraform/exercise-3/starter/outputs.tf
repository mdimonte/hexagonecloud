# Exercise 3 Starter - Outputs

# TODO: Output the VNet ID
# output "vnet_id" {
#   description = "ID of the virtual network"
#   value       = azurerm_virtual_network.main.id
# }

# TODO: Output the VNet name
# output "vnet_name" {
#   description = "Name of the virtual network"
#   value       = azurerm_virtual_network.main.name
# }

# TODO: Output all subnet IDs as a map
# Hint: Use a for expression
# output "subnet_ids" {
#   description = "Map of subnet names to IDs"
#   value       = { for k, v in azurerm_subnet.subnets : k => v.id }
# }

# TODO: Output the NSG ID
# output "nsg_id" {
#   description = "ID of the network security group"
#   value       = azurerm_network_security_group.main.id
# }

# CHALLENGE: Create a structured output with all network info
# output "network_info" {
#   description = "Complete network infrastructure information"
#   value = {
#     vnet = {
#       id            = azurerm_virtual_network.main.id
#       name          = azurerm_virtual_network.main.name
#       address_space = azurerm_virtual_network.main.address_space
#     }
#     subnets = { for k, v in azurerm_subnet.subnets : k => {
#       id               = v.id
#       address_prefixes = v.address_prefixes
#     }}
#   }
# }
