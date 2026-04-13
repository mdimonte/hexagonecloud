# Introduction to Terraform - 4-Hour Course

**Duration:** 4 hours  

## Course Overview

This hands-on introduction to Terraform will teach you Infrastructure as Code (IaC) fundamentals using Azure as the cloud provider. By the end of this course, you'll be able to define, deploy, and manage cloud infrastructure using declarative configuration files.

## Learning Objectives

- Understand Infrastructure as Code principles and benefits
- Write Terraform configurations using HCL syntax
- Manage cloud resources declaratively with Terraform
- Use variables, outputs, and modules effectively
- Apply best practices for state management and security
- Deploy a complete multi-tier application infrastructure

## Course Structure

### Hour 1: Foundations (60 min)
**Lecture:** [Terraform Foundations Deep Dive](./foundations.md) - Core concepts, declarative vs imperative, workflow  
**Exercise 1:** [Hello Terraform](./exercise-1/) - Local resources and basic workflow

**Topics Covered:**
- Declarative vs. Imperative infrastructure
- Providers, resources, and state fundamentals
- Dependency graphs and resource management
- The Terraform workflow: init, plan, apply, destroy

### Hour 2: Core Syntax & Resources (60 min)
**Theory:** HCL syntax, variables, outputs, data types  
**Exercise 2:** [First Azure Resource](./exercise-2/) - Deploy Azure Storage Account

### Hour 3: State & Modules (60 min)
**Theory:** State management, dependencies, modules  
**Exercise 3:** [Multi-Resource Infrastructure](./exercise-3/) - VNet + Subnets

### Hour 4: Best Practices & Real Scenarios (60 min)
**Theory:** Environments, remote state, security, troubleshooting  
**Exercise 4:** [Full Stack Deployment](./exercise-4/) - Web App + Database

## Prerequisites Setup

### 1. Install Terraform

**Linux/Mac:**
```bash
# Download and install (check latest version at terraform.io)
wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform
```

### 2. Install Azure CLI

```bash
# Linux
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
```

### 3. Authenticate with Azure

```bash
az login
az account list --output table
az account set --subscription "<your-subscription-id>"
```

### 4. Verify Setup

```bash
terraform version
az account show
```

## Project Structure

```
terraform/
├── README.md                 # This file
├── foundations.md            # Core concepts deep dive (Hour 1 lecture)
├── quick-reference.md        # Command & syntax cheat sheet
├── exercise-1/               # Hello Terraform
│   ├── README.md
│   ├── starter/
│   └── solution/
├── exercise-2/               # First Azure Resource
│   ├── README.md
│   ├── starter/
│   └── solution/
├── exercise-3/               # Multi-Resource Infrastructure
│   ├── README.md
│   ├── starter/
│   └── solution/
├── exercise-4/               # Full Stack Deployment
│   ├── README.md
│   ├── starter/
│   └── solution/
```

## Tips

1. **Print the quick reference** - keep [`quick-reference.md`](quick-reference.md) open during exercises
2. **Start each exercise with the starter template**
3. **Live demo the first workflow** - show init/plan/apply/destroy cycle in real-time
4. **Emphasize error reading skills** - Terraform errors are verbose but helpful
5. **Cost awareness** - destroy resources after exercises (`terraform destroy`)

## Cost Considerations

All exercises use Azure free tier resources where possible:

- Storage accounts: ~$0.02/day
- Virtual Networks: Free
- App Service (Free tier): Free
- Azure Database for PostgreSQL (Basic tier): ~$0.05/hour

**Important:** Always run `terraform destroy` after completing exercises to avoid charges.

## Quick Reference Commands

```bash
# Initialize Terraform
terraform init

# Format code
terraform fmt

# Validate configuration
terraform validate

# Preview changes
terraform plan

# Apply changes
terraform apply

# Show current state
terraform show

# List resources in state
terraform state list

# Destroy all resources
terraform destroy
```

## Common Issues & Solutions

| Issue | Solution |
|-------|----------|
| Authentication failed | Run `az login` again |
| Resource already exists | Check Azure Portal, may need to destroy old resources |
| State file locked | Wait for concurrent operation to complete, or break lease if stuck |
| Provider version mismatch | Run `terraform init -upgrade` |

## Getting Help

During the course:

- Check the solution folder if stuck (but try starter first!)
- Terraform's error messages are detailed - read them carefully

After the course:

- [Terraform Documentation](https://www.terraform.io/docs)
- [Azure Provider Documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [HashiCorp Learn](https://learn.hashicorp.com/terraform)

## Let's start with exercices

Start with [Exercise 1: Hello Terraform](./exercise-1/)
