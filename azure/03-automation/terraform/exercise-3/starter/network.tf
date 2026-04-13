# Exercise 3 Starter - Network Resources

# TODO: Create a Virtual Network
# Documentation: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network
# resource "azurerm_virtual_network" "main" {
#   name                = "${var.project_name}-vnet"
#   resource_group_name = azurerm_resource_group.main.name
#   location            = azurerm_resource_group.main.location
#   address_space       = var.vnet_address_space
#   
#   tags = var.tags
# }

# TODO: Create subnets using for_each
# Documentation: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet
# Hint: Use for_each = var.subnets
# resource "azurerm_subnet" "subnets" {
#   for_each = var.subnets
#   
#   name                 = each.key
#   resource_group_name  = azurerm_resource_group.main.name
#   virtual_network_name = azurerm_virtual_network.main.name
#   address_prefixes     = [each.value]
# }

# CHALLENGE: Try using count instead of for_each
# What are the differences? Which is better?
