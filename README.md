# DevOps Ansible Roles

One Git repository with many reusable Ansible roles:

- `common`
- `jenkins`
- `sonarqube`

This repo supports:

- local project usage from this root
- collection-style usage from one Git repo
- running all roles or only the role you want

The repo does not create DNS records and does not use any DNS provider API. Domain names are always set manually by you.

## What this repo is for

Use this repo if you want:

- one place to keep many DevOps roles
- one repo to install and reuse
- the choice to run only `jenkins`, only `sonarqube`, or all roles together

## Roles in this repo

- [`roles/common`](/Users/alexkgm/ansible-role/roles/common)
- [`roles/jenkins`](/Users/alexkgm/ansible-role/roles/jenkins)
- [`roles/sonarqube`](/Users/alexkgm/ansible-role/roles/sonarqube)

Role docs:

- [`roles/common/README.md`](/Users/alexkgm/ansible-role/roles/common/README.md)
- [`roles/jenkins/README.md`](/Users/alexkgm/ansible-role/roles/jenkins/README.md)
- [`roles/sonarqube/README.md`](/Users/alexkgm/ansible-role/roles/sonarqube/README.md)

## Best practice for one repo with many roles

If you keep many roles in one Git repo, the best practice is to package the repo as one Ansible Collection.

This repo already includes [`galaxy.yml`](/Users/alexkgm/ansible-role/galaxy.yml), so you can use it like this:

- install the repo once
- call only the role you want in the playbook

Example collection roles:

- `cambostack.devops.common`
- `cambostack.devops.jenkins`
- `cambostack.devops.sonarqube`

Important:

- collection install gets the whole repo
- but your playbook can still use only one role
- if you truly want to download only one role, use a separate repo for that role

## How to use this root repo

You have 2 normal ways to use it.

### Option 1. Use this repo locally from root

This is best when you clone the repo and want the full project structure already prepared.

Files already included:

- [`config.yml`](/Users/alexkgm/ansible-role/config.yml)
- [`inventory.ini`](/Users/alexkgm/ansible-role/inventory.ini)
- [`site.yml`](/Users/alexkgm/ansible-role/site.yml)
- [`group_vars/all.yml`](/Users/alexkgm/ansible-role/group_vars/all.yml)
- [`collections/requirements.yml`](/Users/alexkgm/ansible-role/collections/requirements.yml)
- [`Justfile`](/Users/alexkgm/ansible-role/Justfile)

Steps:

1. Edit [`config.yml`](/Users/alexkgm/ansible-role/config.yml).
2. Leave [`inventory.ini`](/Users/alexkgm/ansible-role/inventory.ini) as-is unless you want to change the host name.
3. Install collections.
4. Run the playbook.

Install:

```bash
ansible-galaxy collection install -r collections/requirements.yml
```

Or:

```bash
just init
```

Run:

```bash
ansible-playbook -i inventory.ini site.yml --syntax-check
ansible-playbook -i inventory.ini site.yml
```

Or:

```bash
just syntax
just run
```

### Option 2. Install this repo as one collection

This is best when you want one Git repo for many roles and want to choose roles in the playbook.

Install:

```bash
ansible-galaxy collection install git+https://github.com/your-org/cambostack-devops-collection.git
```

Then use only the role you want.

Jenkins only:

```yaml
---
- hosts: devops
  become: true
  roles:
    - cambostack.devops.jenkins
```

SonarQube only:

```yaml
---
- hosts: devops
  become: true
  roles:
    - cambostack.devops.sonarqube
```

All roles:

```yaml
---
- hosts: devops
  become: true
  roles:
    - cambostack.devops.common
    - cambostack.devops.jenkins
    - cambostack.devops.sonarqube
```

## Where to change settings

### If you use this root project

Change values in:

- [`config.yml`](/Users/alexkgm/ansible-role/config.yml)

This is the main root-level configuration file.
[`group_vars/all.yml`](/Users/alexkgm/ansible-role/group_vars/all.yml) is only the internal mapping file.

### If you use one role by itself

You can change values in:

- the role's `defaults/main.yml`
- playbook `vars`
- inventory vars
- `group_vars`
- `host_vars`

For role-local settings:

- [`roles/jenkins/defaults/main.yml`](/Users/alexkgm/ansible-role/roles/jenkins/defaults/main.yml)
- [`roles/sonarqube/defaults/main.yml`](/Users/alexkgm/ansible-role/roles/sonarqube/defaults/main.yml)

## Root project examples

### Run all roles from this root

[`site.yml`](/Users/alexkgm/ansible-role/site.yml) already does this:

```yaml
---
- name: Deploy Jenkins and SonarQube
  hosts: devops
  become: true
  vars_files:
    - config.yml
  roles:
    - common
    - jenkins
    - sonarqube
```

### Run only Jenkins from this root

Use a playbook like:

```yaml
---
- hosts: devops
  become: true
  roles:
    - common
    - jenkins
```

### Run only SonarQube from this root

Use a playbook like:

```yaml
---
- hosts: devops
  become: true
  roles:
    - common
    - sonarqube
```

## Main root variables

The root project uses these important variables in [`config.yml`](/Users/alexkgm/ansible-role/config.yml):

- `ansible_host`
- `ansible_user`
- `global_deploy_mode`
- `enable_tls`
- `tls_email`
- `jenkins_domain`
- `sonarqube_domain`
- optional Jenkins overrides such as `jenkins_namespace`, `jenkins_storage_size`, and `jenkins_image`
- optional SonarQube overrides such as `sonarqube_namespace`, `sonarqube_storage_size`, `postgres_storage_size`, `sonarqube_image`, and `postgres_image`

This repo is set up so you can change everything in one place: [`config.yml`](/Users/alexkgm/ansible-role/config.yml). The shared values there are mapped into the roles automatically by [`group_vars/all.yml`](/Users/alexkgm/ansible-role/group_vars/all.yml).

## Manual domains and HTTPS

Set domains manually, for example:

```yaml
jenkins_domain: jenkins.cambostack.codes
sonarqube_domain: sonar.cambostack.codes
```

These domains are used only in:

- Nginx configs
- Certbot commands
- Kubernetes Ingress manifests

HTTPS support:

- Docker mode: Nginx + Certbot
- Kubernetes mode: Ingress TLS block

You must configure DNS outside Ansible.

## When to use root project vs one role

Use the root project when:

- you want everything ready now
- you want one inventory and one main config file
- you want to deploy Jenkins and SonarQube together

Use one role when:

- you only need Jenkins
- you only need SonarQube
- you want the role in another project

## If you do not want all roles downloaded

If many roles live in one Git repo:

- collection install will install the whole repo
- you can still run only one role

If you do not want to download all roles:

- publish that role to its own Git repo
- install only that role

Example:

```yaml
---
roles:
  - name: jenkins
    src: https://github.com/your-org/ansible-role-jenkins.git
    scm: git
    version: main
```

## Useful commands

Collections:

```bash
ansible-galaxy collection install -r collections/requirements.yml
```

Syntax check:

```bash
ansible-playbook -i inventory.ini site.yml --syntax-check
```

Run:

```bash
ansible-playbook -i inventory.ini site.yml
```

Just:

```bash
just init
just syntax
just run
just docker
just k8s
```

## Folder structure

```text
.
├── Justfile
├── README.md
├── galaxy.yml
├── collections/
├── group_vars/
├── inventory.ini
├── roles/
│   ├── common/
│   ├── jenkins/
│   └── sonarqube/
└── site.yml
```
