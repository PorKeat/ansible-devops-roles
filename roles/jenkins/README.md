# jenkins role

Installs Jenkins and shows the login URL in the final summary.

## What it does

- deploys Jenkins in Docker or Kubernetes
- can expose Jenkins by IP or domain
- can configure Nginx
- can use TLS when enabled

## Main settings

- `jenkins: true`
- `global_deploy_mode: docker | k8s`
- `jenkins_image`
- `jenkins_http_port`
- `jenkins_agent_port`
- `use_domain`
- `jenkins_domain`

## Use

In this repo, turn it on in `config.yaml`:

```yaml
jenkins: true
```

Then run:

```bash
just run
```
