# Terraform Quick Reference Card

**Keep this handy during exercises!**

---

## Essential Commands

| Command | Purpose | When to Use |
|---------|---------|-------------|
| `terraform init` | Initialize directory, download providers | First time, after changing providers |
| `terraform fmt` | Format code to standard style | Before committing |
| `terraform validate` | Check syntax errors | Before planning |
| `terraform plan` | Preview changes without applying | Before every apply |
| `terraform apply` | Execute changes, update state | When plan looks good |
| `terraform destroy` | Remove all managed resources | Cleanup, teardown |
| `terraform show` | Display current state | Check what exists |
| `terraform state list` | List resources in state | See what's managed |
| `terraform output` | Show output values | Get deployed resource info |

---

## HCL Syntax Basics

### Resource Block
```hcl
resource "PROVIDER_NAME" "name" {
  argument = "value"
  
  nested_block {
    nested_arg = "value"
  }
}
```

### Variable Declaration
```hcl
variable "name" {
  description = "What this variable is for"
  type        = string
  default     = "default-value"
  
  validation {
    condition     = length(var.name) > 3
    error_message = "Must be longer than 3 chars"
  }
}
```

### Output Declaration
```hcl
output "name" {
  description = "What this output represents"
  value       = resource.type.name.attribute
  sensitive   = true  # Hide from console
}
```

### Local Values
```hcl
locals {
  common_tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
  
  name_prefix = "${var.project}-${var.environment}"
}

# Use with: local.common_tags
```

---

## Variable Types

| Type | Example | Declaration |
|------|---------|-------------|
| `string` | `"hello"` | `type = string` |
| `number` | `42`, `3.14` | `type = number` |
| `bool` | `true`, `false` | `type = bool` |
| `list(type)` | `["a", "b"]` | `type = list(string)` |
| `set(type)` | `["a", "b"]` (unique) | `type = set(string)` |
| `map(type)` | `{key = "val"}` | `type = map(string)` |
| `object({})` | Complex structure | `type = object({name = string})` |

---

## Referencing Resources

```hcl
# Create a resource
resource "azurerm_resource_group" "main" {
  name     = "my-rg"
  location = "francecentral"
}

# Reference it in another resource
resource "azurerm_storage_account" "main" {
  # Reference the name attribute
  resource_group_name = azurerm_resource_group.main.name
  
  # Reference the location attribute
  location = azurerm_resource_group.main.location
}

# Pattern: RESOURCE_TYPE.NAME.ATTRIBUTE
```

---

## Meta-Arguments

### count (Create Multiple)
```hcl
resource "azurerm_storage_account" "example" {
  count = 3
  name  = "storage${count.index}"
  # count.index = 0, 1, 2
}

# Reference: azurerm_storage_account.example[0].name
```

### for_each (Create from Map/Set)
```hcl
variable "environments" {
  default = ["dev", "staging", "prod"]
}

resource "azurerm_resource_group" "env" {
  for_each = toset(var.environments)
  name     = "${each.key}-rg"
  location = "francecentral"
}

# Reference: azurerm_resource_group.env["dev"].name
```

### depends_on (Explicit Dependencies)
```hcl
resource "azurerm_role_assignment" "example" {
  # ...
  
  depends_on = [
    azurerm_storage_account.main
  ]
}
```

### lifecycle
```hcl
resource "azurerm_postgresql_server" "example" {
  # ...
  
  lifecycle {
    prevent_destroy       = true          # Block terraform destroy
    create_before_destroy = true          # New before old deleted
    ignore_changes        = [tags]        # Don't update these
  }
}
```

---

## Common Terraform Blocks

### Provider Configuration
```hcl
terraform {
  required_version = ">= 1.0"
  
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}
```

### Remote Backend (Azure Storage)
```hcl
terraform {
  backend "azurerm" {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "tfstatestorage"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}
```

---

## Plan Symbols

| Symbol | Meaning |
|--------|---------|
| `+` | Resource will be **created** |
| `-` | Resource will be **destroyed** |
| `~` | Resource will be **updated in-place** |
| `-/+` | Resource will be **destroyed and recreated** |
| `<=` | Data source will be **read** |
| `(known after apply)` | Value not known until resource is created |

---

## String Interpolation

```hcl
# Simple interpolation
name = "${var.project}-storage"

# No interpolation needed for single variable
name = var.project

# Multi-line strings
description = <<-EOT
  This is a
  multi-line
  string
EOT

# Template directives
users = [
  %{ for name in var.user_names ~}
  "${name}",
  %{ endfor ~}
]
```

---

## Functions (Common)

```hcl
# String functions
upper("hello")                    # "HELLO"
lower("HELLO")                    # "hello"
title("hello world")              # "Hello World"
replace("hello", "l", "r")        # "herro"
join("-", ["a", "b", "c"])        # "a-b-c"
split("-", "a-b-c")               # ["a", "b", "c"]

# Collection functions
length([1, 2, 3])                 # 3
concat([1, 2], [3, 4])            # [1, 2, 3, 4]
merge({a=1}, {b=2})               # {a=1, b=2}
toset(["a", "a", "b"])            # ["a", "b"] (unique)

# Type conversions
tostring(42)                      # "42"
tonumber("42")                    # 42
tolist(toset(["a", "b"]))        # ["a", "b"]

# Filesystem
file("path/to/file.txt")          # Read file content
filebase64("image.png")           # Base64 encode file

# Encoding
jsonencode({key = "value"})       # '{"key":"value"}'
jsondecode('{"key":"value"}')     # {key = "value"}
base64encode("hello")             # "aGVsbG8="
```

