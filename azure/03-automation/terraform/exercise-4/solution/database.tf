# Exercise 4 Solution - PostgreSQL Database

resource "azurerm_postgresql_flexible_server" "main" {
  name                = local.database_server_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  administrator_login    = var.db_admin_username
  administrator_password = var.db_admin_password

  zone = 1

  authentication {
    password_auth_enabled = true
  }

  sku_name     = "B_Standard_B1ms"
  version      = "16"
  storage_mb   = 32768
  storage_tier = "P4"

  backup_retention_days        = 7
  geo_redundant_backup_enabled = false
  auto_grow_enabled            = false

  public_network_access_enabled = true

  lifecycle {
    prevent_destroy = false # Set to true in production!
  }

  tags = local.common_tags
}

resource "azurerm_postgresql_flexible_server_database" "main" {
  server_id = azurerm_postgresql_flexible_server.main.id
  name      = "${replace(var.project_name, "-", "_")}_db"
  charset   = "utf8"
  collation = "en_US.utf8"
}

resource "azurerm_postgresql_flexible_server_firewall_rule" "allow_azure_services" {
  server_id        = azurerm_postgresql_flexible_server.main.id
  name             = "AllowAzureServices"
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}
