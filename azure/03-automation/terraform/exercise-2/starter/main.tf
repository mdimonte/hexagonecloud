# Exercise 2 Starter - Main Configuration
# Deploy your first Azure resource: a Storage Account

terraform {
  required_version = ">= 1.0"
  
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

# Configure the Azure Provider
# Authentication: Uses Azure CLI (az login)
# Documentation: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs
provider "azurerm" {
  features {}
  
  # Optional: Uncomment and set your subscription ID in terraform.tfvars
  # subscription_id = var.subscription_id
}

# Create a Resource Group
# Resource groups are logical containers for Azure resources
# Documentation: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group
resource "azurerm_resource_group" "main" {
  name     = "${var.project_name}-rg"
  location = var.location
  
  tags = var.tags
}
