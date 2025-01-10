# Hands-on Lab: Working with HashiCorp Vault PKI Secrets Engine

## Overview
In this lab, you will learn how to use HashiCorp Vault's PKI secrets engine to create and manage a Public Key Infrastructure. You will set up a root CA, create an intermediate CA, and generate certificates for services using both direct CLI output and file-based methods.

**Time Required:** ~60 minutes

**Preview Mode**: Use `Cmd/Ctrl + Shift + V` in VSCode to see a nicely formatted version of this lab!

## How to Use This Hands-On Lab

1. **Create a Codespace** from this repo (click the button below).  
2. Once the Codespace is running, open the integrated terminal.
3. Follow the instructions in each **lab** to complete the exercises.

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/btkrausen/vault-codespaces)

## Steps

### Step 1: Enable the PKI Secrets Engine

1. First, enable a PKI secrets engine for the root CA:
```bash
vault secrets enable -path=pki_root pki
```

2. Configure the maximum lease TTL to 10 years:
```bash
vault secrets tune -max-lease-ttl=87600h pki_root
```

### Step 2: Generate Root CA

1. Generate and view the root certificate directly in the CLI:
```bash
vault write pki_root/root/generate/internal \
    common_name="Lab Root CA" \
    ttl=87600h
```

2. Generate it again but save to a file for later use:
```bash
vault write -format=json pki_root/root/generate/internal \
    common_name="Lab Root CA" \
    ttl=87600h > root_ca.json

cat root_ca.json | jq -r .data.certificate > root_ca.pem
```

3. Configure the CA and CRL URLs:
```bash
vault write pki_root/config/urls \
    issuing_certificates="http://vault.lab:8200/v1/pki_root/ca" \
    crl_distribution_points="http://vault.lab:8200/v1/pki_root/crl"
```

### Step 3: Create Intermediate CA

1. Enable a PKI secrets engine for the intermediate CA:
```bash
vault secrets enable -path=pki_int pki
```

2. Set a shorter max TTL for the intermediate CA (5 years):
```bash
vault secrets tune -max-lease-ttl=43800h pki_int
```

3. Generate and view the intermediate CSR directly:
```bash
vault write pki_int/intermediate/generate/internal \
    common_name="Lab Intermediate CA" \
    ttl=43800h
```

4. Generate it again and save to a file:
```bash
vault write -format=json pki_int/intermediate/generate/internal \
    common_name="Lab Intermediate CA" \
    ttl=43800h > intermediate.json

cat intermediate.json | jq -r .data.csr > intermediate.csr
```

5. Sign the intermediate CSR with the root CA and save to a file:
```bash
vault write -format=json pki_root/root/sign-intermediate \
    csr=@intermediate.csr \
    format=pem_bundle \
    ttl=43800h > signed_intermediate.json

cat signed_intermediate.json | jq -r .data.certificate > signed_intermediate.pem
```

7. Import the signed certificate back into the Vault Intermediate:
```bash
vault write pki_int/intermediate/set-signed \
    certificate=@signed_intermediate.pem
```

### Step 4: Create a Role for Issuing Certificates

1. Create a role for issuing certificates for a webapp:
```bash
vault write pki_int/roles/webapp \
    allowed_domains="lab.local" \
    allow_subdomains=true \
    max_ttl=720h \
    key_type="rsa" \
    key_bits=2048 \
    allowed_uri_sans="dns://lab.local" \
    require_cn=true \
    basic_constraints_valid_for_non_ca=true
```

### Step 5: Generate a Certificate for the webapp:

1. Generate and view a certificate directly in the CLI:
```bash
vault write pki_int/issue/webapp \
    common_name="webapp.lab.local" \
    ttl=72h
```

This will display:
- The certificate
- The private key (Vault will only output the private key once)
- CA chain
- Serial number
- Other metadata

2. Issue a certificate and save it to files (useful for deploying to services):
```bash
vault write -format=json pki_int/issue/webapp \
    common_name="webapp.lab.local" \
    ttl=72h > webapp_cert.json

# Extract each component to its own file
cat webapp_cert.json | jq -r .data.certificate > webapp_cert.pem
cat webapp_cert.json | jq -r .data.private_key > webapp_key.pem
cat webapp_cert.json | jq -r .data.ca_chain[] > webapp_ca_chain.pem

# [Optional] View each file to see the contents
cat webapp_cert.pem
cat webapp_key.pem
cat webapp_ca_chain.pem
```

