# Exercise 3 Starter - Variables

variable "project_name" {
  description = "Project name used for resource naming"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "francecentral"
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default = {
    ManagedBy = "Terraform"
    Course    = "Terraform-101"
    Exercise  = "3"
  }
}

# TODO: Create a variable for the VNet address space
# Hint: Use list(string) type
# Example default: ["10.0.0.0/16"]
# variable "vnet_address_space" {
#   description = "Address space for the virtual network"
#   type        = list(string)
#   default     = ["10.0.0.0/16"]
# }

# TODO: Create a variable for subnets using a map
# Each subnet should have a name (key) and address prefix (value)
# variable "subnets" {
#   description = "Map of subnet names to address prefixes"
#   type        = map(string)
#   default = {
#     web = "10.0.1.0/24"
#     app = "10.0.2.0/24"
#     db  = "10.0.3.0/24"
#   }
# }
