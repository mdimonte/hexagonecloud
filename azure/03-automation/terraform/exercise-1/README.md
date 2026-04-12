# Exercise 1: Hello Terraform

> **Quick Reference**: Keep the [Terraform Quick Reference Card](../quick-reference.md) handy for commands and syntax!

## Learning Objectives

- Install and verify Terraform
- Understand the Terraform workflow (init, plan, apply, destroy)
- Create your first resource using local provider
- Observe state file and understand its purpose
- Modify infrastructure and see changes applied

## Reminder on the Terraform Workflow

```
┌─────────────┐
│ Write .tf   │  Define resources in HCL
└──────┬──────┘
       │
       ▼
┌─────────────┐
│ terraform   │  Download provider plugins
│   init      │  Initialize working directory
└──────┬──────┘
       │
       ▼
┌─────────────┐
│ terraform   │  Preview changes
│   plan      │  Show what will happen
└──────┬──────┘
       │
       ▼
┌─────────────┐
│ terraform   │  Execute changes
│   apply     │  Create/modify/delete resources
└──────┬──────┘
       │
       ▼
┌─────────────┐
│ terraform   │  Remove all resources
│  destroy    │  Clean up
└─────────────┘
```

### Understanding Providers

Providers are plugins that let Terraform interact with APIs:
- **azurerm:** Azure Resource Manager
- **aws:** Amazon Web Services
- **google:** Google Cloud Platform
- **local:** Local file system (we'll use this first!)

## Exercise Instructions (40 min)

### Part 1: Your First Terraform Configuration (15 min)

1. **Navigate to the starter directory:**
   ```bash
   cd exercise-1/starter
   ```

2. **Examine the starter file `main.tf`:**
   - Provider block: Declares we'll use the local provider
   - Resource block: Creates a local file

3. **Initialize Terraform:**
   ```bash
   terraform init
   ```
   
   **What happened?**
   - Downloaded the `local` provider plugin
   - Created `.terraform` directory
   - Created `.terraform.lock.hcl` (dependency lock file)

4. **Preview changes:**
   ```bash
   terraform plan
   ```
   
   **Observe the output:**
   - `+` means resource will be created
   - Shows all attributes of the resource

5. **Apply changes:**
   ```bash
   terraform apply
   ```
   
   Type `yes` when prompted.
   
   **Verify:**
   ```bash
   cat hello.txt
   ls -la
   ```

6. **Examine the state file:**
   ```bash
   cat terraform.tfstate
   ```
   
   **Key points:**
   - State maps Terraform config to real-world resources
   - Contains sensitive data - don't commit to Git!
   - JSON format, but don't edit manually

### Part 2: Modify Infrastructure (10 min)

1. **Edit `main.tf`:**
   - Change the content of the file
   - Add a second file resource (copy and modify the first)

2. **Preview changes:**
   ```bash
   terraform plan
   ```
   
   **Notice:**
   - `~` means resource will be updated in-place
   - `+` for the new resource

3. **Apply changes:**
   ```bash
   terraform apply
   ```

4. **Verify both files exist:**
   ```bash
   ls -la *.txt
   cat hello.txt
   cat welcome.txt
   ```

### Part 3: Terraform State Commands (5 min)

```bash
# List all resources in state
terraform state list

# Show details of a specific resource
terraform state show local_file.hello

# Show entire state (same as cat terraform.tfstate)
terraform show
```

### Part 4: Destroy Resources (5 min)

```bash
# Preview what will be destroyed
terraform plan -destroy

# Destroy all resources
terraform destroy
```

Type `yes` when prompted.

**Verify cleanup:**
```bash
ls -la *.txt  # Files should be gone
cat terraform.tfstate  # State should be empty (resources: [])
```

### Part 5: Git Best Practices when working with Terraform (5 min)

1. **Create `.gitignore`:**
   ```bash
   cat > .gitignore << 'EOF'
   # Terraform
   .terraform/
   *.tfstate
   *.tfstate.*
   crash.log
   *.tfvars
   override.tf
   override.tf.json
   *_override.tf
   *_override.tf.json
   EOF
   ```

2. **Commit your work:**
   ```bash
   git add main.tf .gitignore
   git commit -m "Exercise 1: Hello Terraform completed"
   ```

## Key Takeaways

1. **Terraform workflow:** init → plan → apply → destroy
2. **State file** tracks real-world resources (never edit manually!)
3. **Plan before apply** to preview changes safely
4. **Declarative syntax:** You define "what", Terraform handles "how"
5. **Git ignore** state files and secrets

## Common Issues

| Problem | Solution |
|---------|----------|
| Command not found | Ensure Terraform is installed: `terraform version` |
| Lock file errors | Delete `.terraform.lock.hcl` and run `terraform init` again |
| Permission denied | Check file permissions or run with appropriate privileges |
| Provider not found | Run `terraform init` first |

## Challenge (Optional)

Try these on your own if you have time:
1. Create 5 different text files with different content
2. Use file permissions: `file_permission = "0644"`
3. Research and use the `local_sensitive_file` resource
4. What happens if you delete a file manually, then run `terraform plan`?

## Next Steps

Now that the basics are coverd, let's move on to [Exercise 2: First Azure Resource](../exercise-2/) where you'll deploy first real cloud infrastructure!

---

**Need help?** Check the [solution](../solution/) folder, but try to complete the exercise on your own first!
