# Exercise 4 Starter - Local Values

# Generate a random suffix for globally unique names
resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

locals {
  # TODO: Create common tags by merging var.tags with environment
  # Hint: Use merge() function
  common_tags = merge(var.tags, {
    Environment = var.environment
  })
  
  # TODO: Create a naming prefix
  # Example: "${var.project_name}-${var.environment}"
  name_prefix = "${var.project_name}-${var.environment}"
  
  # TODO: Create unique names for globally unique resources
  # storage_account_name must be: 3-24 chars, lowercase, numbers only
  # Hint: Use lower() and replace() to remove hyphens
  storage_account_name = lower(replace("${local.name_prefix}sa${random_string.suffix.result}", "-", ""))
  
  # TODO: Create unique names for other resources
  # app_service_name = "${local.name_prefix}-app-${random_string.suffix.result}"
  # database_server_name = "${local.name_prefix}-pgsql-${random_string.suffix.result}"
}
