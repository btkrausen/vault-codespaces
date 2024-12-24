# Use a lightweight Ubuntu LTS image
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install prerequisites
RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    curl \
    ca-certificates \
    vim \
    jq \
    && rm -rf /var/lib/apt/lists/*

# Install Vault (pick the version you want)
ENV VAULT_VERSION=1.15.3
RUN wget https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip -O /tmp/vault.zip \
    && unzip /tmp/vault.zip -d /usr/local/bin/ \
    && rm /tmp/vault.zip \
    && vault --version

# Create a non-root user for best practices in Codespaces
RUN useradd -ms /bin/bash codespace
USER codespace
WORKDIR /home/codespace

# Copy the Vault config into the container
COPY vault.hcl /home/codespace/vault.hcl

# Expose Vault's default port
EXPOSE 8200
