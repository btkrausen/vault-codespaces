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
