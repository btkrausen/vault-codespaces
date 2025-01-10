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
    echo "vaultuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && sudo groupadd vault

RUN sudo useradd -r -m -g vault -d /home/vault -s /bin/bash -c "Vault user" vault

COPY vault.hcl /etc/vault.d/

RUN mkdir -p /opt/vault/data /etc/vault.d /var/lib/vault /usr/local/bin && \
    chown -R vaultuser:vaultuser /opt/vault /etc/vault.d /var/lib/vault && \
    chmod 640 /etc/vault.d/vault.hcl

# Download and install Vault
RUN wget https://releases.hashicorp.com/vault/1.18.3/vault_1.18.3_linux_amd64.zip && \
    unzip vault_1.18.3_linux_amd64.zip && \
    mv vault /usr/local/bin/ && \
    chown vaultuser:vaultuser /usr/local/bin/vault && \
    chmod 750 /usr/local/bin/vault && \
    rm vault_1.18.3_linux_amd64.zip

# Create startup script
COPY start-vault.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/start-vault.sh && \
    chown vaultuser:vaultuser /usr/local/bin/start-vault.sh
