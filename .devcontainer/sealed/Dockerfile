# Use the official HashiCorp Vault image
FROM hashicorp/vault:latest

# Switch to root user to copy files and expose port
USER root

# Copy our config file into the Vault config directory
COPY vault.hcl /vault/config/vault.hcl

# Expose Vault's default port
EXPOSE 8200

# Use the Vault server command with our custom config
ENTRYPOINT ["vault", "server", "-config=/vault/config/vault.hcl"]
