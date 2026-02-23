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

<img src="./img/ports.png" width="50%">

2. You should see port 8200 forwarded
3. Click on the "Open in Browser" icon (globe) for port 8200
4. You'll be directed to the Vault UI login page
5. Log in using the root token - type `root` and press enter.

## Part 2: Exploring the UI

1. **Dashboard Overview**
   - Observe the main dashboard components
   - Note the status of your Vault instance
   - Check the server configuration details

2. **Enable a Secrets Engine**
   - Click on `Secrets Engines` in the left navigation
   - Click `Enable new engine`
   - Select `KV` (Key-Value)
   - Use default path: `kv`
   - Under `Method Options`, choose Version `2` if not already selected
   - Click `Enable Engine` at the bottom

3. **Create Secrets**
   - Navigate to your new KV secrets engine
   - Click on `Create secret`
   - Create a new secret path called `webapp`
   - Add the following key-value pairs - you don't need to add the quotes, just the values:
     ```
     database_url: "postgresql://localhost:5432/myapp"
     api_key: "your-secret-key-123"
     ```
   - Save the secret

4. **Create a Policy**
   - Navigate to `Policies` → `ACL Policies`
   - Create a new policy named `webapp-readonly`
   - Add the following policy:
     ```hcl
     path "kv/data/webapp" {
       capabilities = ["read"]
     }

     path "kv/metadata/*" {
       capabilities = ["list"]
     }
     ```
   - Save the policy

5. **Enable and Configure Auth Method**
   - Navigate back to the main dashboard (click on the Vault logo in the top left)
   - Go to `Access` → `Authentication Methods`
   - Click `Enable new method` and select `Userpass`
   - Use the default path of `userpass` and click `Enable method`
   - Once enabled, click on `View method >` on the top right.
   - Create a new user:
     - Username: `webapp-user`
     - Password: `password123`
     - Assign the `webapp-readonly` policy (expand "Tokens" and add the policy under "Generated Token's Policies - type `webapp-readonly`)
     - Click `Save`

## Part 3: Testing Access

1. Log out of the root account by clicking on the user icon in the top left and selecting `Logout`
2. Select the `userpass` method from the Method dropdown
3. Log in using the `webapp-user` username and password of `password123`
4. Click on the `Secrets Engines` in the left navigation and navigate to your `kv` secrets engine
5. Try to access the `webapp` secret you created earlier. Click on the `Secret` tab
6. Try to:
   - Read the webapp secrets by clikcing the eye icon (should succeed)
   - Modify the existing secrets by creating a new secret with new values on the same path (should fail)
   - Click on `KV` at the top and try to create a new secret (should get permission denied)

## Part 4: Grant CRUD to webapp-user and Test

1. Log back in as `root` (use the root token name on the Vault UI login page).  
2. Go to Policies → ACL Policies → edit `webapp-readonly` and replace with:
```hcl
path "kv/data/webapp" {
   capabilities = ["create", "read", "update", "delete"]
}

path "kv/metadata/*" {
   capabilities = ["list"]
}
```
Save the policy.

3. Log out root and log in as `webapp-user` (userpass).  
4. In Secrets Engines → kv → webapp:
      - Create a new secret or modify the existing values (should succeed).
      - Delete the secret to confirm delete capability (should succeed).

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
