# Hands-on Lab: Integrating HashiCorp Vault with Terraform

## Overview
In this lab, you will learn how to integrate HashiCorp Vault with Terraform using proper authentication and authorization. You will create a new Key-Value secrets engine, write secrets to it, create a dedicated policy and token for Terraform, and then use Terraform to access and output these secrets.

**Time Required:** ~45 minutes

**Preview Mode**: Use `Cmd/Ctrl + Shift + V` in VSCode to see a nicely formatted version of this lab!

## How to Use This Hands-On Lab

1. **Create a Codespace** from this repo (click the button below).  
2. Once the Codespace is running, open the integrated terminal.
3. Follow the instructions in each **lab** to complete the exercises.

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/btkrausen/vault-codespaces)

## Steps

### Step 1: Verify Vault Status

1. Open your terminal, authenticate, and verify Vault is running in dev mode:
```bash
# Log in with a valid token
vault login root

# Check the status of Vault
vault status
```

You should see output indicating Vault is initialized and unsealed.

### Step 2: Create a New KV Secrets Engine

1. Enable a new KV version 2 secrets engine:
```bash
vault secrets enable -path=kv kv-v2
```

2. Write some example secrets:
```bash
# Write a database credential secret
vault kv put kv/database/config username="db_user" password="db_password123"

# Write an API key secret
vault kv put kv/api/keys development="dev_api_key_123" production="prod_api_key_456"
```

3. Verify the secrets were written correctly:
```bash
vault kv get kv/database/config
vault kv get kv/api/keys
```

### Step 3: Create a Vault Policy for Terraform

1. In VSCode, create a new file named `terraform-policy.hcl` (right click in the left navigation pane):
```hcl
# Configure access to KV v2 secrets engine
path "kv/data/database/config" {
    capabilities = ["read"]
}

path "kv/data/api/keys" {
    capabilities = ["read"]
}

# Allow listing available secrets
path "kv/metadata/*" {
    capabilities = ["list"]
}
```

2. Write the policy to Vault:
```bash
vault policy write terraform terraform-policy.hcl
```

3. Verify the policy was created:
```bash
vault policy read terraform
```

### Step 4: Create a Token for Terraform

1. Create a token with the terraform policy:
```bash
vault token create \
    -policy=terraform \
    -display-name=terraform-config \
    -metadata=purpose="terraform-infrastructure" \
    -metadata=environment="dev" \
    -metadata=owner="infrastructure-team"
```

2. Save the token value from the output. You'll need this later. The output will look something like:
```
Key                       Value
---                       -----
token                     hvs.CAESIEJ9-xWawVtRW9G7d3A...
token_accessor            qROJGbssISX3NaRx3JaOh9X6
token_duration            768h
token_renewable           true
token_policies            ["default" "terraform"]
identity_policies         []
policies                  ["default" "terraform"]
token_meta_purpose        terraform-infrastructure
token_meta_environment    dev
token_meta_owner          infrastructure-team
```

### Step 5: Create Terraform Configuration Files

1. Using the CLI, create a new directory for your Terraform configuration:
```bash
mkdir vault-terraform-lab
cd vault-terraform-lab
```

2. Create a new file named `provider.tf` (right click the `vault-terraform-lab` directory in the left navigation pane):
```hcl
terraform {
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "~> 4.5.0"
    }
  }
}

provider "vault" {
  # Token will be loaded from environment variable VAULT_TOKEN
  # Vault address and port - running locally on the GitHub Codespace
  address = "http://127.0.0.1:8200"
}
```

3. Create a new file named `main.tf`:
```hcl
# Read database secrets from Vault
data "vault_kv_secret_v2" "database_creds" {
  mount = "kv"
  name  = "database/config"
}

# Read API Keys from Vault
data "vault_kv_secret_v2" "api_keys" {
  mount = "kv"
  name  = "api/keys"
}

# Example resource that would use the secrets
resource "null_resource" "example" {
  provisioner "local-exec" {
    command = "echo 'This is where you would use the secrets in your actual infrastructure'"
  }
}
```

