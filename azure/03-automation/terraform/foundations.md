# Terraform Foundations - Deep Dive

This document provides detailed explanations of core Terraform concepts for the foundation hour of the course.

---

## Part 1: Declarative vs. Imperative Infrastructure (10 min)

### Understanding the Paradigms

#### Imperative Approach (Traditional Scripting)

**Definition:** You specify **HOW** to achieve the desired state, step by step.

**Example - Bash Script:**
```bash
#!/bin/bash
# Imperative: Explicit steps to create infrastructure

# Step 1: Check if resource group exists
if [ $(az group exists -n my-rg) = false ]; then
  echo "Creating resource group..."
  az group create -n my-rg -l francecentral
fi

# Step 2: Check if storage account exists
STORAGE_EXISTS=$(az storage account check-name -n mystorageacct --query nameAvailable)
if [ "$STORAGE_EXISTS" = "true" ]; then
  echo "Creating storage account..."
  az storage account create -n mystorageacct -g my-rg -l francecentral --sku Standard_LRS
else
  echo "Storage account already exists, updating..."
  az storage account update -n mystorageacct -g my-rg --sku Standard_GRS
fi

# Step 3: Create container
az storage container create -n mycontainer --account-name mystorageacct
```

**Characteristics:**
- Must handle all edge cases (exists? needs update? delete?)
- Order matters - steps must be executed sequentially
- Hard to maintain - what if you re-run the script?
- No state tracking - you must check everything
- Difficult to "undo" or rollback

#### Declarative Approach (Terraform)

**Definition:** You specify **WHAT** the desired end state is. Terraform figures out how to get there.

**Example - Terraform:**
```hcl
# Declarative: Describe the desired state

resource "azurerm_resource_group" "main" {
  name     = "my-rg"
  location = "francecentral"
}

resource "azurerm_storage_account" "main" {
  name                     = "mystorageacct"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
}

resource "azurerm_storage_container" "main" {
  name                  = "mycontainer"
  storage_account_name  = azurerm_storage_account.main.name
}
```

**Characteristics:**
- Terraform handles existence checks automatically
- Terraform determines the correct order (dependency graph)
- Idempotent - safe to run multiple times
- State tracking - Terraform knows what exists
- Easy to destroy - `terraform destroy` removes everything
- Plan before apply - see changes before they happen

## Part 2: Core Concepts Deep Dive (25 min)

### 1. Providers (Platform Integrations)

#### What is a Provider?

A **provider** is a plugin that enables Terraform to interact with an API. Think of it as a "driver" or "connector" to a specific platform.

#### Provider Architecture

```
┌──────────────────┐
│  Terraform Core  │  (Planning, state management, graph)
└────────┬─────────┘
         │
    ┌────┴────┐
    │ Plugin  │  Communication protocol
    │Protocol │  (gRPC)
    └────┬────┘
         │
┌────────┴─────────┐
│   Provider       │  Azure provider (azurerm)
│   Plugin         │
└────────┬─────────┘
         │
         │ REST API calls
         │
┌────────┴─────────┐
│  Azure Resource  │  Actual Azure infrastructure
│    Manager API   │
└──────────────────┘
```

#### Provider Configuration

```hcl
terraform {
  required_version = ">= 1.0"
  
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"  # Registry source
      version = "~> 3.0"             # Version constraint
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

# Provider configuration
provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
  
  # Optional: specific configuration
  # subscription_id = "..."
  # tenant_id       = "..."
}
```

#### Version Constraints

| Constraint | Meaning | Example |
|------------|---------|---------|
| `>= 3.0` | Greater than or equal | 3.0, 3.1, 4.0 accepted |
| `~> 3.0` | Pessimistic (any 3.x) | 3.99 ok, 4.0 not ok |
| `~> 3.10.0` | Patch updates only | 3.10.1 ok, 3.11.0 not ok |
| `= 3.0` | Exact version | Only 3.0 |

**Best Practice:** Use `~> 3.0` to allow minor updates while preventing breaking changes.

#### Multiple Provider Instances (Advanced)

```hcl
# Default provider for main region
provider "azurerm" {
  features {}
}

# Aliased provider for disaster recovery region
provider "azurerm" {
  alias    = "dr"
  features {}
  
  subscription_id = var.dr_subscription_id
}

# Use specific provider
resource "azurerm_resource_group" "main" {
  # Uses default provider
  name     = "main-rg"
  location = "francecentral"
}

resource "azurerm_resource_group" "dr" {
  provider = azurerm.dr  # Explicit provider
  name     = "dr-rg"
  location = "westus"
}
```

