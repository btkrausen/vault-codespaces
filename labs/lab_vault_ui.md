# HashiCorp Vault UI Lab

## Overview
Learn how to use the Vault UI to configure and manage HashiCorp Vault

**Time to Complete**: 25 minutes

**Preview Mode**: Use `Cmd/Ctrl + Shift + V` in VSCode to see a nicely formatted version of this lab!

## How to Use This Hands-On Lab

1. **Create a Codespace** from this repo (click the button below).  
2. Once the Codespace is running, open the integrated terminal.
3. Follow the instructions in each **lab** to complete the exercises.

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/btkrausen/vault-codespaces)

## Steps

## Part 1: Accessing the Vault UI

1. After your Codespace starts, click on the "Ports" tab in the bottom panel

<img src="./img/" width="50%">

2. You should see port 8200 forwarded
3. Click on the "Open in Browser" icon (globe) for port 8200
4. You'll be directed to the Vault UI login page
5. Log in using the token: `root`

## Part 2: Exploring the UI

1. **Dashboard Overview**
   - Observe the main dashboard components
   - Note the status of your Vault instance
   - Check the server configuration details

2. **Enable a Secrets Engine**
   - Click on "Secrets" in the left navigation
   - Click "Enable new engine"
   - Select "KV" (Key-Value)
   - Use path: "kv"
   - Choose Version 2
   - Click "Enable Engine"

3. **Create Secrets**
   - Navigate to your new KV secrets engine
   - Create a new secret path called "webapp"
   - Add the following key-value pairs:
     ```
     database_url: "postgresql://localhost:5432/myapp"
     api_key: "your-secret-key-123"
     ```
   - Save the secret

4. **Create a Policy**
   - Navigate to "Policies" → "ACL Policies"
   - Create a new policy named "webapp-readonly"
   - Add the following policy:
     ```hcl
     path "kv/data/webapp" {
       capabilities = ["read"]
     }
     ```

5. **Enable and Configure Auth Method**
   - Go to "Access" → "Auth Methods"
   - Enable the "Username & Password" auth method
   - Create a new user:
     - Username: "webapp-user"
     - Password: "password123"
     - Assign the "webapp-readonly" policy

## Part 3: Testing Access

1. Log out of the root account
2. Log back in using the webapp-user credentials
3. Try to:
   - Read the webapp secrets (should succeed)
   - Create new secrets (should fail)
   - Modify existing secrets (should fail)

## 🔍 Exploration Tasks

Try these additional tasks to deepen your understanding:

1. Enable the AWS secrets engine and explore its configuration options
2. Create a new mount point for another KV secrets engine
3. Generate and rotate credentials
4. Explore the built-in help documentation

## 🎯 Success Criteria

You've completed the lab when you can:
- [x] Successfully access the Vault UI
- [x] Create and manage secrets
- [x] Create and apply policies
- [x] Configure authentication
- [x] Understand the different UI sections and their purposes

## 📚 Additional Resources
- [Vault Documentation](https://www.vaultproject.io/docs)
- [Vault UI Introduction](https://www.vaultproject.io/docs/configuration/ui)
- [Vault Policies](https://www.vaultproject.io/docs/concepts/policies)

## ❓ Troubleshooting

**Common Issues:**
1. **Can't access UI**: Ensure port 8200 is properly forwarded in your Codespace
2. **Login fails**: Verify you're using the correct token or credentials
3. **Permission denied**: Check the policy assignments and capabilities

Need help? Open an issue in the repository or contact the lab administrator.

---
*Happy Secret Managing! 🔐*