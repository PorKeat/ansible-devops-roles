#!/usr/bin/env bash

sanitize_yaml_value() {
  local file="$1"
  local key="$2"
  local value="$3"

  KEY="$key" VALUE="$value" perl -0pi -e '
    my $key = $ENV{KEY};
    my $value = $ENV{VALUE};
    s/^([ \t]*#?[ \t]*\Q$key\E:[ \t]*).*$/${1}$value/mg;
  ' "$file"
}

sanitize_inventory_file() {
  local file="$1"

  perl -0pi -e '
    s/\bansible_host=\S+/ansible_host=192.0.2.10/g;
    s/\bansible_user=\S+/ansible_user=ubuntu/g;
    s/\bansible_ssh_private_key_file=\S+/ansible_ssh_private_key_file=~\/.ssh\/change_me/g;
  ' "$file"
}

collect_var_files() {
  local root="$1"

  [[ -f "$root/config.yaml" ]] && printf '%s\0' "$root/config.yaml"

  if [[ -d "$root/group_vars" ]]; then
    find "$root/group_vars" -type f \( -name '*.yaml' -o -name '*.yml' \) -print0
  fi

  if [[ -d "$root/host_vars" ]]; then
    find "$root/host_vars" -type f \( -name '*.yaml' -o -name '*.yml' \) -print0
  fi

  if [[ -d "$root/roles" ]]; then
    find "$root/roles" -path '*/defaults/main.yaml' -print0
  fi
}

cleanup_publish() {
  local repo_root="$1"
  local worktree_dir="$2"
  local publish_branch="$3"

  [[ -n "$repo_root" && -n "$worktree_dir" ]] && git -C "$repo_root" worktree remove --force "$worktree_dir" >/dev/null 2>&1 || true
  [[ -n "$repo_root" && -n "$publish_branch" ]] && git -C "$repo_root" branch -D "$publish_branch" >/dev/null 2>&1 || true
  [[ -n "$worktree_dir" ]] && rm -rf "$worktree_dir" >/dev/null 2>&1 || true
}

default_commit_message() {
  date '+publish:%Y-%m-%d %H:%M:%S'
}

push_repo() (
  local remote="origin"
  local target_branch=""
  local commit_message
  local repo_root
  local current_branch
  local publish_branch
  local worktree_dir
  local base_ref="HEAD"

  set -euo pipefail
  commit_message="$(default_commit_message)"

  if [[ $# -eq 1 ]]; then
    commit_message="$1"
  elif [[ $# -ge 2 ]]; then
    remote="$1"
    target_branch="$2"
    shift 2
    if [[ $# -gt 0 ]]; then
      commit_message="$*"
    fi
  fi

  repo_root="$(git rev-parse --show-toplevel)"
  current_branch="$(git -C "$repo_root" branch --show-current)"

  if [[ -z "$target_branch" ]]; then
    target_branch="${current_branch:-main}"
  fi

  if ! git -C "$repo_root" remote get-url "$remote" >/dev/null 2>&1; then
    echo "Remote '$remote' does not exist." >&2
    return 1
  fi

  if git -C "$repo_root" ls-remote --exit-code --heads "$remote" "$target_branch" >/dev/null 2>&1; then
    echo "Fetching $remote/$target_branch..."
    git -C "$repo_root" fetch "$remote" "$target_branch" >/dev/null
    base_ref="FETCH_HEAD"
  fi

  publish_branch="publish-$(date +%s)"
  worktree_dir="$(mktemp -d "${TMPDIR:-/tmp}/publish-sanitized.XXXXXX")"
  trap "cleanup_publish '$repo_root' '$worktree_dir' '$publish_branch'" EXIT

  echo "Creating temporary publish worktree..."
  git -C "$repo_root" worktree add -b "$publish_branch" "$worktree_dir" "$base_ref" >/dev/null

  echo "Copying current working tree..."
  rsync -a --delete --exclude '.git' "$repo_root"/ "$worktree_dir"/

  echo "Sanitizing credentials in publish copy..."
  while IFS= read -r -d '' file; do
    sanitize_yaml_value "$file" ansible_host "192.0.2.10"
    sanitize_yaml_value "$file" ansible_user "ubuntu"
    sanitize_yaml_value "$file" ansible_ssh_private_key_file "~/.ssh/change_me"
    sanitize_yaml_value "$file" jenkins_ansible_host "192.0.2.10"
    sanitize_yaml_value "$file" jenkins_ansible_user "ubuntu"
    sanitize_yaml_value "$file" jenkins_ansible_ssh_private_key_file "~/.ssh/change_me"
    sanitize_yaml_value "$file" sonarqube_ansible_host "192.0.2.11"
    sanitize_yaml_value "$file" sonarqube_ansible_user "ubuntu"
    sanitize_yaml_value "$file" sonarqube_ansible_ssh_private_key_file "~/.ssh/change_me"
    sanitize_yaml_value "$file" harbor_ansible_host "192.0.2.12"
    sanitize_yaml_value "$file" harbor_ansible_user "ubuntu"
    sanitize_yaml_value "$file" harbor_ansible_ssh_private_key_file "~/.ssh/change_me"
    sanitize_yaml_value "$file" vault_ansible_host "192.0.2.13"
    sanitize_yaml_value "$file" vault_ansible_user "ubuntu"
    sanitize_yaml_value "$file" vault_ansible_ssh_private_key_file "~/.ssh/change_me"
    sanitize_yaml_value "$file" tls_email "change_me@example.com"
    sanitize_yaml_value "$file" jenkins_domain "jenkins.example.com"
    sanitize_yaml_value "$file" sonarqube_domain "sonarqube.example.com"
    sanitize_yaml_value "$file" harbor_domain "harbor.example.com"
    sanitize_yaml_value "$file" vault_domain "vault.example.com"
    sanitize_yaml_value "$file" jenkins_tls_email "change_me@example.com"
    sanitize_yaml_value "$file" sonarqube_tls_email "change_me@example.com"
    sanitize_yaml_value "$file" harbor_tls_email "change_me@example.com"
    sanitize_yaml_value "$file" vault_tls_email "change_me@example.com"
    sanitize_yaml_value "$file" jenkins_admin_username "admin"
    sanitize_yaml_value "$file" jenkins_admin_password "change_me_jenkins_admin_password"
    sanitize_yaml_value "$file" sonarqube_admin_username "admin"
    sanitize_yaml_value "$file" sonarqube_admin_password "change_me_sonarqube_admin_password"
    sanitize_yaml_value "$file" harbor_admin_username "admin"
    sanitize_yaml_value "$file" harbor_admin_password "change_me_harbor_admin_password"
    sanitize_yaml_value "$file" harbor_database_password "change_me_harbor_database_password"
    sanitize_yaml_value "$file" vault_root_token "change_me_vault_root_token"
    sanitize_yaml_value "$file" sonarqube_db_password "change_me_password"
  done < <(collect_var_files "$worktree_dir")

  if [[ -f "$worktree_dir/inventory/inventory.ini" ]]; then
    sanitize_inventory_file "$worktree_dir/inventory/inventory.ini"
  fi

  echo "Creating sanitized commit..."
  git -C "$worktree_dir" add -A

  if git -C "$worktree_dir" diff --cached --quiet; then
    echo "Nothing to push."
    return 0
  fi

  git -C "$worktree_dir" commit -m "$commit_message" >/dev/null

  echo "Pushing to $remote/$target_branch..."
  git -C "$worktree_dir" push "$remote" "HEAD:$target_branch"

  echo "Done. Local files were not changed."
)

push_sanitized() {
  push_repo "$@"
}

if (return 0 2>/dev/null); then
  push_repo "$@"
else
  push_repo "$@"
fi