### 2. Resources (Infrastructure Objects)

#### What is a Resource?

A **resource** is the most important element in Terraform. It represents a single infrastructure object:
- Azure: Storage Account, Virtual Machine, Resource Group
- AWS: EC2 Instance, S3 Bucket, VPC
- Local: Files, scripts

#### Resource Syntax

```hcl
resource "RESOURCE_TYPE" "LOCAL_NAME" {
  # Configuration arguments
  argument1 = value1
  argument2 = value2
  
  # Nested blocks
  block_name {
    nested_argument = value
  }
}
```

**Components:**
- `RESOURCE_TYPE`: Provider + resource type (e.g., `azurerm_storage_account`)
- `LOCAL_NAME`: Your chosen name for this resource instance
- **Full identifier:** `azurerm_storage_account.main`

#### Real Example

```hcl
resource "azurerm_storage_account" "example" {
  # Required arguments
  name                     = "mystorageaccount"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = "francecentral"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  
  # Optional arguments
  enable_https_traffic_only = true
  min_tls_version          = "TLS1_2"
  
  # Nested block
  blob_properties {
    versioning_enabled = true
  }
  
  # Meta-arguments (special Terraform arguments)
  lifecycle {
    prevent_destroy = true
  }
  
  tags = {
    Environment = "Production"
    ManagedBy   = "Terraform"
  }
}
```

#### Resource References

Resources can reference other resources, creating **dependencies**:

```hcl
resource "azurerm_resource_group" "main" {
  name     = "my-rg"
  location = "francecentral"
}

resource "azurerm_storage_account" "main" {
  name                = "mystorageacct"
  resource_group_name = azurerm_resource_group.main.name  # Reference!
  location            = azurerm_resource_group.main.location  # Reference!
  # ... other arguments
}
```

**Terraform automatically knows:**
- Resource Group must be created FIRST
- Storage Account depends on Resource Group
- If Resource Group is destroyed, Storage Account must go first

#### Meta-Arguments (Work on All Resources)

```hcl
resource "azurerm_storage_account" "example" {
  # ... normal arguments ...
  
  # Meta-argument: Create multiple instances
  count = 3
  name  = "storage${count.index}"
  
  # Meta-argument: Conditional creation
  count = var.environment == "prod" ? 1 : 0
  
  # Meta-argument: Create from map
  for_each = toset(["dev", "staging", "prod"])
  name     = "storage-${each.key}"
  
  # Meta-argument: Dependencies
  depends_on = [
    azurerm_resource_group.main
  ]
  
  # Meta-argument: Lifecycle rules
  lifecycle {
    create_before_destroy = true
    prevent_destroy       = true
    ignore_changes        = [tags]
  }
}
```

### 3. State (The Source of Truth)

#### What is State?

The **state file** (`terraform.tfstate`) is Terraform's database. It contains:
- Mapping of resources in `.tf` files to real-world infrastructure
- Resource metadata and attributes
- Dependency information
- Performance cache (for large infrastructures)

#### State File Example

```json
{
  "version": 4,
  "terraform_version": "1.5.0",
  "serial": 3,
  "lineage": "a1b2c3d4-e5f6-7890-abcd-ef1234567890",
  "outputs": {
    "storage_account_name": {
      "value": "mystorageacct123",
      "type": "string"
    }
  },
  "resources": [
    {
      "mode": "managed",
      "type": "azurerm_storage_account",
      "name": "main",
      "provider": "provider[\"registry.terraform.io/hashicorp/azurerm\"]",
      "instances": [
        {
          "schema_version": 3,
          "attributes": {
            "id": "/subscriptions/.../resourceGroups/my-rg/providers/Microsoft.Storage/storageAccounts/mystorageacct123",
            "name": "mystorageacct123",
            "location": "francecentral",
            "account_tier": "Standard",
            "primary_blob_endpoint": "https://mystorageacct123.blob.core.windows.net/",
            "primary_access_key": "SENSITIVE_VALUE_REDACTED"
          }
        }
      ]
    }
  ]
}
```

#### Why State is Critical

**1. Mapping to Real World**
```hcl
# Your config
resource "azurerm_storage_account" "main" {
  name = "mystorageacct"
  # ...
}
```

