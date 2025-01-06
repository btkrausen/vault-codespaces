# Transit Secrets Engine Lab

## Overview
Learn to use Vault's Transit secrets engine for encryption operations.

**Time to Complete**: 20-25 minutes

**Preview Mode**: Use `Cmd/Ctrl + Shift + V` in VSCode to see a nicely formatted version of this lab!

## How to Use This Hands-On Lab

1. **Create a Codespace** from this repo (click the button below).  
2. Once the Codespace is running, open the integrated terminal.
3. Follow the instructions in each **lab** to complete the exercises.

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/btkrausen/vault-codespaces)

## Steps

1. Enable the Transit engine:
```bash
# Log in with a valid token
vault login root

# Enable the Transit secrets engine
vault secrets enable transit
```

2. Create an encryption key:
```bash
vault write -f transit/keys/my-app
```

## Part 1: Basic Encryption/Decryption

1. Encrypt data:
```bash
# Encode data in base64
echo -n "sensitive data" | base64

# Encrypt the data
vault write transit/encrypt/my-app plaintext=$(echo -n "sensitive data" | base64)
```

2. Decrypt data:
```bash
# Store the ciphertext from previous step
CIPHER="vault:v1:abc123..." # Use your actual ciphertext

# Decrypt
vault write transit/decrypt/my-app ciphertext=$CIPHER
```

3. Decode the result:
```bash
echo "base64-output" | base64 -d  # Replace with actual output
```

## Part 2: Key Rotation

1. Rotate the encryption key:
```bash
vault write -f transit/keys/my-app/rotate
```

2. Check key details:
```bash
vault read transit/keys/my-app
```

3. Encrypt new data (uses latest key version):
```bash
vault write transit/encrypt/my-app plaintext=$(echo -n "new data" | base64)
```

## Part 3: Key Management

1. Update key configuration:
```bash
# Set minimum decryption version
vault write transit/keys/my-app/config min_decryption_version=1

# Set minimum encryption version
vault write transit/keys/my-app/config min_encryption_version=1

# Enable key deletion
vault write transit/keys/my-app/config deletion_allowed=true
```

2. Create key with specific parameters:
```bash
vault write transit/keys/my-app-2 \
    type="aes256-gcm96" \
    exportable=false \
    deletion_allowed=true
```

## Part 4: Data Key Generation

1. Generate data key:
```bash
vault write -f transit/datakey/plaintext/my-app
```

2. Generate wrapped data key:
```bash
vault write -f transit/datakey/wrapped/my-app
```

## Challenge Exercise

Create an encryption workflow:
1. Create new encryption key
2. Encrypt 3 pieces of data
3. Rotate the key
4. Encrypt new data
5. Verify old data still decrypts
6. List all key versions

## Cleanup
```bash
vault delete transit/keys/my-app
vault delete transit/keys/my-app-2
vault secrets disable transit
```

## Key Features
- Key rotation
- Configurable key types
- Versioning support
- Data key generation
- Secure key storage