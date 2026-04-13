# Exercise 4 Solution - Variables

variable "project_name" {
  description = "Project name (must be globally unique)"
  type        = string

  validation {
    condition     = length(var.project_name) >= 3 && length(var.project_name) <= 15
    error_message = "Project name must be 3-15 characters."
  }
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "francecentral"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}

variable "tags" {
  description = "Base tags for resources"
  type        = map(string)
  default = {
    ManagedBy = "Terraform"
    Course    = "Terraform-101"
    Exercise  = "4"
  }
}

variable "db_admin_username" {
  description = "PostgreSQL administrator username"
  type        = string
  default     = "psqladmin"
}

variable "db_admin_password" {
  description = "PostgreSQL administrator password"
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.db_admin_password) >= 16
    error_message = "Password must be at least 16 characters."
  }
}

variable "app_service_sku" {
  description = "App Service SKU"
  type        = string
  default     = "F1"
}

variable "app_settings" {
  description = "App Service application settings"
  type        = map(string)
  default     = {}
}