Without state, Terraform wouldn't know:
- Does this already exist in Azure?
- What's the current configuration?
- What needs to change?

**2. Performance**
For large infrastructures (1000+ resources), querying all resources every time would be slow. State caches this information.

**3. Metadata**
State stores information not in the config:
- Resource IDs
- Generated values (passwords, IPs)
- Computed attributes

**4. Collaboration**
Multiple team members can work together by sharing state in remote backend (Azure Storage, Terraform Cloud).

#### State Security Concerns

⚠️ **State files contain sensitive data!**

```json
{
  "attributes": {
    "primary_access_key": "abcdef123456...",
    "connection_string": "DefaultEndpointsProtocol=https;AccountName=...",
    "administrator_login_password": "SuperSecret123!"
  }
}
```

**Best Practices:**
- ✅ Store state in encrypted remote backend (Azure Storage with encryption)
- ✅ Add `*.tfstate*` to `.gitignore`
- ✅ Use sensitive variables and mark outputs as sensitive
- ✅ Limit access to state storage
- ❌ Never commit state to Git
- ❌ Never edit state files manually

#### Remote State (Production Pattern)

```hcl
terraform {
  backend "azurerm" {
    resource_group_name  = "terraform-state-rg"
    storage_account_name = "tfstatestorage"
    container_name       = "tfstate"
    key                  = "prod.terraform.tfstate"
    
    # Encryption and security
    use_azuread_auth = true
  }
}
```

**Benefits:**
- Encrypted storage
- Team collaboration
- State locking (prevents concurrent modifications)
- Versioning and backup
- Access from anywhere

### 4. Dependency Graph

Terraform builds a **dependency graph** to determine the order of operations.

#### Example Infrastructure

```hcl
resource "azurerm_resource_group" "main" {
  name     = "my-rg"
  location = "francecentral"
}

resource "azurerm_virtual_network" "main" {
  name                = "my-vnet"
  resource_group_name = azurerm_resource_group.main.name  # Depends on RG
  location            = azurerm_resource_group.main.location
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "web" {
  name                 = "web-subnet"
  resource_group_name  = azurerm_resource_group.main.name  # Depends on RG
  virtual_network_name = azurerm_virtual_network.main.name  # Depends on VNet
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "db" {
  name                 = "db-subnet"
  resource_group_name  = azurerm_resource_group.main.name  # Depends on RG
  virtual_network_name = azurerm_virtual_network.main.name  # Depends on VNet
  address_prefixes     = ["10.0.2.0/24"]
}
```

#### Dependency Graph Visualization

```
azurerm_resource_group.main
        │
        │
        ▼ 
azurerm_virtual_network.main 
        │
        ├──────────────────┐
        │                  │
        ▼                  ▼
azurerm_subnet.web    azurerm_subnet.db
   (parallel)          (parallel)
```

**Terraform creates in this order:**
1. Resource Group (no dependencies)
2. Virtual Network (depends on RG)
3. Both Subnets **in parallel** (both depend on VNet, not on each other)

#### Viewing the Graph

```bash
# Generate dependency graph (requires Graphviz)
terraform graph | dot -Tsvg > graph.svg
```

#### Explicit Dependencies

Sometimes Terraform can't infer dependencies automatically:

```hcl
resource "azurerm_storage_account" "main" {
  name = "mystorageacct"
  # ...
}

resource "azurerm_role_assignment" "storage_access" {
  # This must happen AFTER storage account is fully ready
  scope                = azurerm_storage_account.main.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = var.app_principal_id
  
  # Explicit dependency to ensure storage is 100% ready
  depends_on = [
    azurerm_storage_account.main
  ]
}
```

---

## Part 3: The Terraform Workflow (20 min)

### The Four Core Commands

```
   Write Code
      ↓
   terraform init      ← Download providers, initialize backend
      ↓
   terraform plan      ← Preview changes, no modifications
      ↓
   terraform apply     ← Execute changes, update state
      ↓
   terraform destroy   ← Remove all managed infrastructure
```

### 1. `terraform init` - Initialize

**Purpose:** Prepare the working directory for Terraform operations.

**What it does:**
1. Downloads required provider plugins
2. Initializes backend (state storage)
3. Downloads modules (if any)
4. Creates `.terraform` directory
5. Creates `.terraform.lock.hcl` (dependency lock file)

