# vault role

Installs HashiCorp Vault with the web UI in Docker or Kubernetes.

## What it does

- deploys Vault in Docker mode
- deploys Vault in Kubernetes mode with the official Helm chart
- supports testing mode and production mode
- supports IP or domain access
- supports optional TLS

## Modes

- `testing`: dev mode with a fixed root token
- `production`: single-node persistent mode with automatic init, unseal, AppRole, and KV setup

Important:

- `production` still uses Docker in this repo
- `testing` uses `vault_root_token` from `config.yaml`
- `production` does not need `vault_root_token`
- in `production`, Vault automatically initializes, generates a secure root token, and provisions secrets

## Main settings

- `hashicorp_vault: true`
- `vault_mode: testing | production`
- `vault_version`
- `vault_http_port`
- `vault_cluster_port`
- `vault_root_token`
- `use_domain`
- `vault_domain`
- `vault_namespace`

## Use

In this repo, turn it on in `config.yaml`:

```yaml
hashicorp_vault: true
vault_mode: testing
```

Generate a testing token:

```bash
just vault-token
```

Then run:

```bash
just run
```

Kubernetes note:

- IP testing uses NodePort `30200` by default
- domain mode uses Ingress
