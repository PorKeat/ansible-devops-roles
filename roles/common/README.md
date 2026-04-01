# common role

The `common` role prepares Ubuntu hosts for Docker-based or Kubernetes-based Jenkins and SonarQube deployments.

## What it does

- installs base system packages
- applies useful sysctl settings for containerized workloads
- optionally installs Docker
- optionally installs Nginx
- optionally installs Certbot
- optionally installs `kubectl` and the Python Kubernetes client

## Task layout

- `tasks/install.yml`: base packages and sysctl settings
- `tasks/docker.yml`: Docker official apt repo, Docker Engine packages, service, and Docker group membership
- `tasks/nginx.yml`: Nginx package and service management
- `tasks/certbot.yml`: Certbot packages
- `tasks/kubectl.yml`: Kubernetes CLI and Python client packages

## Important variables

- `install_docker`
- `install_nginx`
- `install_certbot`
- `install_kubectl`
- `common_base_packages`
- `common_sysctl_settings`
- `docker_packages`
- `docker_conflicting_packages`
- `docker_remove_conflicting_packages`
- `docker_apt_key_url`
- `docker_apt_repo`
- `nginx_packages`
- `certbot_packages`
- `kubectl_packages`

## Notes

- The role is designed for Ubuntu hosts.
- Docker is installed from Docker's official Ubuntu apt repository.
- `vm.max_map_count` is configured to support SonarQube requirements.
- The role does not manage firewall rules.

## Publishing this role to Git later

This role is already structured in a Galaxy-friendly way. To publish it as a standalone reusable role:

1. create a new Git repository such as `ansible-role-common`
2. copy the contents of this directory into that repo root so the repo contains:
   - `defaults/main.yml`
   - `tasks/main.yml`
   - `handlers/main.yml`
   - `meta/main.yml`
   - `README.md`
3. run:

```bash
git init
git add .
git commit -m "Initial common role"
git branch -M main
git remote add origin https://github.com/your-org/ansible-role-common.git
git push -u origin main
```

## Using the role later from another project

Example `requirements.yml`:

```yaml
---
roles:
  - name: common
    src: https://github.com/your-org/ansible-role-common.git
    scm: git
    version: main
```

Install it with:

```bash
ansible-galaxy role install -r requirements.yml -p roles
```
