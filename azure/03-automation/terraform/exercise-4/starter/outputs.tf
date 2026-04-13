# Exercise 4 Starter - Outputs

output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.main.name
}

# TODO: Output the App Service URL
# output "app_service_url" {
#   description = "URL of the App Service"
#   value       = "https://${azurerm_linux_web_app.main.default_hostname}"
# }

# TODO: Output the App Service name
# output "app_service_name" {
#   description = "Name of the App Service"
#   value       = azurerm_linux_web_app.main.name
# }

# TODO: Output the database server FQDN
# output "database_server_fqdn" {
#   description = "Fully qualified domain name of the PostgreSQL server"
#   value       = azurerm_postgresql_server.main.fqdn
# }

# TODO: Output the database server name
# output "database_server_name" {
#   description = "Name of the PostgreSQL server"
#   value       = azurerm_postgresql_server.main.name
# }

# TODO: Output the database name
# output "database_name" {
#   description = "Name of the database"
#   value       = azurerm_postgresql_database.main.name
# }

# TODO: Output the storage account name
# output "storage_account_name" {
#   description = "Name of the storage account"
#   value       = azurerm_storage_account.main.name
# }

# TODO: Output the storage primary endpoint
# output "storage_blob_endpoint" {
#   description = "Primary blob endpoint"
#   value       = azurerm_storage_account.main.primary_blob_endpoint
# }

# IMPORTANT: DO NOT output passwords or connection strings directly!
# In real production, store these in Azure Key Vault

# TODO (Optional): Create a connection string output (marked sensitive)
# output "database_connection_string" {
#   description = "PostgreSQL connection string"
#   value       = "postgresql://${var.db_admin_username}:${var.db_admin_password}@${azurerm_postgresql_server.main.fqdn}:5432/${azurerm_postgresql_database.main.name}"
#   sensitive   = true
# }
