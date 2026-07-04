# common role

Prepares the host for the other roles.

## What it installs

- base Ubuntu packages
- sysctl settings
- Docker
- Nginx
- Certbot
- `kubectl` when Kubernetes mode is used
- Helm when Harbor or Vault use Kubernetes mode

## How it works

- runs before the app roles
- only installs what is enabled by config
- can also clean up packages during destroy flows

## Main settings

- `install_docker`
- `install_nginx`
- `install_certbot`
- `install_kubectl`

## Use

In this repo, you normally do not call this role directly. It is used automatically by the main playbook.
