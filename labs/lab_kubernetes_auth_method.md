## Lab 1: Kubernetes Authentication

### Overview
Configure and test Kubernetes authentication using a mock setup.

**Time to Complete**: 20-25 minutes

**Preview Mode**: Use `Cmd/Ctrl + Shift + V` in VSCode to see a nicely formatted version of this lab!

## How to Use This Hands-On Lab

1. **Create a Codespace** from this repo (click the button below).  
2. Once the Codespace is running, open the integrated terminal.
3. Follow the instructions in each **lab** to complete the exercises.

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/btkrausen/vault-codespaces)

## Steps

1. Generate a mock certificate from our Kubernetes cluster
```bash
echo "-----BEGIN CERTIFICATE-----
MIICpjCCAY4CCQClrlkJyaahwDANBgkqhkiG9w0BAQsFADAVMRMwEQYDVQQDDApr
dWJlcm5ldGVzMB4XDTI0MTIyNzIwMzAxOFoXDTI3MTAxNzIwMzAxOFowFTETMBEG
A1UEAwwKa3ViZXJuZXRlczCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEB
AJ4KtVfU7CD+aQdqj3R5rBmAmsulosuYF4T3gRZurmXc6A93Dqukh2B0g5l9QKDJ
0Y+FMiVbx7qKfrkGZcUizO3IH2HF29Cew1rkLIqeGz6NveyTuwtz2Qk5n+l6V1JQ
qmA9xljpL+45RlVrJY29CgzyMUE3/yGrrhqyeInJHIQGCRYwePxh1LFycF4AC/SO
Wad0Y6PTvUZpbGazpZY7T8EFRm9uJq079jrpexDS0oMkt9Sft/eFIi8ri8o7i/yr
ClaPFyzkWZhDncyDfvOFUZH7Tg8zFfNfefSyUYt5Qprakqh2MpLvj4JONzxG03XO
dHYTX4T/oPU1GpNleRKewtsCAwEAATANBgkqhkiG9w0BAQsFAAOCAQEAPEQxQAv5
r75A7gYb64OV133G61lJIZVkDj4aQqMzpeT9sq+tCJm0OBw+GdkcQSXewq3F4mZr
htmCDBDJBAffJYvyNLyI9nDQ7o4SURrKBVN7NY6DAAtKolwW4bJiqYEE1g5iTAhO
+EB1HWJqZCx0llGIdsc9GBFBzpXDcvqRuXrYDaVKiN7VtN+3QIz8ysJTEHBPk5Aj
ZrRtwgfEEymwA6HX2HS0NpPiT5MORTSsLaOwEuMKNvaoULgGHQ7a5UoNcUgHNp4n
KrdsvtMMpZWCn9ZKjrq2xYD7OJqxn989B8Y91gP4DbHUzx7KB107TgbLuZrM69aX
61ETnWq25yXd0g==
-----END CERTIFICATE-----" > mock-ca.crt
```
# Create mock JWT token
```bash
echo "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6InRlc3Qtc2EiLCJpYXQiOjE1MTYyMzkwMjJ9.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c" > jwt.txt
```

2. Enable auth method:
```bash
# Log in with a valid token
vault login root

# Enable the Kubernetes auth method
vault auth enable kubernetes
```

3. Configure Kubernetes auth configuration (this is a per cluster configuration):
```bash

# Configure Kubernetes auth
vault write auth/kubernetes/config \
    kubernetes_host="https://mock-k8s:8443" \
    token_reviewer_jwt=@jwt.txt \
    kubernetes_ca_cert=@mock-ca.crt \
    issuer="https://kubernetes.default.svc.cluster.local"
```

4. Create app policy:
```bash
vault policy write my-app-policy - <<EOF
path "secret/data/my-app/*" {
  capabilities = ["read"]
}
EOF
```

5. Create a Kubernetes auth role for our application:
```bash
vault write auth/kubernetes/role/my-app \
    bound_service_account_names=my-app \
    bound_service_account_namespaces=default \
    policies=my-app-policy \
    ttl=1h
```

6. Test authentication (simulated - this won't work since we don't have a real k8s cluster):
```bash
# Simulate Kubernetes service account JWT login
vault write auth/kubernetes/login \
    role=my-app \
    jwt=@jwt.txt
```

### Cleanup
```bash
vault auth disable kubernetes
```

## Learning Resources
- [Kubernetes Auth Method](https://developer.hashicorp.com/vault/docs/auth/kubernetes)