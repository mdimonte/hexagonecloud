# Exercise 2 Starter - Outputs
# Display important information after deployment

# TODO: Create an output for the resource group name
# Hint: Use azurerm_resource_group.main.name
output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.main.name
}

# TODO: Create an output for the storage account name
# Hint: Use azurerm_storage_account.main.name
output "storage_account_name" {
  description = "Name of the storage account"
  value       = "REPLACE_ME"  # TODO: Reference the storage account name
}

# TODO: Create an output for the storage account primary endpoint
# Hint: Use azurerm_storage_account.main.primary_blob_endpoint
# output "storage_blob_endpoint" {
#   description = "Primary blob endpoint of the storage account"
#   value       = "REPLACE_ME"
# }

# TODO: Create an output for the location
output "location" {
  description = "Azure region where resources are deployed"
  value       = azurerm_resource_group.main.location
}

# OPTIONAL: Display all storage account properties (for learning)
# Uncomment to see all available attributes:
# output "storage_account_details" {
#   description = "All storage account properties"
#   value       = azurerm_storage_account.main
#   sensitive   = true  # Mark as sensitive to hide access keys
# }
