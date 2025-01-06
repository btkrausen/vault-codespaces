# Response Wrapping Demo: Secret Retrieval

## Overview
Learn how to create and use response wrapping tokens to securely share Vault secrets.

**Time to Complete**: 10 minutes

**Preview Mode**: Use `Cmd/Ctrl + Shift + V` in VSCode to see a nicely formatted version of this lab!

## How to Use This Hands-On Lab

1. **Create a Codespace** from this repo (click the button below).  
2. Once the Codespace is running, open the integrated terminal.
3. Follow the instructions in each **lab** to complete the exercises.

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/btkrausen/vault-codespaces)

## Steps

1. Create a secret:
```bash
# Log in with a valid token
vault login root

# Create the secret
vault kv put secret/demo username=admin password=secret123
```

2. Read secret normally:
```bash
vault kv get secret/demo
```

3. Create a wrapped token for reading the same secret:
```bash
vault kv get -wrap-ttl=1h -format=json secret/demo
# Save the wrapping_token from output
```

4. Use wrapped token to retrieve the secret:
```bash
vault unwrap <wrapping_token>
```

5. Try unwrapping again (will fail since wrapping tokens can only be used once):
```bash
vault unwrap <wrapping_token>
```

## Testing Different Scenarios

1. Short TTL wrap:
```bash
vault kv get -wrap-ttl=30s secret/demo
sleep 31
vault unwrap <wrapping_token>  # Should fail as token is now expired
```

2. Wrap specific field:
```bash
vault kv get -wrap-ttl=1h -field=password secret/demo
vault unwrap <wrapping_token>  # Returns only password
```

## Challenge Exercise

1. Create multi-step wrapping:
   - Create a secret
   - Wrap it with 1h TTL
   - Create policy allowing unwrap
   - Create token with policy
   - Pass wrapped token to new token

## Cleanup
```bash
vault kv delete secret/credentials
vault kv delete secret/short-lived
```