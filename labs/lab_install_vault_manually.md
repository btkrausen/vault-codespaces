# HashiCorp Vault Installation Lab (Container Version)

This lab walks you through MANUALLY installing Vault by creating all the requirements and downloading and installing the Vault binary. In a typical environment, you should be able to use a package manager, which automates most of this work.

## 🎯 Learning Objectives

- Install Vault using binary download method
- Create proper system user and directories
- Configure and run Vault server in a container
- Initialize and unseal a Vault instance
- Perform basic Vault operations

**Time Required:** ~35 minutes

**Preview Mode**: Use `Cmd/Ctrl + Shift + V` in VSCode to see a nicely formatted version of this lab!

## How to Use This Hands-On Lab

1. **Create a Codespace** from this repo (click the button below).
2. Once the Codespace is running, open the integrated terminal.
3. Follow the instructions in each **lab** to complete the exercises.

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://github.com/codespaces/new/btkrausen/vault-codespaces?skip_quickstart=true&machine=basicLinux32gb&repo=907851765&ref=main&devcontainer_path=.devcontainer%2Finstall%2Fdevcontainer.json&geo=UsEast)

## Steps

### Part 1: System Preparation

1. Create Vault user and group:

```bash
# Create vault group
sudo groupadd vault

# Create vault user
sudo useradd -r -m -g vault -d /home/vault -s /bin/bash -c "Vault user" vault
```

2. Create necessary directories:

```bash
# Create directories
sudo mkdir -p /opt/vault/data
sudo mkdir -p /etc/vault.d
sudo mkdir -p /var/lib/vault
sudo mkdir -p /usr/local/bin

# Set ownership
sudo chown -R vault:vault /opt/vault
sudo chown -R vault:vault /etc/vault.d
sudo chown -R vault:vault /var/lib/vault
```

### Part 2: Installing Vault

1. Download and install Vault:

```bash
# Download latest version of Vault
wget https://releases.hashicorp.com/vault/1.18.3/vault_1.18.3_linux_amd64.zip

# Unzip the package
sudo unzip vault_1.18.3_linux_amd64.zip -d /usr/local/bin/

# Set ownership
sudo chown vault:vault /usr/local/bin/vault

# Clean up
rm vault_1.18.3_linux_amd64.zip
```

2. Verify the installation:

```bash
vault --version
```

### Part 3: Configuring Vault

1. Create the configuration file:

```bash
sudo tee /etc/vault.d/vault.hcl <<EOF
storage "file" {
  path = "/opt/vault/data"
}

listener "tcp" {
  address     = "0.0.0.0:8200"
  tls_disable = 1  # Only for dev/test
}

api_addr = "http://127.0.0.1:8200"
cluster_addr = "http://127.0.0.1:8201"

ui = true
disable_mlock = true  # Only for dev/test
EOF
```

2. Set proper permissions:

```bash
sudo chmod 640 /etc/vault.d/vault.hcl
sudo chown -R vault:vault /etc/vault.d/vault.hcl
```

### Part 4: Starting Vault

1. Start Vault server in the background:

```bash
# Switch to vault user
sudo -u vault /usr/local/bin/vault server -config=/etc/vault.d/vault.hcl &

# Press <Enter> to get the command prompt back
```

2. Set environment variable:

```bash
export VAULT_ADDR='http://127.0.0.1:8200'
```

3. Verify Vault is running:

```bash
# Check if Vault is responding
curl http://127.0.0.1:8200/v1/sys/health | jq
```

4. Verify Vault is running and responding to commands:

```bash
vault status
```

## 🚀 Congrats, you've successfully installed HashiCorp Vault manually

## ❗ Important Notes

1. **Security Considerations**
   - This setup uses `tls_disable = 1` - not for production
   - Uses `disable_mlock = true` - not for production
   - Store unseal keys securely in production
   - Enable audit logging in production

## 🎯 Success Criteria

You've completed the lab when you can:

- [x] Successfully install Vault
- [x] Configure system user and directories
- [x] Start Vault server process

## ❓ Troubleshooting

1. **Server Won't Start**

   - Check if process is running: `ps aux | grep vault`
   - Check ownership of directories
   - Verify configuration file syntax

2. **Cannot Connect**

   - Verify VAULT_ADDR is set
   - Check if process is running
   - Ensure Vault is unsealed
   - Test with curl: `curl http://127.0.0.1:8200/v1/sys/health`

3. **Permission Issues**
   - Check ownership: `ls -l /usr/local/bin/vault`
   - Verify directory permissions: `ls -l /opt/vault/data`

## 📚 Additional Resources

- [Vault Documentation](https://www.vaultproject.io/docs)
- [Production Hardening](https://www.vaultproject.io/docs/concepts/production-hardening)
- [Binary Downloads](https://www.vaultproject.io/downloads)

---

_Happy Vault Installing! 🔐_
