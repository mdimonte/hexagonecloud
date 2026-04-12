# Exercise 1 Starter Template
# Learn Terraform basics with local file resources

# Configure the Local provider
terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.4"
    }
  }
  required_version = ">= 1.0"
}

# Create a simple text file
# Documentation: https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file
resource "local_file" "hello" {
  filename = "hello.txt"
  content  = "Hello, Hexagone! This is my first infrastructure as code with Terraform."
}

# TODO: After the first apply, try:
# 1. Change the content and run terraform plan/apply
# 2. Add a second file resource below (uncomment and modify):
#
# resource "local_file" "welcome" {
#   filename = "welcome.txt"
#   content  = "Hexagone, welcome to Infrastructure as Code!"
# }
