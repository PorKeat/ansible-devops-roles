# harbor role

Installs Harbor in Docker or Kubernetes.

## What it does

- deploys Harbor in Docker mode
- deploys Harbor in Kubernetes mode with the official Helm chart
- supports IP or domain access
- supports optional TLS
- can enable Trivy scanning

## Main settings

- `harbor: true`
- `harbor_version`
- `harbor_http_port`
- `harbor_https_port`
- `harbor_trivy_enabled`
- `harbor_admin_password`
- `harbor_database_password`
- `use_domain`
- `harbor_domain`
- `harbor_namespace`

## Use

In this repo, turn it on in `config.yaml`:

```yaml
harbor: true
```

Then run:

```bash
just run
```

Default access:

- HTTP: `http://SERVER_IP:8081`
- first login: `admin / Harbor12345`

Kubernetes note:

- IP testing uses NodePort `30081` by default
- domain mode uses Ingress
