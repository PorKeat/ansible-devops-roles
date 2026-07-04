# DevOps Ansible Roles

Deploy Jenkins, SonarQube, Harbor, and HashiCorp Vault from one repo.

Edit only:

- `config.yaml`

## Quick Start

```bash
just init
just syntax
just run
```

## Tools

```yaml
jenkins: true
sonarqube: false
harbor: false
hashicorp_vault: false
```

- `jenkins`: install or remove Jenkins
- `sonarqube`: install or remove SonarQube
- `harbor`: install or remove Harbor
- `hashicorp_vault`: install or remove HashiCorp Vault

## Basic Config

```yaml
target_layout: single

ansible_connection: ssh
ansible_host: 34.87.60.237
ansible_user: ubuntu
ansible_python_interpreter: /usr/bin/python3

deployment_state: present
global_deploy_mode: docker
use_domain: false
```

- `global_deploy_mode: kubernetes` works with normal Kubernetes or k3s if your kubeconfig points there

SSH first connect or host key prompts:

```yaml
ansible_ssh_common_args: -o StrictHostKeyChecking=accept-new
```

If the server was rebuilt and you already trusted the old key, remove the stale entry first:

```bash
ssh-keygen -R 34.142.227.94
```

## Common Examples

Jenkins only:

```yaml
jenkins: true
sonarqube: false
harbor: false
hashicorp_vault: false
```

SonarQube only:

```yaml
jenkins: false
sonarqube: true
harbor: false
hashicorp_vault: false
```

SonarQube on Kubernetes:

```yaml
sonarqube: true
global_deploy_mode: kubernetes
use_domain: false
```

MinIO only:

```yaml
jenkins: false
sonarqube: false
harbor: false
hashicorp_vault: false
minio: true
```

Harbor only:

```yaml
jenkins: false
sonarqube: false
harbor: true
hashicorp_vault: false
```

Vault only:

```yaml
jenkins: false
sonarqube: false
harbor: false
hashicorp_vault: true
vault_mode: testing
```

Harbor on Kubernetes:

```yaml
harbor: true
global_deploy_mode: kubernetes
use_domain: false
```

Vault on Kubernetes:

```yaml
hashicorp_vault: true
global_deploy_mode: kubernetes
vault_mode: production
```

MinIO on Kubernetes:

```yaml
minio: true
global_deploy_mode: kubernetes
use_domain: false
```

## IP Or Domain

IP-only testing:

```yaml
use_domain: false
```

Domain later:

```yaml
use_domain: true
enable_tls: false
jenkins_domain: jenkins.example.com
sonarqube_domain: sonar.example.com
harbor_domain: harbor.example.com
vault_domain: vault.example.com
minio_api_domain: minio-api.example.com
minio_console_domain: minio-console.example.com
```

HTTPS later:

```yaml
use_domain: true
enable_tls: true
tls_email: you@example.com
```

Then run:

```bash
just domain
```

## Commands

```bash
just init
just syntax
just run
just domain
just kubernetes
just destroy
just destroy-all
just vault-token
```

- `just run`: deploy or update selected tools
- `just domain`: update only domain, web, and TLS settings
- `just kubernetes`: run with `global_deploy_mode=kubernetes`
- `just destroy`: remove only selected tools
- `just destroy-all`: remove everything, ignores tool booleans
- `just vault-token`: generate a Vault testing token and save it into `config.yaml`

## Defaults

- Jenkins: `admin` and initial password from the final summary
- SonarQube: `admin / admin`
- Harbor: `admin / Harbor12345`
- Vault testing UI: `http://SERVER_IP:8200/ui`
- MinIO: API `http://minio-api.example.com` and console `http://minio-console.example.com`

## Important Notes

- `just destroy` respects the tool booleans
- `just destroy-all` removes everything no matter what the booleans are
- This setup uses **Traefik** as the reverse proxy instead of Nginx. Traefik automatically discovers containers and handles Let's Encrypt certificates.
- Harbor firewall: allow `8081` for HTTP or `8443` for HTTPS
- Vault firewall: allow `8200`
- MinIO uses separate API and console domains when `use_domain: true`
- MinIO on Kubernetes IP mode uses NodePorts `30910` and `30911` by default
- SonarQube on Kubernetes IP mode uses NodePort `30900` by default
- Harbor on Kubernetes IP mode uses NodePort `30081` by default
- Vault on Kubernetes IP mode uses NodePort `30200` by default
- Vault testing mode uses the token in `vault_root_token`
- Vault production mode now automatically performs `vault operator init`, unsealing, and configures AppRole/KV v2
- `.app` domains should use TLS
