## Lab 1: Kubernetes Authentication

### Overview
Configure and test Kubernetes authentication using a mock setup.

**Time to Complete**: 20-25 minutes

## How to Use This Hands-On Lab

1. **Create a Codespace** from this repo (click the button below).  
2. Once the Codespace is running, open the integrated terminal.
3. Follow the instructions in each **lab** to complete the exercises.

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/btkrausen/vault-codespaces)

## Steps

1. Enable auth method:
```bash
vault auth enable kubernetes
```

2. Configure mock Kubernetes auth:
```bash
# Create mock JWT token
echo "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6InRlc3Qtc2EiLCJpYXQiOjE1MTYyMzkwMjJ9.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c" > jwt.txt

# Configure Kubernetes auth
vault write auth/kubernetes/config \
    kubernetes_host="https://mock-k8s:8443" \
    token_reviewer_jwt=@jwt.txt \
    kubernetes_ca_cert=@mock-ca.crt \
    issuer="https://kubernetes.default.svc.cluster.local"
```

3. Create role:
```bash
vault write auth/kubernetes/role/my-app \
    bound_service_account_names=my-app \
    bound_service_account_namespaces=default \
    policies=my-app-policy \
    ttl=1h
```

4. Create app policy:
```bash
vault policy write my-app-policy - <<EOF
path "secret/data/my-app/*" {
  capabilities = ["read"]
}
EOF
```

5. Test authentication (simulated):
```bash
# Simulate Kubernetes service account JWT login
vault write auth/kubernetes/login \
    role=my-app \
    jwt=@jwt.txt
```

6. Test policy restrictions:
```bash
# Set VAULT_TOKEN to the token from previous step
export VAULT_TOKEN="<token>"

# Test access
vault kv put secret/my-app/config value=test  # Should fail (read-only)
vault kv get secret/my-app/config  # Should work
vault kv get secret/other/config  # Should fail
```

### Cleanup
```bash
vault auth disable kubernetes
```

## Learning Resources
- [Kubernetes Auth Method](https://developer.hashicorp.com/vault/docs/auth/kubernetes)