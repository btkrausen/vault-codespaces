# HashiCorp Vault KV Secrets Engine Lab

## Lab Overview
Learn the differences between KV v1 and KV v2 secrets engines through hands-on practice.

**Time to Complete**: 25-30 minutes

**Preview Mode**: Use `Cmd/Ctrl + Shift + V` in VSCode to see a nicely formatted version of this lab!

## How to Use This Hands-On Lab

1. **Create a Codespace** from this repo (click the button below).  
2. Once the Codespace is running, open the integrated terminal.
3. Follow the instructions in each **lab** to complete the exercises.

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/btkrausen/vault-codespaces)

## Steps

1. Enable KV v1 and v2 engines:
```bash
# Log in with a valid token
vault login root

# Enable the secrets engines
vault secrets enable -path=kv1 -version=1 kv
vault secrets enable -path=kv2 -version=2 kv
```

2. Verify newly mounted secrets engines:
```bash
vault secrets list
```

## Part 1: Basic Operations

### KV Version 1
```bash
# Write a secret
vault kv put kv1/app1 username=admin password=secret123

# Read a secret
vault kv get kv1/app1

# Update a secret
vault kv put kv1/app1 username=admin password=newpass123

# Read the updated secret
vault kv get kv1/app1

# Delete a secret
vault kv delete kv1/app1

# Read a secret (this should return "no value found")
vault kv get kv1/app1
```

### KV Version 2
```bash
# Write a secret
vault kv put kv2/app1 username=admin password=secret123

# Read a secret
vault kv get kv2/app1

# Update a secret
vault kv put kv2/app1 username=admin password=newpass123

# Read the updated secret (notice it's now version 2)
vault kv get kv2/app1

# Delete latest version
vault kv delete kv2/app1

# Read the updated secret (notice only metadata is returned - but no data)
vault kv get kv2/app1
```

## Part 2: KV v2 Versioning Features

1. Create multiple versions:
```bash
vault kv put kv2/config api_key=v1
vault kv put kv2/config api_key=v2
vault kv put kv2/config api_key=v3
```

2. Read specific versions:
```bash
vault kv get -version=1 kv2/config
vault kv get -version=2 kv2/config
vault kv get -version=3 kv2/config
```

3. View version metadata:
```bash
vault kv metadata get kv2/config
```

4. Roll back to previous version:
```bash
vault kv rollback -version=1 kv2/config
```

5. Read the latest version (notice it's now the same as v1)
```bash
vault kv get kv2/config
```

## Part 3: KV v2 Soft Delete

1. Delete and recover:
```bash
# Delete latest version
vault kv delete kv2/app1

# Read the latest version(notice only metadata is returned)
vault kv get kv2/app1

# Undelete the version
vault kv undelete -versions=1 kv2/app1

# Read the latest version(notice the data is back)
vault kv get kv2/app1

# Permanently delete version
vault kv destroy -versions=1 kv2/app1
```

## Part 4: KV v2 Metadata Operations

1. Set custom metadata:
```bash
vault kv metadata put -custom-metadata=owner="ops" -custom-metadata=env="prod" kv2/app1
```

2. Read the secret and notice the custom metadata returned
```bash
vault kv get kv2/app1
```

3. Configure the maximum number of versions for the specific path:
```bash
vault kv metadata put -max-versions=5 kv2/app1
```

4. Delete all versions and metadata:
```bash
vault kv metadata delete kv2/app1
```

## Challenge Exercises

1. Version Management:
   - Create 3 versions of a secret
   - Delete version 2
   - Recover version 2
   - Verify all versions

2. Metadata Management:
   - Create a secret with custom metadata
   - Update metadata without changing secret
   - List all metadata
   - Delete specific metadata fields

## Key Differences Summary
- KV v1: No versioning, simple storage
- KV v2: 
  - Version history
  - Soft delete
  - Metadata management
  - Rollback capability
  - Scheduled deletion

## Cleanup
```bash
vault secrets disable kv1
vault secrets disable kv2
```