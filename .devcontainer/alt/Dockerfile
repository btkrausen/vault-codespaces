# Use the official HashiCorp Vault image
FROM hashicorp/vault:latest

# Switch to root to install packages
USER root

ENV DEBIAN_FRONTEND=noninteractive

# Install Git (and clean up)
RUN apt-get update && apt-get install -y git && rm -rf /var/lib/apt/lists/*

# Switch back to the vault user
USER vault

# Copy the Vault config into the container
COPY vault.hcl /vault/config/vault.hcl

# Expose Vault's default port
EXPOSE 8200

ENTRYPOINT ["vault", "server", "-config=/vault/config/vault.hcl"]
