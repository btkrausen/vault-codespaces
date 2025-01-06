# Vault Token Management Lab

## Overview
Learn different token types and their management in Vault.

**Time to Complete**: 25 minutes

**Preview Mode**: Use `Cmd/Ctrl + Shift + V` in VSCode to see a nicely formatted version of this lab!

## How to Use This Hands-On Lab

1. **Create a Codespace** from this repo (click the button below).  
2. Once the Codespace is running, open the integrated terminal.
3. Follow the instructions in each **lab** to complete the exercises.

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/btkrausen/vault-codespaces)

## Steps

## Part 1: Service Tokens

1. Create basic service token:
```bash
# Log in with a valid token
vault login root

# Create a token
vault token create
```

2. Create token with policy:
```bash
vault token create \
    -policy="default" \
    -ttl="1h" \
    -explicit-max-ttl="2h"
```

## Part 2: Batch Tokens

1. Create batch token:
```bash
vault token create -type=batch \
    -ttl="1h" \
    -policy="default"
```

2. Compare properties:
```bash
# Lookup service token
vault token lookup <service_token>

# Lookup batch token (notice fewer properties)
vault token lookup <batch_token>
```

## Part 3: Periodic Tokens

1. Create periodic token:
```bash
vault token create -period="24h" \
    -policy="default"
```

2. Renew periodic token:
```bash
vault token renew <periodic_token>
```

## Part 4: Orphan Tokens

1. Create orphan token:
```bash
vault token create -orphan \
    -policy="default" \
    -ttl="1h"
```

2. View token hierarchy:
```bash
# Create child of service token
VAULT_TOKEN=<service_token> vault token create

# Create orphan - no parent relationship
vault token create -orphan
```

## Part 5: Token Roles

1. Create token role:
```bash
vault write auth/token/roles/app-role \
    allowed_policies="default" \
    orphan=true \
    token_period="1h" \
    renewable=true
```

2. Create token from role:
```bash
vault token create -role=app-role
```

## Challenge Exercises

1. Token Lifecycle:
   - Create periodic token
   - Renew it multiple times
   - Verify period remains constant

2. Token Hierarchy:
   - Create parent token
   - Create child tokens
   - Revoke parent
   - Check child status

## Key Differences
- Service Tokens: Default, renewable
- Batch Tokens: Lightweight, non-renewable
- Periodic Tokens: Auto-renewable indefinitely
- Orphan Tokens: No parent relationship

## Cleanup
```bash
export VAULT_TOKEN="root"

# Revoke tokens
vault token revoke <token>

# Remove token role
vault delete auth/token/roles/app-role
```