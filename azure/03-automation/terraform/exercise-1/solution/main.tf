# Exercise 1 Solution
# Demonstrates basic Terraform workflow with local resources

terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.4"
    }
  }
  required_version = ">= 1.0"
}

# First file resource
resource "local_file" "hello" {
  filename = "hello.txt"
  content  = "Hello, Hexagone! This content has been modified."
}

# Second file resource (added in Part 2)
resource "local_file" "welcome" {
  filename        = "welcome.txt"
  content         = "Hexagone, welcome to Infrastructure as Code!\nThis is the second file."
  file_permission = "0644"
}

# Optional: Demonstrate sensitive file
resource "local_sensitive_file" "secret" {
  filename = "secret.txt"
  content  = "This is sensitive content that won't be shown in plan/apply output"
}