---

## Azure Resource Naming

```hcl
# Generate unique suffix
resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}

# Use in names
locals {
  unique_suffix = random_string.suffix.result
  
  # Storage account (3-24 chars, lowercase alphanumeric)
  storage_name = "${lower(var.project)}${local.unique_suffix}"
  
  # Resource group (1-90 chars, alphanumeric, underscore, hyphen)
  rg_name = "${var.project}-${var.environment}-rg"
  
  # PostgreSQL server (3-63 chars, lowercase, hyphen)
  db_server_name = "${lower(var.project)}-db-${local.unique_suffix}"
}
```

---

## Troubleshooting Tips

### Common Errors

**"Error: Plugin did not respond"**
```bash
# Fix: Re-initialize
rm -rf .terraform .terraform.lock.hcl
terraform init
```

**"Error: State lock timeout"**
```bash
# Someone else is running terraform, or previous run crashed
# Wait or force unlock (dangerous!)
terraform force-unlock LOCK_ID
```

**"Error: Resource already exists"**
```bash
# Import existing resource
terraform import RESOURCE_TYPE.NAME AZURE_RESOURCE_ID

# Example:
terraform import azurerm_resource_group.main /subscriptions/.../resourceGroups/my-rg
```

**"Error: Invalid index"**
```bash
# Using count/for_each wrong
# count: use [0], [1], [2]
# for_each: use ["key"]
```

### Debugging

```bash
# Enable verbose logging
export TF_LOG=DEBUG
terraform apply

# Log to file
export TF_LOG=DEBUG
export TF_LOG_PATH=terraform.log
terraform apply

# Disable logging
unset TF_LOG
unset TF_LOG_PATH

# Refresh state without making changes
terraform apply -refresh-only

# See execution graph
terraform graph | dot -Tsvg > graph.svg
```

---

## Security Best Practices

### DO

- Use variables for sensitive data
- Mark outputs as `sensitive = true`
- Store state in encrypted remote backend
- Use `.gitignore` for state and `.tfvars`
- Use Azure Managed Identities
- Enable `prevent_destroy` for critical resources
- Use `terraform plan` before `apply`

### DON'T

- Commit `terraform.tfstate` to Git
- Commit `*.tfvars` with secrets to Git
- Hardcode passwords in `.tf` files
- Edit state files manually
- Share state files via email/Slack
- Use `-auto-approve` in production

---

## .gitignore Template

```gitignore
# Terraform
.terraform/
*.tfstate
*.tfstate.*
.terraform.lock.hcl
tfplan
crash.log
crash.*.log

# Variable files (may contain secrets)
*.tfvars
*.tfvars.json

# Override files
override.tf
override.tf.json
*_override.tf
*_override.tf.json

# CLI config
.terraformrc
terraform.rc

# Environment files
.env
.env.local
```

---

## terraform.tfvars Example

```hcl
# terraform.tfvars - NEVER commit this file!

project_name = "myproject"
environment  = "dev"
location     = "francecentral"

# Sensitive values
db_admin_username = "adminuser"
db_admin_password = "ChangeMe!Complex123"

tags = {
  Environment = "Development"
  Team        = "Platform"
  ManagedBy   = "Terraform"
}
```

---

## Workflow Cheat Sheet

### Starting a New Project
```bash
# 1. Create directory
mkdir my-terraform-project
cd my-terraform-project

# 2. Create main config
cat > main.tf << 'EOF'
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}
EOF

# 3. Initialize
terraform init

# 4. Create .gitignore
curl https://raw.githubusercontent.com/github/gitignore/main/Terraform.gitignore -o .gitignore

# 5. Start building!
```

### Daily Development Cycle
```bash
# Edit files
vim main.tf

# Format
terraform fmt

# Validate
terraform validate

# Plan
terraform plan

# Apply if good
terraform apply

# Check outputs
terraform output
```

### Cleanup After Exercise
```bash
# Destroy resources
terraform destroy

# Clean local files (optional)
rm -rf .terraform .terraform.lock.hcl terraform.tfstate*
```

---

## Quick Azure Resource Examples

### Resource Group
```hcl
resource "azurerm_resource_group" "main" {
  name     = "${var.project}-rg"
  location = var.location
  tags     = var.tags
}
```

### Storage Account
```hcl
resource "azurerm_storage_account" "main" {
  name                     = "${var.project}storage"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  
  tags = var.tags
}
```

### Virtual Network
```hcl
resource "azurerm_virtual_network" "main" {
  name                = "${var.project}-vnet"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  address_space       = ["10.0.0.0/16"]
  
  tags = var.tags
}
```

### Subnet
```hcl
resource "azurerm_subnet" "main" {
  name                 = "${var.project}-subnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.1.0/24"]
}
```

---

## Getting Help

```bash
# Show help for a command
terraform plan -help

# Show resource documentation
terraform providers schema -json | jq '.provider_schemas'

# Validate configuration
terraform validate

# Check formatting
terraform fmt -check
```

**Online Resources:**
- [Terraform Registry](https://registry.terraform.io/) - Provider docs
- [Azure Provider Docs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Terraform Language](https://www.terraform.io/language)
- Course materials: [`resources.md`](./resources.md)

---

**Remember:** When in doubt, `terraform plan` shows you what will happen! 🚀
