# jenkins role

Standalone Ansible role for Jenkins with Docker or Kubernetes support.

## Main idea

- install the whole repo as one collection or clone only this role
- edit [`defaults/main.yml`](/Users/alexkgm/ansible-role/roles/jenkins/defaults/main.yml) inside the role if you want role-local config
- create one inventory
- call the role in one playbook
- run it

No global variables are required for the role itself.

## Main files

- [`defaults/main.yml`](/Users/alexkgm/ansible-role/roles/jenkins/defaults/main.yml): all Jenkins role settings
- [`tasks/prerequisites.yml`](/Users/alexkgm/ansible-role/roles/jenkins/tasks/prerequisites.yml): optional package install
- [`templates/`](/Users/alexkgm/ansible-role/roles/jenkins/templates): Docker Compose, Nginx, and Kubernetes manifests

## Easiest way to use it

1. Install the role.
2. Open [`defaults/main.yml`](/Users/alexkgm/ansible-role/roles/jenkins/defaults/main.yml).
3. Change the values you want:
   - `jenkins_deploy_mode`
   - `jenkins_domain`
   - `jenkins_enable_tls`
   - `jenkins_tls_email`
   - `jenkins_manage_system_prereqs`
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
    - jenkins
```

If you installed the whole repo as a collection, use:

```yaml
---
- hosts: devops
  become: true
  roles:
    - cambostack.devops.jenkins
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
    - cambostack.devops.jenkins
```

### Role-only install

If you still want to install just this role from its own repo:

```yaml
---
roles:
  - name: jenkins
    src: https://github.com/your-org/ansible-role-jenkins.git
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
    - jenkins
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
- use only `cambostack.devops.jenkins` when you need Jenkins
- you do not need to install the other roles separately

## Run

```bash
ansible-playbook -i inventory.ini site.yml --syntax-check
ansible-playbook -i inventory.ini site.yml
```

## Notes

- Set `jenkins_manage_system_prereqs: true` if the role should install Docker, Nginx, Certbot, or `kubectl` itself.
- If you prefer, you can still override values in playbook vars, `group_vars`, `host_vars`, or inventory.
- HTTPS works with `jenkins_domain` when `jenkins_enable_tls: true`.

## Push this role to Git

Copy this role directory into its own repo root, then run:

```bash
git init
git add .
git commit -m "Initial Jenkins role"
git branch -M main
git remote add origin https://github.com/your-org/ansible-role-jenkins.git
git push -u origin main
```
