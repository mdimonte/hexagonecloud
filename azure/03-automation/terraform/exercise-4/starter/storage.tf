# Exercise 4 Starter - Storage Account

# TODO: Create a Storage Account
# Documentation: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account
# resource "azurerm_storage_account" "main" {
#   name                     = local.storage_account_name
#   resource_group_name      = azurerm_resource_group.main.name
#   location                 = azurerm_resource_group.main.location
#   account_tier             = "Standard"
#   account_replication_type = "LRS"
#   
#   # Security best practices
#   enable_https_traffic_only = true
#   min_tls_version          = "TLS1_2"
#   
#   tags = local.common_tags
# }

# TODO (Optional): Create a blob container for uploads
# resource "azurerm_storage_container" "uploads" {
#   name                  = "uploads"
#   storage_account_name  = azurerm_storage_account.main.name
#   container_access_type = "private"
# }
