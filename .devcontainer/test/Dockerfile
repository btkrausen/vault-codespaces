# Use the official HashiCorp Vault image
FROM hashicorp/vault:latest

ENV DEBIAN_FRONTEND=noninteractive

# Install Vault (pick the version you want)
RUN vault --version

# Copy the Vault config into the container
COPY vault.hcl /vault/config/vault.hcl

# Expose Vault's default port
EXPOSE 8200
