# Exercise 4: Full Stack Deployment

> **Quick Reference**: Keep the [Terraform Quick Reference Card](../quick-reference.md) handy for commands and syntax!

## Learning Objectives

- Deploy a complete application infrastructure
- Work with multiple resource types
- Manage environment-specific configurations
- Use locals for computed values
- Implement proper security practices
- Understand lifecycle rules and prevent_destroy

## Theory (15 min)

### Real-World Infrastructure

Production applications require multiple components:
- **Compute:** Where your application runs (App Service, VMs, containers)
- **Database:** Persistent data storage
- **Networking:** Connectivity and security
- **Storage:** Static files, backups, logs
- **Configuration:** Environment variables, connection strings

### Locals

Locals are named values computed from variables and resources:

```hcl
locals {
  common_tags = merge(var.tags, {
    Environment = var.environment
    Deployed    = timestamp()
  })
  
  app_name = "${var.project_name}-${var.environment}"
}

resource "azurerm_app_service" "main" {
  tags = local.common_tags
}
```

### Lifecycle Rules

Control how Terraform handles create/update/delete operations:

```hcl
resource "azurerm_postgresql_server" "main" {
  # ... configuration ...
  
  lifecycle {
    prevent_destroy = true  # Protect from accidental deletion
    ignore_changes  = [tags]  # Ignore external tag changes
  }
}
```

### Environment Management Strategies

**Option 1: Workspaces**
```bash
terraform workspace new dev
terraform workspace new prod
terraform apply
```

**Option 2: Separate Directories** (recommended for this course)
```
environments/
├── dev/
│   ├── main.tf
│   └── terraform.tfvars
└── prod/
    ├── main.tf
    └── terraform.tfvars
```

**Option 3: Variable Files**
```bash
terraform apply -var-file="dev.tfvars"
terraform apply -var-file="prod.tfvars"
```

### Security Best Practices

1. **Never hardcode secrets** - use Azure Key Vault or environment variables
2. **Use managed identities** when possible
3. **Enable firewall rules** restrict access to known IPs
4. **Encrypt data** in transit and at rest
5. **Minimal permissions** - principle of least privilege

## What We'll Build

```
┌───────────────────────────────────────────────┐
│ Resource Group                                │
│                                               │
│  ┌───────────────┐      ┌──────────────────┐  │
│  │  App Service  │─────▶│ PostgreSQL DB    │  │
│  │  (Free Tier)  │      │ (Basic Tier)     │  │
│  └───────────────┘      └──────────────────┘  │
│         │                                     │
│         │                                     │
│         ▼                                     │
│  ┌───────────────┐                            │
│  │ Storage Acct  │                            │
│  │ (Static files)│                            │
│  └───────────────┘                            │
│                                               │
└───────────────────────────────────────────────┘
```

## Exercise Instructions (35 min)

### Part 1: Complete the Starter Template (15 min)

1. **Navigate to starter directory:**
   ```bash
   cd exercise-4/starter
   ```

2. **Review the provided files:**
   - `main.tf` - Provider and resource group
   - `variables.tf` - Variable declarations
   - `locals.tf` - Local computed values
   - `app-service.tf` - Web application (needs completion)
   - `database.tf` - PostgreSQL database (needs completion)
   - `storage.tf` - Storage account (needs completion)
   - `outputs.tf` - Important output values
   - `terraform.tfvars.example` - Example configuration

3. **Create terraform.tfvars:**
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```
   
   Edit with unique values:
   - `project_name` - must be globally unique
   - `db_admin_username` - database admin user
   - `db_admin_password` - strong password (16+ chars)

4. **Complete the TODOs in each file**

### Part 2: Deploy Infrastructure (10 min)

1. **Initialize and plan:**
   ```bash
   terraform init
   terraform fmt -recursive
   terraform validate
   terraform plan -out=tfplan
   ```

2. **Review the plan carefully:**
   - Check resource count
   - Verify naming conventions
   - Confirm locations and SKUs

3. **Apply the plan:**
   ```bash
   terraform apply tfplan
   ```
   
   This will take 5-10 minutes (database takes longest).

4. **Save outputs:**
   ```bash
   terraform output > deployment-info.txt
   terraform output app_service_url
   ```

### Part 3: Verify Deployment (5 min)

1. **Check App Service:**
   ```bash
   curl $(terraform output -raw app_service_url)
   ```
   
   Or open in browser - you should see the default Azure App Service page.

2. **Verify in Azure Portal:**
   - Navigate to your resource group
   - Verify all resources exist:
     - App Service Plan
     - App Service (Web App)
     - PostgreSQL Server
     - PostgreSQL Database
     - Storage Account

3. **Test database connectivity:**
   ```bash
   az postgres server show \
     --resource-group $(terraform output -raw resource_group_name) \
     --name $(terraform output -raw database_server_name)
   ```

### Part 4: Modify Configuration (5 min)

1. **Update App Service settings:**
   
   Edit `terraform.tfvars` and add/modify:
   ```hcl
   app_settings = {
     "ENVIRONMENT" = "development"
     "DEBUG"       = "true"
   }
   ```

2. **Apply changes:**
   ```bash
   terraform plan
   terraform apply
   ```
   
   Notice: App Service is updated in-place (no downtime).

3. **Verify settings:**
   ```bash
   az webapp config appsettings list \
     --name $(terraform output -raw app_service_name) \
     --resource-group $(terraform output -raw resource_group_name)
   ```

### Part 5: Cleanup (IMPORTANT!)

```bash
# Review what will be destroyed
terraform plan -destroy

# Destroy all resources
terraform destroy
```

**Note:** If database has `prevent_destroy = true`, you'll need to either:
- Comment out that lifecycle block
- Or use: `terraform destroy -auto-approve` (after careful review)

## Key Takeaways

1. **Complex infrastructure** is just multiple resources defined declaratively
2. **Locals** help reduce repetition and compute derived values
3. **Database passwords** should never be in code (use variables marked sensitive)
4. **Lifecycle rules** provide important safeguards
5. **Dependencies** are usually automatic, but can be explicit when needed
6. **Always destroy** non-production resources to avoid costs

## Common Issues

| Problem | Solution |
|---------|----------|
| Database name already exists | Choose a more unique project name |
| Password too simple | Use 16+ chars with uppercase, lowercase numbers, symbols |
| App Service name taken | Add random suffix to project name |
| Deployment timeout | Database creation can take 10+ minutes, be patient |
| Cost concerns | Use Free tier for App Service, Basic/B_Gen5_1 for database |

## Architecture Decisions Explained

**Connection Security:**
- Database firewall allows only Azure services
- In production, use Private Endpoints
- App Service uses system-assigned managed identity (in real apps)

## Next Steps

**Continue learning:**
- [Terraform Documentation](https://www.terraform.io/docs)
- [Azure Architecture Center](https://docs.microsoft.com/en-us/azure/architecture/)
- [HashiCorp Learn](https://learn.hashicorp.com/terraform)
- Practice with your own projects!

---

**Need help?** Check the [solution](../solution/) folder, but try to complete the exercise on your own first!
