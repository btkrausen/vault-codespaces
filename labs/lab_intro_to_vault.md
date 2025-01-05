# Introduction to Vault CLI Commands Lab

## Overview
In this lab, you'll learn the fundamental Vault CLI commands to check the status of your Vault server, view enabled features, and understand basic Vault operations.

**Time to Complete**: 15-20 minutes

**Preview Mode**: Use `Cmd/Ctrl + Shift + V` in VSCode to see a nicely formatted version of this lab!

## How to Use This Hands-On Lab

1. **Create a Codespace** from this repo (click the button below).  
2. Once the Codespace is running, open the integrated terminal.
3. Follow the instructions in each **lab** to complete the exercises.

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/btkrausen/vault-codespaces)

## Steps

### Part 1: Basic Server Status

1. Check the status of your Vault server:
```bash
vault status
```
This shows:
- Seal Status
- Initialize Status
- Server Version
- Storage Type
- HA Status

2. Authenticate to Vault using the root token:
```bash
vault login root
```

### Part 2: Secret Engines

1. List enabled secret engines:
```bash
vault secrets list
```
Notice there are several secrets engines already enabled, including a KV store at `secrets/`

2. Get information about a specific secrets engine:
```bash
vault secrets list -detailed
```

### Part 3: Authentication Methods

1. List enabled auth methods:
```bash
vault auth list
```
Notice that several auth methods are available, including `AppRole`

2. Get detailed auth method information:
```bash
vault auth list -detailed
```

### Part 4: Basic Key-Value Operations

1. Write a secret:
```bash
vault kv put secret/first hello=world
vault kv put secret/my-secret username=admin password=secret123
```

2. Read a secret:
```bash
vault kv get secret/first
vault kv get -field=hello secret/first
```

3. List secrets in a path:
```bash
vault kv list secret/
```

4. Delete a secret:
```bash
vault kv delete secret/first
```

### Part 5: Token Information

1. View current token information:
```bash
vault token lookup
```

2. View token capabilities:
```bash
vault token capabilities secret/first
```

3. Create a new token:
```bash
vault token create -ttl=1h
```

## Challenge Exercise

1. Use JSON format for secret data:
```bash
vault kv put secret/user - <<EOF
{
  "data": {
    "username": "admin",
    "password": "secret",
    "email": "admin@example.com"
  }
}
EOF
```

## Key Commands Summary
- `vault status` - Check server status
- `vault secrets list` - List secret engines
- `vault auth list` - List auth methods
- `vault kv put` - Write secrets
- `vault kv get` - Read secrets
- `vault kv list` - List secrets
- `vault token lookup` - View token info

## Learning Resources
- [Vault CLI Commands](https://developer.hashicorp.com/vault/docs/commands)
- [KV Secrets Engine](https://developer.hashicorp.com/vault/docs/secrets/kv)
- [Getting Started Guide](https://developer.hashicorp.com/vault/tutorials/getting-started)