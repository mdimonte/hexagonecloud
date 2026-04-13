# Exercise 4 Starter - App Service

# TODO: Create an App Service Plan
# Documentation: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/service_plan
# resource "azurerm_service_plan" "main" {
#   name                = "${local.name_prefix}-plan"
#   location            = azurerm_resource_group.main.location
#   resource_group_name = azurerm_resource_group.main.name
#   
#   os_type  = "Linux"
#   sku_name = var.app_service_sku
#   
#   tags = local.common_tags
# }

# TODO: Create a Linux Web App
# Documentation: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_web_app
# resource "azurerm_linux_web_app" "main" {
#   name                = local.app_service_name
#   location            = azurerm_resource_group.main.location
#   resource_group_name = azurerm_resource_group.main.name
#   service_plan_id     = azurerm_service_plan.main.id
#   
#   site_config {
#     # always_on = false
#     # TODO: Configure for Node.js 18
#     # application_stack {
#     #   node_version = "20-lts"
#     # }
#   }
#   
#   app_settings = merge(var.app_settings, {
#     "DATABASE_HOST"     = azurerm_postgresql_flexible_server.main.fqdn
#     "DATABASE_NAME"     = azurerm_postgresql_flexible_server.main.name
#     "DATABASE_USER"     = "${var.db_admin_username}@${azurerm_postgresql_flexible_server.main.name}"
#     "DATABASE_PASSWORD" = var.db_admin_password
#     "DATABASE_PORT"     = "5432"
#     "DATABASE_SSL"      = "true"
#     "STORAGE_ACCOUNT"   = azurerm_storage_account.main.name
#   })

#   tags = local.common_tags
# }
