listener "tcp" {
  address = "[::]:8200"
  cluster_address = "[::]:8201"
  tls_disable=true
}

storage "file" {
  path = "/vault/file"
}

api_addr = "http://0.0.0.0:8200"

# Disable mlock so it works in a container for lab environments
disable_mlock = true