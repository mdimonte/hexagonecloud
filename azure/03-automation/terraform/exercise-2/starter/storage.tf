# Exercise 2 Starter - Storage Account Resource
# Create an Azure Storage Account

# TODO: Complete the storage account resource
# Documentation: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account

resource "azurerm_storage_account" "main" {
  # TODO: Set the name
  # Hint: Must be globally unique, 3-24 chars, lowercase letters and numbers only
  # Suggestion: use "${var.project_name}sa${random_id}" or similar
  name = "REPLACE_ME"  # e.g., "mystorageacct12345"
  
  # Link to the resource group we created
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  
  # TODO: Set the account tier
  # Hint: Use "Standard" for this exercise (or use a variable)
  account_tier = "Standard"
  
  # TODO: Set the replication type
  # Hint: "LRS" (Locally Redundant Storage) is cheapest for learning
  # Options: LRS, GRS, RAGRS, ZRS, GZRS, RAGZRS
  account_replication_type = "LRS"
  
  # Apply the same tags as the resource group
  tags = var.tags
}

# OPTIONAL CHALLENGE: Use random_string to generate unique names
# Uncomment if you want to try this approach:
#
# terraform {
#   required_providers {
#     random = {
#       source  = "hashicorp/random"
#       version = "~> 3.0"
#     }
#   }
# }
#
# resource "random_string" "storage_suffix" {
#   length  = 6
#   special = false
#   upper   = false
# }
#
# Then use: name = "${var.project_name}sa${random_string.storage_suffix.result}"