**Example Output:**
```
$ terraform init

Initializing the backend...

Initializing provider plugins...
- Finding hashicorp/azurerm versions matching "~> 3.0"...
- Installing hashicorp/azurerm v3.75.0...
- Installed hashicorp/azurerm v3.75.0 (signed by HashiCorp)

Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.

Terraform has been successfully initialized!
```

**When to run:**
- ✅ First time in a new directory
- ✅ After adding/changing providers
- ✅ After modifying backend configuration
- ✅ After cloning a repository

**Flags:**
```bash
terraform init -upgrade        # Upgrade providers to latest allowed version
terraform init -reconfigure    # Reconfigure backend
terraform init -backend=false  # Skip backend initialization
```

### 2. `terraform plan` - Preview Changes

**Purpose:** Show what Terraform will do WITHOUT making any changes.

**What it does:**
1. Refreshes state (queries current infrastructure)
2. Compares desired state (.tf files) with actual state
3. Generates execution plan
4. Shows what will be created, changed, or destroyed

**Example Output:**
```
$ terraform plan

Terraform will perform the following actions:

  # azurerm_resource_group.main will be created
  + resource "azurerm_resource_group" "main" {
      + id       = (known after apply)
      + location = "francecentral"
      + name     = "my-rg"
    }

  # azurerm_storage_account.main will be created
  + resource "azurerm_storage_account" "main" {
      + account_replication_type = "LRS"
      + account_tier             = "Standard"
      + id                       = (known after apply)
      + location                 = "francecentral"
      + name                     = "mystorageacct123"
      + primary_access_key       = (sensitive value)
      + primary_blob_endpoint    = (known after apply)
      + resource_group_name      = "my-rg"
    }

Plan: 2 to add, 0 to change, 0 to destroy.
```

