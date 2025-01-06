
# AppRole Authentication Lab

## Overview
Learn to configure and use Vault's AppRole auth method for application authentication.

**Time to Complete**: 20 minutes

**Preview Mode**: Use `Cmd/Ctrl + Shift + V` in VSCode to see a nicely formatted version of this lab!

## How to Use This Hands-On Lab

1. **Create a Codespace** from this repo (click the button below).  
2. Once the Codespace is running, open the integrated terminal.
3. Follow the instructions in each **lab** to complete the exercises.

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/btkrausen/vault-codespaces)

## Steps

1. Enable AppRole auth if not yet enabled:
```bash
# Log in with a valid token
vault login root

# Validate that AppRole is already enabled at the approle/ path
vault auth list
```

2. Create policy for the app:
```bash
vault policy write app-policy - <<EOF
path "secret/data/app/*" {
  capabilities = ["read", "list"]
}
EOF
```

3. Create AppRole:
```bash
vault write auth/approle/role/my-app \
    token_policies="app-policy" \
    token_ttl=1h \
    token_max_ttl=4h \
    bind_secret_id=true
```

4. Get RoleID:
```bash
vault read auth/approle/role/my-app/role-id
```

5. Generate SecretID:
```bash
vault write -f auth/approle/role/my-app/secret-id
```

6. Write a secret to use for testing:
```bash
vault kv put secret/app/config db_conn=prod-db.krausen.io:3306
```

7. Login using AppRole:
```bash
vault write auth/approle/login \
    role_id="<role_id>" \
    secret_id="<secret_id>"
```

8. Test access with token:
```bash
# Store token
export VAULT_TOKEN="<token from login>"

# Test permissions
vault kv put secret/app/config api_key="test123"  # Should fail (read-only)
vault kv get secret/app/config  # Should work
```

## Advanced Configuration

1. Create AppRole with constraints:
```bash
vault write auth/approle/role/restricted-app \
    token_policies="app-policy" \
    secret_id_ttl=30m \
    token_num_uses=10 \
    secret_id_num_uses=1 \
    token_ttl=20m
```

2. Generate and use one-time SecretID:
```bash
vault write -f auth/approle/role/restricted-app/secret-id
vault write auth/approle/login \
    role_id="<restricted_role_id>" \
    secret_id="<one_time_secret_id>"
```

## Challenge Exercise
1. Create new AppRole with:
   - 1-hour token TTL
   - Maximum 3 secret ID uses
   - Token bound to CIDR blocks
2. Test authentication
3. Verify token restrictions

## Cleanup
```bash
export VAULT_TOKEN="root"
vault auth disable approle
vault policy delete app-policy
```