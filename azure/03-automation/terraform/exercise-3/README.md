# Exercise 3: Multi-Resource Infrastructure

> **Quick Reference**: Keep the [Terraform Quick Reference Card](../quick-reference.md) handy for commands and syntax!

## Learning Objectives

- Deploy multiple related Azure resources
- Understand implicit and explicit dependencies
- Work with Terraform state
- Create and use a simple module
- Use `count` and `for_each` for multiple similar resources
- Inspect and query Terraform state

## Theory (20 min)

### Resource Dependencies

Terraform automatically determines the order to create resources by analyzing references:

**Implicit Dependencies** (automatic):
```hcl
resource "azurerm_virtual_network" "main" {
  name = "my-vnet"
  # ...
}

resource "azurerm_subnet" "app" {
  virtual_network_name = azurerm_virtual_network.main.name  # Implicit dependency
  # ...
}
```

**Explicit Dependencies** (manual override):
```hcl
resource "azurerm_subnet" "db" {
  # ...
  depends_on = [azurerm_network_security_group.main]
}
```

### Terraform State Deep Dive

The state file (`terraform.tfstate`) is Terraform's source of truth:
- Maps configuration to real resources
- Tracks resource metadata
- Enables collaboration (when using remote state)
- Contains sensitive data - never commit to Git!

**State Commands:**
```bash
terraform state list                    # List all resources
terraform state show <resource>         # Show resource details
terraform state mv <old> <new>          # Rename resource
terraform state rm <resource>           # Remove from state
terraform refresh                       # Update state from real infrastructure
```

### Modules

Modules are reusable Terraform configurations:

**Using a module:**
```hcl
module "network" {
  source = "./modules/network"
  
  name    = "my-network"
  location = "francecentral"
}

# Access module outputs
resource "azurerm_subnet" "app" {
  virtual_network_name = module.network.vnet_name
}
```

### Meta-Arguments

Special arguments that work with any resource:

- `count` - Create multiple instances (integer)
- `for_each` - Create multiple instances (set or map)
- `depends_on` - Explicit dependencies
- `provider` - Select non-default provider
- `lifecycle` - Customize resource behavior

**Example with count:**
```hcl
resource "azurerm_subnet" "subnets" {
  count = 3
  name  = "subnet-${count.index}"
  # ...
}
```

**Example with for_each:**
```hcl
variable "subnets" {
  type = map(string)
  default = {
    web = "10.0.1.0/24"
    app = "10.0.2.0/24"
    db  = "10.0.3.0/24"
  }
}

resource "azurerm_subnet" "subnets" {
  for_each = var.subnets
  
  name                 = each.key
  address_prefixes     = [each.value]
  # ...
}
```

## Exercise Instructions (40 min)

### Part 1: Deploy Basic Network Infrastructure (15 min)

1. **Navigate to the starter directory:**
   ```bash
   cd exercise-3/starter
   ```

2. **Review the starter files:**
   - `main.tf` - Provider and resource group (complete)
   - `variables.tf` - Variable declarations (needs completion)
   - `network.tf` - VNet and subnets (needs completion)
   - `nsg.tf` - Network security group (needs completion)
   - `terraform.tfvars.example` - Example values

3. **Create your terraform.tfvars:**
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   # Edit with your unique project name
   ```

4. **Complete the TODOs:**
   - Follow the hints in each file
   - Create 3 subnets with different address ranges
   - Add NSG rules for basic security

5. **Deploy:**
   ```bash
   terraform init
   terraform fmt
   terraform validate
   terraform plan
   terraform apply
   ```

### Part 2: Work with Terraform State (10 min)

1. **List all resources:**
   ```bash
   terraform state list
   ```

2. **Show details of the VNet:**
   ```bash
   terraform state show azurerm_virtual_network.main
   ```

3. **Show details of a subnet:**
   ```bash
   terraform state show 'azurerm_subnet.subnets["web"]'
   ```

4. **View outputs:**
   ```bash
   terraform output
   terraform output vnet_id
   terraform output -json > infrastructure.json
   ```

5. **Explore the state file** (read-only):
   ```bash
   cat terraform.tfstate | jq '.resources[] | {type: .type, name: .name}'
   ```

### Part 3: Create a Simple Module (10 min)

1. **Create a module directory:**
   ```bash
   mkdir -p modules/subnet
   cd modules/subnet
   ```

2. **Create module files:**

   **modules/subnet/main.tf:**
   ```hcl
   resource "azurerm_subnet" "this" {
     name                 = var.name
     resource_group_name  = var.resource_group_name
     virtual_network_name = var.virtual_network_name
     address_prefixes     = [var.address_prefix]
   }
   ```

   **modules/subnet/variables.tf:**
   ```hcl
   variable "name" {
     type = string
   }
   variable "resource_group_name" {
     type = string
   }
   variable "virtual_network_name" {
     type = string
   }
   variable "address_prefix" {
     type = string
   }
   ```

   **modules/subnet/outputs.tf:**
   ```hcl
   output "id" {
     value = azurerm_subnet.this.id
   }
   output "name" {
     value = azurerm_subnet.this.name
   }
   ```

3. **Use the module** (back in root directory):
   ```hcl
   module "db_subnet" {
     source = "./modules/subnet"
     
     name                 = "database"
     resource_group_name  = azurerm_resource_group.main.name
     virtual_network_name = azurerm_virtual_network.main.name
     address_prefix       = "10.0.4.0/24"
   }
   ```

4. **Apply changes:**
   ```bash
   terraform init  # Required when adding modules!
   terraform apply
   ```

### Part 4: Verify in Azure (5 min)

```bash
# List VNets
az network vnet list --output table

# Show VNet details
az network vnet show \
  --name <your-vnet-name> \
  --resource-group <your-rg> \
  --output json

# List subnets
az network vnet subnet list \
  --vnet-name <your-vnet-name> \
  --resource-group <your-rg> \
  --output table
```

### Part 5: Cleanup

```bash
terraform destroy
```

## Key Takeaways

1. **Dependencies** are mostly automatic (implicit) in Terraform
2. **State** is the source of truth - treat it carefully
3. **Modules** promote reusability and organization
4. **for_each** is better than `count` for managing similar resources
5. **Azure networking** requires understanding VNets, subnets, and NSGs

## Common Issues

| Problem | Solution |
|---------|----------|
| Subnet address overlap | Ensure subnets don't overlap and fit within VNet address space |
| Module not found | Run `terraform init` after adding/modifying modules |
| Invalid address prefix | Use CIDR notation (e.g., 10.0.1.0/24) |
| State locked | Wait or break lease if stuck |

## Understanding the Infrastructure

After deployment, you'll have:
```
Resource Group
├── Virtual Network (10.0.0.0/16)
│   ├── Subnet: web (10.0.1.0/24)
│   ├── Subnet: app (10.0.2.0/24)
│   └── Subnet: db (10.0.3.0/24)
└── Network Security Group
    ├── SSH rule (port 22)
    ├── HTTP rule (port 80)
    └── HTTPS rule (port 443)
```

## Next Steps

In [Exercise 4: Full Stack Deployment](../exercise-4/), you'll deploy a complete application with a web app and database.

---

**Need help?** Check the [solution](../solution/) folder, but try to complete the exercise on your own first!
