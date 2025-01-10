#!/bin/bash
export VAULT_ADDR='http://127.0.0.1:8200'

# Start Vault in background
vault server -config=/etc/vault.d/vault.hcl > /tmp/vault.log 2>&1 &

# Wait for Vault to start
sleep 5

# Check if Vault is running
until curl -fs http://127.0.0.1:8200/v1/sys/health > /dev/null; do
    echo "Waiting for Vault to start..."
    sleep 2
done

echo "Vault is running and ready for initialization"
