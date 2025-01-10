# Dockerfile
FROM ubuntu:22.04

# Avoid prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary packages
RUN apt-get update && apt-get install -y \
    curl \
    gpg \
    lsb-release \
    jq \
    vim \
    sudo \
    wget \
    unzip \
    git \
    software-properties-common \
    && rm -rf /var/lib/apt/lists/*

# Create non-root user
RUN useradd -m -s /bin/bash vaultuser && \
    echo "vaultuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Download and install Vault
RUN wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list && \
    apt-get update && apt-get install -y vault

# Create Vault directories
RUN mkdir -p /opt/vault/data /etc/vault.d && \
    chown -R vaultuser:vaultuser /opt/vault /etc/vault.d

# Create Vault configuration
COPY vault.hcl /etc/vault.d/
RUN chown vaultuser:vaultuser /etc/vault.d/vault.hcl && \
    chmod 640 /etc/vault.d/vault.hcl

# Create startup script
COPY start-vault.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/start-vault.sh && \
    chown vaultuser:vaultuser /usr/local/bin/start-vault.sh
