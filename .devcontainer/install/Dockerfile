FROM rockylinux:9

# Install necessary packages
RUN dnf update -y && \
    dnf install -y \
    wget \
    yum-utils \
    unzip \
    sudo \
    vim \
    tar \
    jq \
    which \
    git \
    && dnf clean all

# Setup non-root user with sudo access
RUN useradd -m -s /bin/bash vaultuser && \
    echo "vaultuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers