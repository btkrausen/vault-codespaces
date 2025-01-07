# HashiCorp Vault CLI Lab

## 🎯 Learning Objectives
- Master essential Vault CLI commands
- Learn to manage secrets using the CLI
- Configure authentication and policies
- Work with different secrets engines
- Understand secret versioning and data protection

**Time to Complete**: 30-45 minutes

**Preview Mode**: Use `Cmd/Ctrl + Shift + V` in VSCode to see a nicely formatted version of this lab!

## How to Use This Hands-On Lab

1. **Create a Codespace** from this repo (click the button below).  
2. Once the Codespace is running, open the integrated terminal.
3. Follow the instructions in each **lab** to complete the exercises.

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/btkrausen/vault-codespaces)

### Initial Setup
Let's verify your environment and set initial variables:

```bash
# Verify Vault is running
vault status

# Set Vault address and token (if not already set)
export VAULT_ADDR='http://127.0.0.1:8200'
export VAULT_TOKEN='root' 
```

### Part 1: Basic CLI Operations

1. **Help and Documentation**
```bash
# Get general help
vault help

# Get help for a specific command
vault kv help
```

2. **Server Information**
```bash
# Check server status
vault status

# View server configuration
vault read sys/config/state/sanitized
```

### Part 2: Working with Secrets

1. **Enable KV Secrets Engine**
```bash
# Enable KV version 2 at path 'secrets'
vault secrets enable -path=prd-secrets -version=2 kv

# Verify enabled secrets engines
vault secrets list
```

2. **Managing Secrets**
```bash
# Create a secret
vault kv put prd-secrets/myapp/config \
    database_url="postgresql://localhost:5432/mydb" \
    api_key="super-secret-123"

# Read a secret
vault kv get prd-secrets/myapp/config

# Read specific version
vault kv get -version=1 prd-secrets/myapp/config

# Read specific field
vault kv get -field=api_key prd-secrets/myapp/config

# Format output as JSON
vault kv get -format=json prd-secrets/myapp/config

# Update a secret
vault kv patch prd-secrets/myapp/config \
    api_key="new-secret-456"

# Delete latest version of a secret
vault kv delete prd-secrets/myapp/config

# Permanently delete all versions
vault kv metadata delete prd-secrets/myapp/config
```

### Part 3: Policy Management

1. **Create a Policy**
```bash
# Create policy file
cat > app-policy.hcl << EOF
path "prd-secrets/data/myapp/*" {
  capabilities = ["read", "list"]
}
path "prd-secrets/metadata/myapp/*" {
  capabilities = ["list", "read"]
}
EOF

# Write policy to Vault
vault policy write app-reader app-policy.hcl

# View policy
vault policy read app-reader

# List all policies
vault policy list
```

### Part 4: Auth Methods

1. **Enable UserPass Auth**
```bash
# Enable userpass auth method
vault auth enable userpass

# Create a user
vault write auth/userpass/users/myapp \
    password="password123" \
    policies="app-reader"

# List users
vault list auth/userpass/users
```

2. **Login with UserPass**
```bash
# Login and save token
VAULT_TOKEN=$(vault login -method=userpass \
    username=myapp \
    password=password123 \
    -format=json | jq -r '.auth.client_token')

# Verify token and permissions
vault token lookup
```

### Part 5: Advanced Operations

1. **Secret Versioning**
```bash
# Update secret multiple times
vault kv put prd-secrets/myapp/config message="version 1"
vault kv put prd-secrets/myapp/config message="version 2"
vault kv put prd-secrets/myapp/config message="version 3"

# View secret versions
vault kv list -versions prd-secrets/myapp/config

# Soft delete latest version
vault kv delete prd-secrets/myapp/config

# Undelete version
vault kv undelete -versions=3 prd-secrets/myapp/config
```

2. **Metadata Operations**
```bash
# Add custom metadata
vault kv metadata put prd-secrets/myapp/config \
    custom_metadata=environment="development" \
    max_versions=5

# Read metadata
vault kv metadata get prd-secrets/myapp/config
```

## 🔍 Practice Exercises

Try these exercises to reinforce your learning:

1. **Basic Operations**
   - Create a new secret with multiple key-value pairs
   - Read specific fields from the secret
   - Update only one field using patch
   - Delete and undelete the secret

2. **Policy Practice**
   - Create a policy that allows create and update but not delete
   - Create a new user with this policy
   - Test the permissions work as expected

3. **Advanced Tasks**
   - Enable a new secrets engine at a custom path
   - Configure custom metadata for a secret
   - Work with secret versioning

## 🎯 Success Criteria
You've completed the lab when you can:
- [x] Manage secrets using the CLI
- [x] Create and apply policies
- [x] Work with authentication methods
- [x] Handle secret versioning
- [x] Perform metadata operations

## 📚 Common CLI Options
- `-format=json`: Output in JSON format
- `-field=key`: Extract specific field
- `-mount=path`: Specify mount path
- `-namespace=ns`: Work in specific namespace (Enterprise)

## ❓ Troubleshooting

**Common Issues:**
1. **Permission Denied**: Check your token's policies
2. **Connection Failed**: Verify VAULT_ADDR is set correctly
3. **Token Expired**: Login again to get a new token

## 🔍 Additional CLI Tips

1. **Environment Variables**
```bash
# Common Vault environment variables
export VAULT_ADDR='http://127.0.0.1:8200'
export VAULT_TOKEN='your-token'
export VAULT_NAMESPACE='admin' # Enterprise only
export VAULT_FORMAT='json'     # Always output in JSON
```

2. **Using jq with Vault**
```bash
# Extract specific fields from JSON output
vault kv get -format=json prd-secrets/myapp/config | jq -r '.data.data.api_key'

# Process multiple secrets
vault kv list -format=json prd-secrets/myapp/ | jq -r '.data.keys[]'
```

## 📚 Additional Resources
- [Vault CLI Documentation](https://www.vaultproject.io/docs/commands)
- [Vault Policy Documentation](https://www.vaultproject.io/docs/concepts/policies)
- [Vault Auth Methods](https://www.vaultproject.io/docs/auth)