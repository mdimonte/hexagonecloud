# Exercise 2 Starter - Variable Declarations
# Define input variables for flexible configuration

# TODO: Complete the project_name variable
# Hint: It should be a string type
variable "project_name" {
  description = "Project name used for resource naming"
  type        = string
  
  # Optional: Add validation to ensure it's 3-20 characters
  # validation {
  #   condition     = length(var.project_name) >= 3 && length(var.project_name) <= 20
  #   error_message = "Project name must be between 3 and 20 characters."
  # }
}

# TODO: Complete the location variable
# Hint: Add a default value (e.g., "francecentral", "northeurope" "...")
variable "location" {
  description = "Azure region where resources will be created"
  type        = string
  default     = "francecentral"  # TODO: Choose your preferred default region
}

# TODO: Create a variable for tags
# Hint: Tags are key-value pairs, so use map(string) type
variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    ManagedBy = "Terraform"
    Course    = "Terraform-101"
  }
}

# Optional: Subscription ID variable (uncomment if needed)
# variable "subscription_id" {
#   description = "Azure subscription ID"
#   type        = string
#   sensitive   = true
# }

# TODO: Create a variable for storage account tier
# Hint: Should be either "Standard" or "Premium"
# Example:
# variable "storage_account_tier" {
#   description = "Storage account tier"
#   type        = string
#   default     = "Standard"
#   
#   validation {
#     condition     = contains(["Standard", "Premium"], var.storage_account_tier)
#     error_message = "Storage account tier must be Standard or Premium."
#   }
# }