### Step 6: Verify the Certificate

1. View the certificate details:
```bash
# For the CLI-generated certificate, copy the certificate content to a file first
# For the file-based certificate:
openssl x509 -in webapp_cert.pem -text -noout
```

### Step 7: Working with Certificate Revocation

1. View a certificate's serial number:
```bash
# Directly from CLI output when generating
vault write pki_int/issue/webapp common_name="temp.lab.local" ttl=72h

# Or from a saved certificate
openssl x509 -in webapp_cert.pem -noout -serial
```

2. Revoke a certificate:
```bash
vault write pki_int/revoke \
    serial_number=<serial_number_from_certificate>
```

3. Generate a new CRL:
```bash
vault write pki_int/config/urls \
    issuing_certificates="http://vault.lab:8200/v1/pki_int/ca" \
    crl_distribution_points="http://vault.lab:8200/v1/pki_int/crl"
```

## Create a Vault Policy for the Application named `webapp` to Generate a PKI Certificate

1. Create a new file named `webapp-policy.hcl`

**Right-click** in the left navigation pane or use the command `touch webapp-policy.hcl`

```hcl
# Permit reading the configured certificates
path "pki_int/cert/*" {
    capabilities = ["read", "list"]
}

# Permit creating certificates from the webapp role
path "pki_int/issue/webapp" {
    capabilities = ["create", "update"]
}

# Allow reading the CRL and CA certificate
path "pki_int/cert/ca" {
    capabilities = ["read"]
}

path "pki_int/cert/crl" {
    capabilities = ["read"]
}
```

2. Write the policy to Vault:
```bash
vault policy write policy-webapp-pki webapp-policy.hcl
```
> Note: In production, you would most likely attach this policy to your webapp's authentication role to give it the authorization to generate certificates (among other permissions it might need).

## Challenge Exercises

1. Create certificates with different parameters:
   - Generate a certificate with multiple Subject Alternative Names (SANs):
     ```bash
     vault write pki_int/issue/webapp \
         common_name="webapp.lab.local" \
         alt_names="app.lab.local,api.lab.local" \
         ttl=72h
     ```
   - Save the multi-SAN certificate to files
   - Compare the CLI output with the saved files

2. Create a wildcard certificate:
   ```bash
   vault write pki_int/issue/webapp \
       common_name="*.lab.local" \
       ttl=72h
   ```

3. Implement certificate rotation:
   - Issue a certificate with a 1-hour TTL
   - Write a script to check expiration and auto-renew
   - Handle both CLI output and file-based storage

## Clean Up

1. Revoke all certificates issued by the intermediate CA:
```bash
vault write pki_int/tidy \
    tidy_cert_store=true \
    tidy_revoked_certs=true \
    safety_buffer=72h
```

2. Disable the PKI secrets engines:
```bash
vault secrets disable pki_root
vault secrets disable pki_int
```

3. Remove generated files:
```bash
rm *.json *.pem *.csr
```

## Best Practices

1. **Certificate Generation**:
   - Use CLI output for testing and verification
   - Use file-based storage for production deployments
   - Always secure private key files with appropriate permissions

2. **Root CA Management**:
   - Keep the root CA offline when not in use
   - Use long validity periods for root CAs
   - Maintain secure backups of root CA private keys

3. **Intermediate CA**:
   - Use intermediate CAs for day-to-day certificate issuance
   - Implement regular rotation of intermediate CA certificates
   - Maintain separate intermediates for different environments

4. **Monitoring and Auditing**:
   - Regular monitoring of certificate expiration
   - Audit of certificate issuance and revocation
   - Monitoring of CRL and OCSP availability

## Conclusion

In this lab, you learned how to:
- Set up a complete PKI infrastructure using Vault
- Generate and manage root and intermediate CAs
- Issue certificates using both CLI and file-based methods
- Implement certificate management best practices

## Additional Resources

- [Vault PKI Secrets Engine Documentation](https://www.vaultproject.io/docs/secrets/pki)
- [OpenSSL Documentation](https://www.openssl.org/docs/)
- [PKI Best Practices](https://www.hashicorp.com/blog/certificate-management-with-vault)
- [Automated Certificate Management](https://learn.hashicorp.com/tutorials/vault/pki-engine)