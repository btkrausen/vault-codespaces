# Vault Authentication Methods Labs

## Lab 1: UserPass Authentication

### Overview
Configure and test username/password authentication.

**Time to Complete**: 15-20 minutes

**Preview Mode**: Use `Cmd/Ctrl + Shift + V` in VSCode to see a nicely formatted version of this lab!

## How to Use This Hands-On Lab

1. **Create a Codespace** from this repo (click the button below).  
2. Once the Codespace is running, open the integrated terminal.
3. Follow the instructions in each **lab** to complete the exercises.

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/btkrausen/vault-codespaces)

## Steps

1. Enable the auth method:
```bash
# Log in with a valid token
vault login root

# Enable the auth method
vault auth enable userpass
```

2. Create users:
```bash
# Create admin user
vault write auth/userpass/users/admin \
    password="admin123" \
    policies="admin-policy"

# Create regular user
vault write auth/userpass/users/user1 \
    password="user123" \
    policies="basic-policy"
```

3. Create basic policies:
```bash
# Create admin policy
vault policy write admin-policy - <<EOF
path "secret/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}
EOF

# Create basic policy
vault policy write basic-policy - <<EOF
path "secret/data/user1/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}
EOF
```

4. Test authentication:
```bash
# Login as admin
vault login -method=userpass \
    username=admin \
    password=admin123

# Test permissions
vault kv put secret/test value=123

# Login as user1
vault login -method=userpass \
    username=user1 \
    password=user123

# Test restricted permissions
vault kv put secret/user1/test value=123
vault kv put secret/admin/test value=123  # Should fail
```

### Cleanup
```bash
vault auth disable userpass
```

## Learning Resources
- [UserPass Auth Method](https://developer.hashicorp.com/vault/docs/auth/userpass)