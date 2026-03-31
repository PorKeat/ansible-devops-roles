# sonarqube role

Standalone Ansible role for SonarQube and PostgreSQL with Docker or Kubernetes support.

## Main idea

- install the whole repo as one collection or clone only this role
- edit [`defaults/main.yml`](/Users/alexkgm/ansible-role/roles/sonarqube/defaults/main.yml) inside the role if you want role-local config
- create one inventory
- call the role in one playbook
- run it

No global variables are required for the role itself.

## Main files

- [`defaults/main.yml`](/Users/alexkgm/ansible-role/roles/sonarqube/defaults/main.yml): all SonarQube role settings
- [`tasks/prerequisites.yml`](/Users/alexkgm/ansible-role/roles/sonarqube/tasks/prerequisites.yml): optional package install
- [`templates/`](/Users/alexkgm/ansible-role/roles/sonarqube/templates): Docker Compose, Nginx, and Kubernetes manifests

## Easiest way to use it

1. Install the role.
2. Open [`defaults/main.yml`](/Users/alexkgm/ansible-role/roles/sonarqube/defaults/main.yml).
3. Change the values you want:
   - `sonarqube_deploy_mode`
   - `sonarqube_domain`
   - `sonarqube_enable_tls`
   - `sonarqube_tls_email`
   - `sonarqube_manage_system_prereqs`
   - `sonarqube_db_password`
4. Create `inventory.ini`.
5. Create `site.yml`.
6. Run Ansible.

## Minimal `inventory.ini`

```ini
[devops]
server ansible_host=192.0.2.10 ansible_user=ubuntu
```

## Minimal `site.yml`

If you installed the role by itself from its own repo, use:

```yaml
---
- hosts: devops
  become: true
  roles:
    - sonarqube
```

If you installed the whole repo as a collection, use:

```yaml
---
- hosts: devops
  become: true
  roles:
    - cambostack.devops.sonarqube
```

## Install requirements

### Best way: install the collection once

```bash
ansible-galaxy collection install git+https://github.com/your-org/cambostack-devops-collection.git
```

Then use this role in your playbook:

```yaml
---
- hosts: devops
  become: true
  roles:
    - cambostack.devops.sonarqube
```

### Role-only install

If you still want to install just this role from its own repo:

```yaml
---
roles:
  - name: sonarqube
    src: https://github.com/your-org/ansible-role-sonarqube.git
    scm: git
    version: main
```

```bash
ansible-galaxy role install -r requirements.yml -p roles
```

Then use this role in your playbook:

```yaml
---
- hosts: devops
  become: true
  roles:
    - sonarqube
```

Collection install:

```yaml
---
collections:
  - name: community.docker
  - name: kubernetes.core
  - name: ansible.posix
```

```bash
ansible-galaxy collection install -r collections/requirements.yml
```

## One repo, many roles

If you want one repository for many roles, use the collection form of this repo:

- install the repo once as `cambostack.devops`
- use only `cambostack.devops.sonarqube` when you need SonarQube
- you do not need to install the other roles separately

## Run

```bash
ansible-playbook -i inventory.ini site.yml --syntax-check
ansible-playbook -i inventory.ini site.yml
```

## Notes

- Set `sonarqube_manage_system_prereqs: true` if the role should install Docker, Nginx, Certbot, or `kubectl` itself.
- If you prefer, you can still override values in playbook vars, `group_vars`, `host_vars`, or inventory.
- HTTPS works with `sonarqube_domain` when `sonarqube_enable_tls: true`.
- Change `sonarqube_db_password` before production use.

## Push this role to Git

Copy this role directory into its own repo root, then run:

```bash
git init
git add .
git commit -m "Initial SonarQube role"
git branch -M main
git remote add origin https://github.com/your-org/ansible-role-sonarqube.git
git push -u origin main
```
