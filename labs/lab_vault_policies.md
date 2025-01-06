# Vault Policies Hands-on Lab

## Overview
In this lab, you will learn how to create and manage HashiCorp Vault policies. Policies are used to define what actions users and entities can perform within Vault. You'll create different types of policies and test their effectiveness using the Vault CLI.

**Time to Complete**: 30-45 minutes

**Preview Mode**: Use `Cmd/Ctrl + Shift + V` in VSCode to see a nicely formatted version of this lab!

## How to Use This Hands-On Lab

1. **Create a Codespace** from this repo (click the button below).  
2. Once the Codespace is running, open the integrated terminal.
3. Follow the instructions in each **lab** to complete the exercises.

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/btkrausen/vault-codespaces)

## Objectives
By completing this lab, you will learn how to:
1. Create and manage Vault policies
2. Test policy permissions
3. Assign policies to tokens
4. Use policy path templating
5. Understand policy precedence

## Steps

### Part 1: Creating Your First Policy

1. First, verify that Vault is running and you're authenticated:
```bash
# Log in with a valid token
vault login root

# Check the status of the service
vault status
```

2. Create a new file called `readonly-policy.hcl` in your VS Code editor with these contents:
```hcl
# Allow read-only access to secrets in the 'secret' path
path "secret/data/*" {
  capabilities = ["read", "list"]
}
```

3. Write this policy to Vault:
```bash
vault policy write readonly-policy readonly-policy.hcl
```

4. Verify the policy was created:
```bash
vault policy list
vault policy read readonly-policy
```

### Part 2: Testing Policy Restrictions

1. Create some test secrets:
```bash
# Create two test secrets
vault kv put secret/test-1 password="secret123"
vault kv put secret/test-2 api_key="abc123"
```

2. Create a token with the readonly policy:
```bash
vault token create -policy=readonly-policy
```

3. Copy the token value and set it in your environment:
```bash
export VAULT_TOKEN="<paste-token-here>"
```

4. Test the policy restrictions:
```bash
# These should work
vault kv get secret/test-1
vault kv list secret/

# These should fail
vault kv put secret/test-3 password="newpass"
vault kv delete secret/test-1
```

### Part 3: Creating a More Complex Policy

1. Create a new file called `app-policy.hcl` with these contents:
```hcl
# Allow management of app-specific secrets
path "secret/data/app/${identity.entity.name}/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

# Deny access to other paths
path "secret/data/app/*" {
  capabilities = ["deny"]
}

# Allow listing of secret mount
path "secret/metadata/*" {
  capabilities = ["list"]
}
```

2. Write the new policy:
```bash
vault policy write app-policy app-policy.hcl
```

3. Create an entity and token for testing:
```bash
# Create an entity
vault auth enable userpass
vault write auth/userpass/users/app1 \
    password="password123" \
    policies="app-policy"

# Login with the user
vault login -method=userpass \
    username=app1 \
    password=password123
```

4. Test the templated policy:
```bash
# These should succeed
vault kv put secret/app/app1/config api_key="test123"
vault kv get secret/app/app1/config

# These should fail
vault kv put secret/app/other-app/config api_key="test123"
vault kv put secret/test-3 password="newpass"
```

### Part 4: Understanding Policy Precedence

1. Create a new file called `mixed-policy.hcl`:
```hcl
# Grant some permissions
path "secret/data/shared/*" {
  capabilities = ["create", "read", "update", "list"]
}

# But deny specific paths
path "secret/data/shared/restricted/*" {
  capabilities = ["deny"]
}
```

2. Write and test the policy:
```bash
vault policy write mixed-policy mixed-policy.hcl
vault token create -policy=mixed-policy

# Set your token to the new one
export VAULT_TOKEN="<new-token>"

# Test the permissions
vault kv put secret/shared/public data="public-info"    # Should work
vault kv put secret/shared/restricted/secret data="sensitive"  # Should fail
```

## Cleanup
1. Return to your root token:
```bash
export VAULT_TOKEN="root"
```

2. Remove the policies and secrets:
```bash
vault policy delete readonly-policy
vault policy delete app-policy
vault policy delete mixed-policy
vault kv delete secret/test-1
vault kv delete secret/test-2
vault kv delete secret/app/app1/config
vault kv delete secret/shared/public
```

## Challenge Exercise
Create a policy that:
- Allows read access to all secrets in `secret/data/team-a/*`
- Allows write access only to `secret/data/team-a/projects/*`
- Denies access to `secret/data/team-a/admin/*`
- Allows listing capabilities on all paths

## Learning Resources
- [Vault Policies Documentation](https://developer.hashicorp.com/vault/docs/concepts/policies)
- [Policy Syntax Documentation](https://developer.hashicorp.com/vault/docs/concepts/policies#policy-syntax)
- [Policy Templates Documentation](https://developer.hashicorp.com/vault/docs/concepts/policies#policy-templates)
