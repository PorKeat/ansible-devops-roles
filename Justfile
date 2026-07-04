export ANSIBLE_LOCAL_TEMP := "/tmp/.ansible/tmp"

# Show available commands
list:
    @echo "Edit config.yaml, then use one of these commands:"
    @just --list

# Install required Ansible collections
init:
    @ansible-galaxy collection install -r collections/requirements.yaml

# Deploy or update selected tools
run:
    @env ANSIBLE_FORCE_COLOR=1 PY_COLORS=1 ansible-playbook playbooks/site.yaml

# Update domain, ingress, and TLS only
domain:
    @env ANSIBLE_FORCE_COLOR=1 PY_COLORS=1 ansible-playbook playbooks/site.yaml -e web_only=true

# Generate a Vault testing token and save it into config.yaml
vault-token:
    #!/usr/bin/env bash
    set -euo pipefail
    token="vault-dev-$(openssl rand -hex 24)"
    perl -0pi -e "s/^vault_root_token:.*\$/vault_root_token: $token/m" config.yaml
    printf 'Updated config.yaml\n'
    printf 'vault_root_token: %s\n' "$token"

# Remove only selected tools
destroy:
    @env ANSIBLE_FORCE_COLOR=1 PY_COLORS=1 ansible-playbook playbooks/site.yaml -e deployment_state=absent

# Remove everything and ignore tool toggles
destroy-all:
    @env ANSIBLE_FORCE_COLOR=1 PY_COLORS=1 ansible-playbook playbooks/site.yaml -e deployment_state=absent -e destroy_all=true

# Force Docker mode for this run
docker:
    @env ANSIBLE_FORCE_COLOR=1 PY_COLORS=1 ansible-playbook playbooks/site.yaml -e global_deploy_mode=docker

# Force Kubernetes mode for this run
k8s:
    @env ANSIBLE_FORCE_COLOR=1 PY_COLORS=1 ansible-playbook playbooks/site.yaml -e global_deploy_mode=k8s

# Force Kubernetes mode for this run
kubernetes:
    @env ANSIBLE_FORCE_COLOR=1 PY_COLORS=1 ansible-playbook playbooks/site.yaml -e global_deploy_mode=kubernetes

# Show project files
tree:
    @find . | sort
