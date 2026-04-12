# Exercise 2 Solution - Outputs

output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.main.name
}

output "resource_group_location" {
  description = "Location of the resource group"
  value       = azurerm_resource_group.main.location
}

output "storage_account_name" {
  description = "Name of the storage account"
  value       = azurerm_storage_account.main.name
}

output "storage_account_id" {
  description = "ID of the storage account"
  value       = azurerm_storage_account.main.id
}

output "storage_blob_endpoint" {
  description = "Primary blob endpoint of the storage account"
  value       = azurerm_storage_account.main.primary_blob_endpoint
}

output "storage_primary_access_key" {
  description = "Primary access key for the storage account"
  value       = azurerm_storage_account.main.primary_access_key
  sensitive   = true # Hide from normal output
}

output "all_endpoints" {
  description = "All storage endpoints"
  value = {
    blob  = azurerm_storage_account.main.primary_blob_endpoint
    file  = azurerm_storage_account.main.primary_file_endpoint
    queue = azurerm_storage_account.main.primary_queue_endpoint
    table = azurerm_storage_account.main.primary_table_endpoint
  }
}
