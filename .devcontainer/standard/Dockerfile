# Dockerfile
FROM hashicorp/vault:latest

# Set environment variables for dev mode
ENV VAULT_DEV_ROOT_TOKEN_ID=root
ENV VAULT_DEV_LISTEN_ADDRESS=0.0.0.0:8200

# Expose the default Vault port
EXPOSE 8200

# Start Vault in dev mode
CMD ["vault", "server", "-dev"]