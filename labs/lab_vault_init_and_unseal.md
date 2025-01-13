# Hands-on Lab: Vault Initialization and Unsealing

## Overview
In this lab, you will learn how to initialize and unseal a Vault server using Shamir's Secret Sharing. You'll create 5 unseal keys with a threshold of 3, meaning any 3 keys are required to unseal Vault.

**Time Required:** ~20 minutes

**Preview Mode**: Use `Cmd/Ctrl + Shift + V` in VSCode to see a nicely formatted version of this lab!

## How to Use This Hands-On Lab

1. **Create a Codespace** from this repo (click the button below).  
2. Once the Codespace is running, open the integrated terminal.
3. Follow the instructions in each **lab** to complete the exercises.

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://github.com/codespaces/new?hide_repo_select=true&ref=main&repo=907851765&skip_quickstart=true&machine=basicLinux32gb&devcontainer_path=.devcontainer%2Frun%2Fdevcontainer.json&geo=UsEast)

## Steps

### Step 1: Check Vault Status

1. Verify Vault's current status:
```bash
vault status
```

You should see that Vault is not initialized:
```
Key                Value
---                -----
Seal Type          shamir
Initialized        false <--- not yet initialized
Sealed             true
...
```

### Step 2: Initialize Vault

1. Initialize Vault with 5 key shares and a threshold of 3 (_this is the default but practice using the flags_):
```bash
vault operator init \
    -key-shares=5 \
    -key-threshold=3
```

2. The output will show:
- 5 unseal keys
- Initial root token

IMPORTANT: In a production environment, these keys should be distributed to different individuals. Save these keys securely - you'll need them to unseal Vault.

Example output:
```
Unseal Key 1: a4GtR2/Ko...
Unseal Key 2: Jsd9Ksli...
Unseal Key 3: PSYt0dLx...
Unseal Key 4: xhn1Cht9...
Unseal Key 5: 123abcDE...

Initial Root Token: hvs.UZx...
```

### Step 3: Unseal Vault

1. Unseal Vault using three of the five keys. You'll need to run the unseal command three times, using a different key each time:

Run the unseal command:
```bash
vault operator unseal
```
When prompted, enter one of the unseal keys (_it doesn't matter which one_).

Run the unseal command again:
```bash
vault operator unseal
```
When prompted, enter another unseal key (_can be any other key, just don't reuse any keys during this process_).

Run the unseal command one last time (_because we required a threshold of three_):
```bash
vault operator unseal
```
When prompted, enter the third unseal key.

2. Check the status again:
```bash
vault status
```

You should now see:
```
Key             Value
---             -----
Seal Type       shamir
Initialized     true  <--- initialized
Sealed          false  <--- and now unsealed
...
```

### Step 4: Login with Root Token

1. Copy the Initial Root Token from the `vault operator init` command and login:
```bash
vault login # press enter
```
When prompted, enter the root token that was generated during initialization.

2. Run a command to ensure you can interact with Vault:
```bash
vault secrets list
```

## Challenge Exercise

1. Seal the vault again:
```bash
vault operator seal
```

2. Unseal it using a different combination of three keys than you used before.

## Best Practices

1. **Key Distribution**:
   - Never store all unseal keys in the same place
   - Distribute keys to different trusted individuals
   - Consider using PGP encryption for key distribution

2. **Root Token**:
   - Store the initial root token securely
   - Create alternate administrative tokens
   - Consider revoking the initial root token after setup

3. **Unsealing Process**:
   - Implement proper procedures for unsealing
   - Document the process for authorized individuals
   - Consider auto-unseal for production environments

## Additional Resources

- [Vault Initialization Documentation](https://www.vaultproject.io/docs/commands/operator/init)
- [Vault Seal/Unseal Documentation](https://www.vaultproject.io/docs/concepts/seal)
- [Auto-unseal Documentation](https://www.vaultproject.io/docs/configuration/seal)