[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/btkrausen/vault-codespaces)

# Lab: Initializing and Unsealing Vault in a GitHub Codespace

In this lab, you will learn how to:

1. **Check if Vault is running** (but sealed).  
2. **Initialize Vault** for the first time.  
3. **Unseal Vault** using the generated unseal keys.  
4. **Log in** using the root token.  

This lab assumes you are using a GitHub Codespace configured with a `vault.hcl` file (file-based storage, no TLS), a background service startup for Vault (not in dev mode), and that **Vault is sealed** by default.

---

## Prerequisites

- You have [created a Codespace](https://github.com/features/codespaces) from the repository containing this lab.
- You have opened a terminal in that Codespace.

---

## Lab Steps

### 1. Verify Vault is Running (But Sealed)

In your Codespace terminal, check Vault’s status:
```bash
vault status
```
You should see output indicating Vault is not initialized:
```bash
Key             Value
---             -----
Seal Type       shamir
Initialized     false
Sealed          true
Total Shares    5
Threshold       3
```
Because Vault is not yet initialized, it remains sealed by default.

### 2. Initialize Vault
Run the following command to initialize Vault with default settings:
```bash
vault operator init
```

This will output Unseal Keys (by default, 5 keys) and an Initial Root Token. Example (truncated):
```bash
Unseal Key 1: vXZxiC...
Unseal Key 2: 5XqwCh...
Unseal Key 3: yz7pgT...
Unseal Key 4: H0Vz0S...
Unseal Key 5: TctMND...

Initial Root Token: hvs.MIgc...
Important: Securely copy or store these unseal keys and the initial root token. You need them to unseal and authenticate to Vault.
```

### 3. Unseal the Vault
By default, Vault requires 3 of the 5 unseal keys to unseal. Perform the unseal steps (3 times, with 3 different keys) in your terminal:
```bash
# First unseal
vault operator unseal

<Enter Unseal Key 1 Here>

# Second unseal
vault operator unseal

<Enter Unseal Key 2 Here>

# Third unseal
vault operator unseal

<Enter Unseal Key 3 Here>
```
After the third key, you should see:
```bash
Sealed: false
Initialized: true
```

### 4. Log in with the Root Token
Copy your Initial Root Token from the `vault operator init` output.
Export it as your Vault token so the CLI uses it automatically:
```bash
export VAULT_TOKEN="<YOUR_ROOT_TOKEN>"
```
Verify the status again:
```bash
vault status
```
You should now see something like:
```bash
Key             Value
---             -----
Seal Type       shamir
Initialized     true
Sealed          false
...
Vault is now initialized and unsealed!
```

### (Optional) Store and Retrieve a Secret
Try creating your first secret in Vault:
```bash
vault secrets enable kv
vault kv put secret/hello name=<enter_your_name_here>
```
Then retrieve it:
```bash
vault kv get secret/hello
```
You’ll see:
```bash
====== Data ======
Key     Value
---     -----
foo     bar
```

### Cleanup / Next Steps
Vault remains unsealed as long as the container is active. If you restart your Codespace, you’ll need to unseal again (using your unseal keys), since the data is stored on the container’s file system.

If you destroy the Codespace environment entirely, you lose the file storage data unless you’ve persisted it externally.

### You Did It!
You have successfully:

- Verified that Vault was running (but sealed).
- Initialized Vault to generate unseal keys and a root token.
- Unsealed Vault with 3 keys.
- Logged in and optionally stored a test secret.

Feel free to explore more Vault features in this environment. Enjoy your hands-on practice!