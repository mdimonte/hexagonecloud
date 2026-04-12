# Exercise 2 Solution - Storage Account

# Generate a random suffix to ensure global uniqueness
resource "random_string" "storage_suffix" {
  length  = 6
  special = false
  upper   = false
}

# Create the Storage Account
resource "azurerm_storage_account" "main" {
  # Combine project name with random suffix
  # Remove any hyphens and ensure lowercase
  name = lower(replace("${var.project_name}sa${random_string.storage_suffix.result}", "-", ""))

  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  account_tier             = var.storage_account_tier
  account_replication_type = var.storage_replication_type

  # Security best practice: require HTTPS
  https_traffic_only_enabled = true

  # Security best practice: minimum TLS version
  min_tls_version = "TLS1_2"

  tags = var.tags
}
