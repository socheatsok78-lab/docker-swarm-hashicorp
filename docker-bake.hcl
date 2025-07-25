variable "GITHUB_REPOSITORY_OWNER" {
  default = "socheatsok78-lab"
}

target "docker-metadata-action" {}
target "github-metadata-action" {}

group "default" {
  targets = [
    "consul",
    "consul-node-init",
    "vault",
  ]
}

group "dev" {
  targets = [
    "consul-dev",
    "vault-dev",
    "consul-node-init-dev",
  ]
}

# --------------------------------------------------
# HashiCorp Consul
# --------------------------------------------------

variable "CONSUL_VERSIONS" {
  type = list(string)
  default = [
    "1.21.3",
  ]
}

target "consul" {
  matrix = {
    version = CONSUL_VERSIONS
  }
  name = "consul_${replace(version, ".", "_")}"
  inherits = [
    "docker-metadata-action",
    "github-metadata-action",
  ]
  context = "consul/v${version}"
  contexts = {
    "go-discover-dockerswarm" = "target:go-discover-dockerswarm"
  }
  platforms = [
    "linux/amd64",
    "linux/arm64",
  ]
  tags = [
    "ghcr.io/${GITHUB_REPOSITORY_OWNER}/consul:${version}"
  ]
}

target "consul-dev" {
  matrix = {
    version = CONSUL_VERSIONS
  }
  name = "consul_${replace(version, ".", "_")}_dev"
  context = "consul/v${version}"
  contexts = {
    "go-discover-dockerswarm" = "target:go-discover-dockerswarm"
  }
  tags = [
    "ghcr.io/${GITHUB_REPOSITORY_OWNER}/consul:${version}-dev"
  ]
}

target "consul-node-init" {
  inherits = [
    "docker-metadata-action",
    "github-metadata-action",
  ]
  context = "consul-node-init"
  platforms = [
    "linux/amd64",
    "linux/arm64",
  ]
  tags = [ "ghcr.io/${GITHUB_REPOSITORY_OWNER}/consul-node-init:latest" ]
}

target "consul-node-init-dev" {
  context = "consul-node-init"
  tags = [ "ghcr.io/${GITHUB_REPOSITORY_OWNER}/consul-node-init:dev" ]
}

# --------------------------------------------------
# HashiCorp Vault
# --------------------------------------------------

variable "VAULT_VERSIONS" {
  type = list(string)
  default = [
    "1.20.0",
  ]
}

target "vault" {
  matrix = {
    version = VAULT_VERSIONS
  }
  name = "vault_${replace(version, ".", "_")}"
  inherits = [
    "docker-metadata-action",
    "github-metadata-action",
  ]
  context = "vault/v${version}"
  contexts = {
    "go-discover-dockerswarm" = "target:go-discover-dockerswarm"
  }
  platforms = [
    "linux/amd64",
    "linux/arm64",
  ]
  tags = [
    "ghcr.io/${GITHUB_REPOSITORY_OWNER}/vault:${version}"
  ]
}

target "vault-dev" {
  matrix = {
    version = VAULT_VERSIONS
  }
  name = "vault_${replace(version, ".", "_")}_dev"
  context = "vault/v${version}"
  contexts = {
    "go-discover-dockerswarm" = "target:go-discover-dockerswarm"
  }
  tags = [
    "ghcr.io/${GITHUB_REPOSITORY_OWNER}/vault:${version}-dev"
  ]
}

# --------------------------------------------------
# .
# --------------------------------------------------

target "go-discover-dockerswarm" {
  context = "go-discover-dockerswarm"
  tags = [
    "ghcr.io/${GITHUB_REPOSITORY_OWNER}/go-discover-dockerswarm:cacheonly"
  ]
}
