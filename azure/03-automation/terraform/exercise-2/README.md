# Exercise 2: First Azure Resource

> **Quick Reference**: Keep the [Terraform Quick Reference Card](../quick-reference.md) handy for commands and syntax!

## Learning Objectives

- Configure the Azure provider
- Use variables for flexible configuration
- Deploy an Azure Storage Account
- Use outputs to display important information
- Understand data types in Terraform
- Practice proper credential management

## Reminder on theory

### HCL (HashiCorp Configuration Language) Basics

**Blocks:** The building blocks of Terraform configuration
```hcl
block_type "label" "name" {
  argument = "value"
  nested_block {
    argument = "value"
  }
}
```

**Common Block Types:**
- `terraform {}` - Configure Terraform itself
- `provider {}` - Configure a provider
- `resource {}` - Define a resource to create
- `variable {}` - Declare an input variable
- `output {}` - Declare an output value
- `data {}` - Read existing resources

### Variables in Terraform

Variables make configurations flexible and reusable:

```hcl
# Declaration
variable "location" {
  type        = string
  description = "Azure region"
  default     = "francecentral"
}

# Usage
location = var.location
```

**Data Types:**
- `string` - Text values
- `number` - Numeric values
- `bool` - true/false
- `list(type)` - Ordered collection
- `map(type)` - Key-value pairs
- `object({})` - Complex structure

### Outputs

Outputs display values after apply and can be used by other configurations:

```hcl
output "storage_account_name" {
  value       = azurerm_storage_account.example.name
  description = "The name of the storage account"
}
```

### Azure Provider

The Azure Resource Manager (azurerm) provider manages Azure resources:
- Authentication via Azure CLI (we'll use this)
- Hundreds of resource types supported
- Continuous updates for new Azure services

## Exercise Instructions (45 min)

### Part 1: Authentication Setup (5 min)

1. **Verify Azure CLI is authenticated:**
   ```bash
   az account show
   ```
   
   If not logged in:
   ```bash
   az login
   ```

2. **Get your subscription ID:**
   ```bash
   az account list --output table
   ```
   
   Copy your subscription ID - you'll need it!

### Part 2: Complete the Starter Template (15 min)

1. **Navigate to the starter directory:**
   ```bash
   cd exercise-2/starter
   ```

2. **Examine the provided files:**
   - `main.tf` - Provider configuration (already complete)
   - `variables.tf` - Variable declarations (needs completion)
   - `storage.tf` - Storage account resource (needs completion)
   - `outputs.tf` - Output declarations (needs completion)
   - `terraform.tfvars.example` - Example variable values

3. **Create your variable values file:**
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```
   
   Edit `terraform.tfvars` with your values:
   - Change `project_name` to something unique (your name + date)
   - Set your preferred `location`
   - Add your `subscription_id`

4. **Complete the TODOs in each file:**
   - Follow the hints in comments
   - Reference the documentation links provided

### Part 3: Deploy to Azure (10 min)

1. **Initialize Terraform:**
   ```bash
   terraform init
   ```
   
   This will download the Azure provider (~100MB).

2. **Format your code:**
   ```bash
   terraform fmt
   ```

3. **Validate configuration:**
   ```bash
   terraform validate
   ```

4. **Preview changes:**
   ```bash
   terraform plan
   ```
   
   **Review carefully:**
   - Storage account name (must be globally unique)
   - Resource group name
   - Location
   - All tags

5. **Apply changes:**
   ```bash
   terraform apply
   ```
   
   This will take 1-2 minutes to create the resources.

### Part 4: Verify Deployment (5 min)

1. **Check outputs:**
   ```bash
   terraform output
   terraform output storage_account_name
   terraform output -json
   ```

2. **Verify in Azure Portal:**
   - Go to portal.azure.com
   - Navigate to Resource Groups
   - Find your resource group
   - Verify storage account exists

3. **Use Azure CLI:**
   ```bash
   az storage account list --output table
   az storage account show --name <your-storage-account-name> --output json
   ```

### Part 5: Modify and Update (5 min)

1. **Add tags in `terraform.tfvars`:**
   ```hcl
   tags = {
     Environment = "Learning"
     Course      = "Terraform-101"
     Student     = "YourName"
   }
   ```

2. **Plan and apply:**
   ```bash
   terraform plan
   terraform apply
   ```
   
   **Notice:** Only tags are updated (in-place update, no recreation)

### Part 6: Cleanup (5 min)

```bash
# Preview destruction
terraform plan -destroy

# Destroy all resources
terraform destroy
```

**Verify in Azure Portal** that resources are deleted.

## Expected Outcomes

By the end of this exercise, you should be able to:
- ✅ Configure the Azure provider
- ✅ Use variables and variable files
- ✅ Deploy an Azure Storage Account
- ✅ Use outputs to display information
- ✅ Modify existing infrastructure
- ✅ Understand Terraform data types

## Key Takeaways

1. **Variables** make configurations reusable and flexible
2. **terraform.tfvars** stores variable values (excluded from Git!)
3. **Outputs** display important information after apply
4. **Azure provider** requires authentication (we use Azure CLI)
5. **Resource names** must follow cloud provider rules (e.g., globally unique for storage)
6. **In-place updates** when possible (changing tags doesn't recreate resources)

## Common Issues

| Problem | Solution |
|---------|----------|
| Storage account name taken | Choose a more unique name (add random numbers) |
| Authentication failed | Run `az login` again |
| Subscription not found | Verify subscription ID in `terraform.tfvars` |
| Invalid location | Use `az account list-locations -o table` to find valid locations |
| Permission denied | Ensure you have Contributor role on subscription |

## Resource Naming Best Practices

Azure Storage Accounts have strict naming rules:
- 3-24 characters
- Lowercase letters and numbers only
- Globally unique across all of Azure

**Good names:**
- `mystorageacct12345`
- `studentjohndoe2024`
- `tfcourse20240412`

**Bad names:**
- `My-Storage` (uppercase, hyphens)
- `st` (too short)
- `storage` (not unique enough)

## Understanding the Code

**Resource Group:**
- Logical container for Azure resources
- Defines a location/region
- Used for organizing and managing resources together

**Storage Account:**
- General-purpose storage service
- Supports blobs, files, queues, tables
- `account_tier`: Standard (HDD) or Premium (SSD)
- `account_replication_type`: LRS (locally redundant storage)

## Challenge (Optional)

Try these on your own:
1. Add more tags to track your resources
2. Change the replication type to `GRS` (Geo-redundant storage)
3. Add a validation rule to the `location` variable to only allow specific regions
4. Create a second storage account in a different region
5. Research the `random_string` resource to generate unique names

## Next Steps

Great job deploying your first Azure resource! In [Exercise 3: Multi-Resource Infrastructure](../exercise-3/), you'll learn to deploy multiple related resources and understand dependencies.

---

**Need help?** Check the [solution](../solution/) folder, but try to complete the exercise on your own first!
