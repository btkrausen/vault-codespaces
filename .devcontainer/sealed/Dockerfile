# Use a lightweight Ubuntu LTS image
FROM hashicorp/vault:latest

ENV DEBIAN_FRONTEND=noninteractive


# Install Vault (pick the version you want)
RUN vault --version

# Create a non-root user for best practices in Codespaces
RUN useradd -ms /bin/bash codespace
USER codespace
WORKDIR /home/codespace

# Copy the Vault config into the container
COPY vault.hcl /home/codespace/vault.hcl

# Expose Vault's default port
EXPOSE 8200
