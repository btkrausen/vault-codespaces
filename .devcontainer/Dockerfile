# Use any base that is convenient for you; here's Ubuntu LTS
FROM ubuntu:22.04

# Avoid interactive prompts during package installs
ENV DEBIAN_FRONTEND=noninteractive

# Update packages and install prerequisites
RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    curl \
    ca-certificates \
    vim \
    jq \
    && rm -rf /var/lib/apt/lists/*

# Install Vault (specify the version you want)
ENV VAULT_VERSION=1.15.3
RUN wget https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip -O /tmp/vault.zip \
    && unzip /tmp/vault.zip -d /usr/local/bin/ \
    && rm /tmp/vault.zip \
    && vault --version

# Create a non-root user (Codespaces best practice)
RUN useradd -ms /bin/bash codespace
USER codespace
WORKDIR /home/codespace

# Expose Vault's default port
EXPOSE 8200
