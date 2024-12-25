FROM hashicorp/vault:latest

# Switch to root so we can install packages
USER root

# Update the Alpine package index and install git
RUN apk update && apk add --no-cache git libcap
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories

# Switch back to the vault user for best practices
USER vault

# Vault config file, copy it in
COPY vault.hcl /vault/config/vault.hcl

# Expose Vault's default port
EXPOSE 8200
