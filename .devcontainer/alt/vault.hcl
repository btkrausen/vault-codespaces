listener "tcp" {
  address         = "127.0.0.1:8200"
  cluster_address = "127.0.0.1:8201"
  tls_disable     = 1
}

storage "file" {
  path = "/vault/file"
}

api_addr = "http://127.0.0.1:8200"

# Disable mlock so it works in a container for lab environments
disable_mlock = true