4. Create a new file named `outputs.tf`:
```hcl
output "database_username" {
  value     = data.vault_kv_secret_v2.database_creds.data["username"]
  sensitive = true
}

output "database_password" {
  value     = data.vault_kv_secret_v2.database_creds.data["password"]
  sensitive = true
}

output "dev_api_key" {
  value     = data.vault_kv_secret_v2.api_keys.data["development"]
  sensitive = true
}

output "prod_api_key" {
  value     = data.vault_kv_secret_v2.api_keys.data["production"]
  sensitive = true
}
```

### Step 6: Initialize and Apply Terraform Configuration

1. Set the required environment variables:
```bash
export VAULT_TOKEN='<your-terraform-token>'  # Use the token created in Step 4.2 above
```
> If you didn't save the token from Step 4.2, simply run it again to create another token

2. Initialize the Terraform working directory:
```bash
terraform init
```

3. Verify the plan works with the restricted token:
```bash
terraform plan
```

4. Apply the Terraform configuration and confirm by typing `yes` (notice the secrets are marked as sensitive):
```bash
terraform apply
```

5. View the outputs defined in the `outputs.tf` ((notice the secrets are marked as sensitive)):
```bash
terraform output
```

Note: The outputs will be shown as sensitive values. To see the actual values, you can use:
```bash
terraform output database_username
terraform output database_password
terraform output dev_api_key
terraform output prod_api_key
```

### 🎉 Congrats, you've successfully integrated HashiCorp Terraform and Vault. Terraform was able to obtain secrets from Vault to use within the Terraform configuration.

## Challenge Exercises

1. Modify the policy to allow Terraform to write secrets as well as read them. Update the Terraform configuration to write a new secret.

2. Create a new KV secrets engine at a different path and update the policy and Terraform configuration to read secrets from both KV engines.

3. Implement token rotation by creating a new token with the same policy and updating your Terraform configuration to use it.

4. Add metadata to your secrets and modify the policy to allow Terraform to read the metadata.

## Clean Up

1. Unset the VAULT_TOKEN environment variable
```bash
unset VAULT_TOKEN
```

2. Revoke the Terraform token:
```bash
vault token revoke <your-terraform-token>
```

3. Delete the policy:
```bash
vault policy delete terraform
```

4. Destroy the Terraform resources:
```bash
terraform destroy
```

5. Delete the secrets from Vault:
```bash
vault kv delete kv/database/config
vault kv delete kv/api/keys
```

6. Disable the KV secrets engine:
```bash
vault secrets disable kv
```

## Conclusion

In this lab, you learned how to:
- Create and manage secrets in Vault's KV secrets engine
- Create a restricted policy for Terraform access
- Generate and use a dedicated token for Terraform
- Configure Terraform to authenticate with Vault
- Use Terraform to read secrets from Vault
- Output sensitive values safely using Terraform's output blocks

These practices form the foundation of secure secret management in a production environment. Key takeaways include:
- Always use the principle of least privilege when creating policies
- Use dedicated tokens with appropriate policies for service authentication
- Implement proper token rotation and revocation procedures
- Be cautious with sensitive output values

## Additional Resources

- [Vault Provider Documentation](https://registry.terraform.io/providers/hashicorp/vault/latest/docs)
- [Vault KV Secrets Engine Documentation](https://www.vaultproject.io/docs/secrets/kv/kv-v2)
- [Vault Policy Documentation](https://www.vaultproject.io/docs/concepts/policies)
- [Vault Token Documentation](https://www.vaultproject.io/docs/concepts/tokens)
- [Best Practices for Using Vault with Terraform](https://www.hashicorp.com/resources/best-practices-using-hashicorp-terraform-with-hashicorp-vault)