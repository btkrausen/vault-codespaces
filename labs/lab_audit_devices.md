# Lab: Vault Audit Devices - File Audit Device

## Lab Objectives
- Enable and configure a file audit device
- Generate audit logs through various Vault operations
- Analyze and understand audit log entries
- Practice common audit device management tasks
- Learn about log rotation and file permissions

**Time to Complete**: 15-20 minutes

**Preview Mode**: Use `Cmd/Ctrl + Shift + V` in VSCode to see a nicely formatted version of this lab!

## How to Use This Hands-On Lab

1. **Create a Codespace** from this repo (click the button below).  
2. Once the Codespace is running, open the integrated terminal.
3. Follow the instructions in each **lab** to complete the exercises.

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/btkrausen/vault-codespaces)

## Steps

### 1. Verify Vault Status
First, ensure Vault is running and you're authenticated:
```bash
# Check Vault status
vault status

# Log in with a valid token
vault login root
```

### 2. Enable File Audit Device
Enable the file audit device and configure it to write to a specific file:
```bash
# Create directory for audit logs with appropriate permissions
mkdir -p /var/log/vault
chown vault:vault /var/log/vault

# Enable file audit device
vault audit enable file file_path=/var/log/vault/audit.log

# Verify audit device is enabled
vault audit list

# View more details about the audit device, including the targeted path/file
vault audit list --detailed
```

### 3. Generate Audit Events
Perform various operations to generate audit logs:

a. Create a secret:
```bash
# Enable KV secrets engine if not already enabled
vault secrets enable -path=secret kv-v2

# Repeat the step above to purposely create an error
vault secrets enable -path=secret kv-v2

# Create a test secret
vault kv put secret/test-secret username=admin password=vault-demo
```

b. Read the secret:
```bash
vault kv get secret/test-secret
```

c. Update the secret:
```bash
vault kv put secret/test-secret username=admin password=updated-password
```

d. List secrets:
```bash
vault kv list secret/
```

e. Delete the secret:
```bash
vault kv delete secret/test-secret
```

### 4. Examine Audit Logs
Review and analyze the generated audit logs:
```bash
# View raw audit logs
cat /var/log/vault/audit.log

# Parse JSON logs with jq (if installed)
cat /var/log/vault/audit.log | jq '.'

# Search for specific operations performed above
grep "secret/test-secret" /var/log/vault/audit.log | jq '.'
```

### 5. Understanding Audit Log Structure
Each audit log entry contains:
- timestamp
- type (request/response)
- auth information
- request/response data
- error information (if applicable)

Example analysis tasks:
```bash
# Find all KV secret operations
grep "secret/" /var/log/vault/audit.log | jq '.'

# Look for specific authentication events
grep "login" /var/log/vault/audit.log | jq '.'

# Find error events
grep "error" /var/log/vault/audit.log | jq '.'
```

### 6. Log Rotation Practice
Set up basic log rotation:
```bash
# Create logrotate configuration
tee /etc/logrotate.d/vault <<EOF
/var/log/vault/audit.log {
    daily
    rotate 7
    compress
    delaycompress
    missingok
    notifempty
    create 0640 vault vault
}
EOF

# View the contents of the vault audit directory (and see there's only one file)
ls /var/log/vault

# Force a log rotatation
logrotate -f /etc/logrotate.d/vault

# View the contents of the vault audit directory (and see the rotated file)
# Notice that audit.log is now empty
ls /var/log/vault
```

### 7. Audit Device Management
Practice common management tasks:
```bash
# Disable audit device
vault audit disable file/

# Re-enable with different options
vault audit enable -path=file2 file file_path=/var/log/vault/audit2.log

# List all enabled audit devices
vault audit list -detailed
```

## Challenge Exercises

1. **Log Analysis Challenge**
   - Enable multiple auth methods (userpass, approle)
   - Generate login attempts with both successful and failed authentications
   - Use grep and jq to find all failed login attempts

2. **Multiple Audit Devices**
   - Enable two file audit devices with different paths
   - Compare the logs between them
   - Understand the implications of multiple audit devices

3. **Log Rotation Testing**
   - Generate a large number of audit events
   - Trigger manual log rotation
   - Verify rotated logs are properly compressed

## Troubleshooting Guide

Common issues and solutions:

1. **Permission Issues**
```bash
# Fix permissions on audit log directory
chown -R vault:vault /var/log/vault
chmod 0740 /var/log/vault
```

2. **Disk Space Management**
```bash
# Check disk space usage
du -sh /var/log/vault/

# Clean up old rotated logs
find /var/log/vault/ -name "audit.log.*" -mtime +30 -delete
```

3. **Audit Device Failures**
- Remember: If all audit devices fail, Vault will no longer respond to clients
- Always have sufficient disk space
- Monitor log file permissions

## Lab Cleanup
```bash
# Disable audit device
vault audit disable file/

# Remove audit logs
rm -rf /var/log/vault/audit.log*

# Remove logrotate configuration
rm /etc/logrotate.d/vault
```

## Additional Resources
- [Vault Audit Devices Documentation](https://www.vaultproject.io/docs/audit)
- [Vault Audit Devices API](https://www.vaultproject.io/api-docs/system/audit)
- [Log Rotation Best Practices](https://www.vaultproject.io/docs/configuration/listener/tcp#rotation)