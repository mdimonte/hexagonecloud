# Exercise 4 Solution - Local Values

resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

locals {
  common_tags = merge(var.tags, {
    Environment = var.environment
  })

  name_prefix = "${var.project_name}-${var.environment}"

  # Generate globally unique names
  storage_account_name = lower(replace("${local.name_prefix}sa${random_string.suffix.result}", "-", ""))
  app_service_name     = "${local.name_prefix}-app-${random_string.suffix.result}"
  database_server_name = "${local.name_prefix}-pgsql-${random_string.suffix.result}"
}