**Symbols:**
- `+` Create resource
- `-` Destroy resource
- `~` Update in-place
- `-/+` Destroy and recreate (can't update in-place)
- `<=` Read data source

**Flags:**
```bash
terraform plan -out=tfplan       # Save plan to file
terraform plan -destroy          # Plan to destroy everything
terraform plan -target=RESOURCE  # Plan changes for specific resource only
terraform plan -var="env=prod"   # Pass variable
```

**Best Practice:**
ALWAYS run `terraform plan` before `apply` in production!

### 3. `terraform apply` - Execute Changes

**Purpose:** Apply the changes to reach the desired state.

**What it does:**
1. Generates execution plan (like `terraform plan`)
2. Asks for confirmation (unless `-auto-approve`)
3. Executes the plan (creates/modifies/deletes resources)
4. Updates state file
5. Shows outputs

**Example Output:**
```
$ terraform apply

Terraform will perform the following actions:
  # ... plan output ...

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

azurerm_resource_group.main: Creating...
azurerm_resource_group.main: Creation complete after 2s [id=/subscriptions/.../resourceGroups/my-rg]
azurerm_storage_account.main: Creating...
azurerm_storage_account.main: Still creating... [10s elapsed]
azurerm_storage_account.main: Creation complete after 24s [id=...]

Apply complete! Resources: 2 added, 0 changed, 0 destroyed.

Outputs:

storage_account_name = "mystorageacct123"
```

**Flags:**
```bash
terraform apply -auto-approve      # Skip confirmation prompt
terraform apply tfplan             # Apply saved plan file
terraform apply -target=RESOURCE   # Apply changes to specific resource
terraform apply -parallelism=10    # Number of concurrent operations
```

**Using Saved Plans (Production Pattern):**
```bash
# Step 1: Create and review plan
terraform plan -out=tfplan
cat tfplan  # Review (binary format)

# Step 2: Apply exact plan (no surprises)
terraform apply tfplan
```

### 4. `terraform destroy` - Remove Infrastructure

**Purpose:** Destroy all resources managed by Terraform.

**What it does:**
1. Generates destroy plan
2. Asks for confirmation
3. Destroys resources in reverse dependency order
4. Updates state (marks resources as removed)

**Example Output:**
```
$ terraform destroy

Terraform will perform the following actions:

  # azurerm_storage_account.main will be destroyed
  - resource "azurerm_storage_account" "main" {
      - name = "mystorageacct123" -> null
      # ...
    }

  # azurerm_resource_group.main will be destroyed
  - resource "azurerm_resource_group" "main" {
      - name = "my-rg" -> null
      # ...
    }

Plan: 0 to add, 0 to change, 2 to destroy.

Do you really want to destroy all resources?
  Enter a value: yes

azurerm_storage_account.main: Destroying... [id=...]
azurerm_storage_account.main: Destruction complete after 15s
azurerm_resource_group.main: Destroying... [id=...]
azurerm_resource_group.main: Destruction complete after 45s

Destroy complete! Resources: 2 destroyed.
```

**Flags:**
```bash
terraform destroy -auto-approve     # Skip confirmation
terraform destroy -target=RESOURCE  # Destroy specific resource only
```

⚠️ **Warnings:**
- `destroy` is **irreversible** (data loss!)
- Always run `plan -destroy` first to review
- Some resources have `prevent_destroy` lifecycle rules
- Backups are your responsibility

### Workflow Best Practices

#### Development Workflow
```bash
# 1. Write code in .tf files
vim main.tf

# 2. Format code
terraform fmt

# 3. Validate syntax
terraform validate

# 4. Preview changes
terraform plan

# 5. Apply if plan looks good
terraform apply

# 6. Verify outputs
terraform output
```

#### Production Workflow
```bash
# 1. Create feature branch
git checkout -b feature/add-database

# 2. Make changes
vim database.tf

# 3. Validate
terraform fmt -check
terraform validate

# 4. Plan and save
terraform plan -out=tfplan

# 5. Review plan file
terraform show tfplan

# 6. Commit code (not plan file)
git add database.tf
git commit -m "Add PostgreSQL database"

# 7. Open pull request for review

# 8. After approval, apply
terraform apply tfplan

# 9. Tag release
git tag v1.2.0
git push --tags
```

### Additional Useful Commands

```bash
# Format code to canonical style
terraform fmt

# Validate configuration syntax
terraform validate

# Show current state
terraform show

# List resources in state
terraform state list

# Show specific resource
terraform state show azurerm_storage_account.main

# Show outputs
terraform output

# Show output value
terraform output storage_account_name

# Refresh state from real infrastructure
terraform apply -refresh-only

# Import existing resource
terraform import azurerm_resource_group.main /subscriptions/.../resourceGroups/existing-rg

# Replace resource
terraform apply -replace=azurerm_storage_account.main
```

---

## Part 4: Practical Workflow Example (5 min)

### Scenario: Deploy a Storage Account

**Step 1: Write Configuration**
```hcl
# main.tf
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

resource "azurerm_resource_group" "main" {
  name     = "storage-rg"
  location = "francecentral"
}

resource "azurerm_storage_account" "main" {
  name                     = "mystorageacct12345"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

output "storage_account_name" {
  value = azurerm_storage_account.main.name
}
```

**Step 2: Initialize**
```bash
$ terraform init
# Downloads azurerm provider
```

**Step 3: Plan**
```bash
$ terraform plan
# Shows: Plan: 2 to add, 0 to change, 0 to destroy
```

**Step 4: Apply**
```bash
$ terraform apply
# Creates resource group, then storage account
# Output: storage_account_name = "mystorageacct12345"
```

**Step 5: Make a Change**
```hcl
# Change LRS to GRS
resource "azurerm_storage_account" "main" {
  # ...
  account_replication_type = "GRS"  # Changed!
}
```

**Step 6: Plan Again**
```bash
$ terraform plan
# Shows: ~ update in-place for storage account
```

**Step 7: Apply Update**
```bash
$ terraform apply
# Updates storage account replication
```

**Step 8: Destroy**
```bash
$ terraform destroy
# Removes storage account, then resource group
```

---

## Summary & Key Takeaways

### Core Concepts Recap

1. **Declarative vs. Imperative**
   - Terraform = What (desired state)
   - Scripts = How (step-by-step)

2. **Providers**
   - Plugins that connect to APIs
   - Download during `terraform init`
   - Version constraints for stability

3. **Resources**
   - Infrastructure objects
   - Create dependencies automatically
   - Meta-arguments for advanced behavior

4. **State**
   - Source of truth
   - Maps config to reality
   - Contains sensitive data (protect it!)

5. **Workflow**
   - `init` → `plan` → `apply` → `destroy`
   - Always plan before apply
   - State tracks everything

### What's Next?

In Exercise 1, you'll:
- Apply these concepts hands-on
- Create your first resources
- Experience the workflow
- Understand state through practice

---

**Ready to get hands-on? Let's move to Exercise 1!**
