# sonarqube role

Installs SonarQube and its PostgreSQL database, then shows the login URL in the final summary.

## What it does

- deploys SonarQube with PostgreSQL
- supports Docker or Kubernetes
- can expose SonarQube by IP or domain
- can configure Nginx
- can use TLS when enabled

## Main settings

- `sonarqube: true`
- `global_deploy_mode: docker | k8s`
- `sonarqube_image`
- `postgres_image`
- `sonarqube_http_port`
- `postgres_port`
- `sonarqube_db_name`
- `sonarqube_db_user`
- `sonarqube_db_password`
- `use_domain`
- `sonarqube_domain`

## Use

In this repo, turn it on in `config.yaml`:

```yaml
sonarqube: true
```

Then run:

```bash
just run
```

Kubernetes note:

- IP testing uses NodePort `30900` by default
- domain mode uses Ingress
