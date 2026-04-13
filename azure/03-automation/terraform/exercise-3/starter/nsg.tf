# Exercise 3 Starter - Network Security Group

# TODO: Create a Network Security Group
# Documentation: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group
# resource "azurerm_network_security_group" "main" {
#   name                = "${var.project_name}-nsg"
#   location            = azurerm_resource_group.main.location
#   resource_group_name = azurerm_resource_group.main.name
#   
#   # TODO: Add security rules
#   # Allow SSH (port 22)
#   security_rule {
#     name                       = "AllowSSH"
#     priority                   = 100
#     direction                  = "Inbound"
#     access                     = "Allow"
#     protocol                   = "Tcp"
#     source_port_range          = "*"
#     destination_port_range     = "22"
#     source_address_prefix      = "*"
#     destination_address_prefix = "*"
#   }
#   
#   # TODO: Add security rule for HTTP (port 80)
#   # security_rule {
#   #   name                       = "AllowHTTP"
#   #   priority                   = 110
#   #   direction                  = "Inbound"
#   #   access                     = "Allow"
#   #   protocol                   = "Tcp"
#   #   source_port_range          = "*"
#   #   destination_port_range     = "80"
#   #   source_address_prefix      = "*"
#   #   destination_address_prefix = "*"
#   # }
#   
#   # TODO: Add security rule for HTTPS (port 443)
#   
#   tags = var.tags
# }

# OPTIONAL: Associate NSG with subnets
# resource "azurerm_subnet_network_security_group_association" "web" {
#   subnet_id                 = azurerm_subnet.subnets["web"].id
#   network_security_group_id = azurerm_network_security_group.main.id
# }
