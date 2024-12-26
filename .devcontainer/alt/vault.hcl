listener "tcp" {
  address     = "0.0.0.0:8200"
  tls_disable = 1
}

storage "file" {
  path = "/vault/file"
}

# Disable mlock so it works in a container for lab environments
disable_mlock = true