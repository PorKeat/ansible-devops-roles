# Roles Guide

This `roles/` folder contains many reusable Ansible roles in one repository:

- `common`
- `jenkins`
- `sonarqube`

This guide explains:

- where to clone the repo
- where to put the roles
- how to prepare a project
- how to use `group_vars/all.yml`
- how to use one role or all roles
- when to edit role `defaults/main.yml`
- where to see the variable list

## Important naming note

Your Git repository name does not need to be `roles`.

Examples of valid repo names:

- `my-ansible-project`
- `devops-playbooks`
- `infra-automation`
- `ansible-role`

`roles/` is only the folder name used inside an Ansible project when you keep many roles together.

Example:

```text
my-ansible-project/
├── inventory.ini
├── site.yml
└── roles/
    ├── common/
    ├── jenkins/
    └── sonarqube/
```

You can also tell Ansible where to find the roles folder in `ansible.cfg`.

Example:

```ini
[defaults]
roles_path = ./roles
```

That means your repo name can still be anything, as long as Ansible knows the path to the roles.

Example:

```text
infra-automation/
├── ansible.cfg
├── inventory.ini
├── site.yml
└── roles/
    ├── common/
    ├── jenkins/
    └── sonarqube/
```

If you publish one role as its own Git repo, then do not keep the `roles/` wrapper.

Example single-role repo:

```text
ansible-role-jenkins/
├── README.md
├── defaults/
├── handlers/
├── meta/
├── tasks/
└── templates/
```

Variable list:

- [`VARIABLES.md`](/Users/alexkgm/ansible-role/roles/VARIABLES.md)

## Best practice

If you want one repository with many roles, the recommended approach is:

1. keep all roles in one main development repo
2. use one collection when you want to install the whole repo and choose roles in playbooks
3. use `group_vars/all.yml` in each project for project-specific values
4. keep role `defaults/main.yml` for safe reusable defaults
5. publish a role to its own repo only when you want to install that single role without downloading the others

### Recommended workflow

#### Best for development

- keep `common`, `jenkins`, and `sonarqube` together in one repo
- update and test them together
- keep shared patterns consistent

#### Best for normal usage

- install the repo as one collection
- call only the role you need in the playbook
- store environment-specific settings in `group_vars/all.yml`

#### Best for selective install

- if a user only wants `jenkins` or only `sonarqube`
- publish that role to its own repo
- install only that repo with `ansible-galaxy`

### Practical rule

Use:

- role `defaults/main.yml` for reusable default settings
- `group_vars/all.yml` for server, domain, TLS, passwords, namespaces, and other environment-specific values
- separate role repos only when you need single-role download and install

### Why this is best practice

- easier to maintain many roles in one place
- easier to reuse the same repo across projects
- safer than editing installed Ansible files after every install
- cleaner separation between reusable defaults and project-specific config

## First choose how you want to use the roles

There are 4 practical ways to use these roles.

### Option A. Clone this full repo and run it from root

Use this when:

- you want the ready-made project in this repo
- you want one inventory
- you want one `group_vars/all.yml`
- you may run all roles together

### Option B. Create your own Ansible project and copy this `roles/` folder into it

Use this when:

- you want your own project structure
- you want to keep the roles inside your own repo
- you want local editable roles

### Option C. Install this repo as one collection

Use this when:

- you want one Git repo with many roles
- you want to install once
- you want to choose only the role you need in the playbook

Important:

- collection install downloads the whole repo
- but your playbook can still use only one role

### Option D. Publish one role to its own repo

Use this when:

- you do not want all roles downloaded
- you want to install only `jenkins` or only `sonarqube`

## Folder structure

### Structure inside this repo

```text
roles/
├── README.md
├── common/
│   ├── defaults/
│   ├── handlers/
│   ├── meta/
│   ├── tasks/
│   └── README.md
├── jenkins/
│   ├── defaults/
│   ├── handlers/
│   ├── meta/
│   ├── tasks/
│   ├── templates/
│   └── README.md
└── sonarqube/
    ├── defaults/
    ├── handlers/
    ├── meta/
    ├── tasks/
    ├── templates/
    └── README.md
```

### Root project structure if you clone this repo

```text
ansible-role/
├── collections/
│   └── requirements.yml
├── group_vars/
│   └── all.yml
├── inventory.ini
├── roles/
│   ├── common/
│   ├── jenkins/
│   └── sonarqube/
└── site.yml
```

### Structure of your own project if you copy the roles into it

```text
my-ansible-project/
├── collections/
│   └── requirements.yml
├── group_vars/
│   └── all.yml
├── inventory.ini
├── roles/
│   ├── common/
│   ├── jenkins/
│   └── sonarqube/
└── site.yml
```

### Structure of a small project if you install the collection

```text
my-ansible-project/
├── collections/
│   └── requirements.yml
├── group_vars/
│   └── all.yml
├── inventory.ini
└── site.yml
```

The roles are not stored in your project folder in collection mode. Ansible installs them into its collection path.

## Where to clone the repo

You can clone this repo into any working directory you like.

Example:

```bash
mkdir -p ~/work
cd ~/work
git clone https://github.com/your-org/cambostack-devops-collection.git ansible-role
cd ansible-role
```

After cloning, you have two easy choices:

- run the repo directly from this folder
- copy `roles/` into another project

## Option A. Detailed steps to use this repo from root

This is the easiest way if you want to use the project exactly as it is.

### Step 1. Clone the repo

```bash
mkdir -p ~/work
cd ~/work
git clone https://github.com/your-org/cambostack-devops-collection.git ansible-role
cd ansible-role
```

### Step 2. Edit `inventory.ini`

File:

- `inventory.ini`

Example:

```ini
[devops]
server ansible_host=192.0.2.10 ansible_user=ubuntu
```

### Step 3. Edit `group_vars/all.yml`

File:

- `group_vars/all.yml`

This is the main config file when you use the root project.

Example:

```yaml
---
ansible_host: 192.0.2.10
ansible_user: ubuntu

global_deploy_mode: docker

enable_tls: true
tls_email: change_me@example.com

jenkins_domain: jenkins.cambostack.codes
sonarqube_domain: sonar.cambostack.codes

jenkins_image: jenkins/jenkins:lts
sonarqube_image: sonarqube:community
postgres_image: postgres:15
```

### Step 4. Install collections

```bash
ansible-galaxy collection install -r collections/requirements.yml
```

Or:

```bash
just init
```

### Step 5. Run the playbook

```bash
ansible-playbook -i inventory.ini site.yml --syntax-check
ansible-playbook -i inventory.ini site.yml
```

Or:

```bash
just syntax
just run
```

### Step 6. If you want only one role from root

Create another playbook.

Jenkins only:

```yaml
---
- hosts: devops
  become: true
  roles:
    - common
    - jenkins
```

SonarQube only:

```yaml
---
- hosts: devops
  become: true
  roles:
    - common
    - sonarqube
```

## Option B. Detailed steps to create your own project and copy the roles into it

Use this if you want your own repo but still want these roles editable inside your project.

### Step 1. Create your new project folder

```bash
mkdir -p ~/work/my-ansible-project
cd ~/work/my-ansible-project
```

### Step 2. Copy the roles folder into your project

Example:

```bash
cp -R ~/work/ansible-role/roles ./roles
```

Now your project structure should look like:

```text
my-ansible-project/
├── roles/
│   ├── common/
│   ├── jenkins/
│   └── sonarqube/
```

If you only want one role, copy only that role:

```bash
mkdir -p roles
cp -R ~/work/ansible-role/roles/jenkins ./roles/jenkins
```

### Step 3. Create `inventory.ini`

```ini
[devops]
server ansible_host=192.0.2.10 ansible_user=ubuntu
```

### Step 4. Create `site.yml`

Jenkins only:

```yaml
---
- hosts: devops
  become: true
  roles:
    - jenkins
```

SonarQube only:

```yaml
---
- hosts: devops
  become: true
  roles:
    - sonarqube
```

All roles:

```yaml
---
- hosts: devops
  become: true
  roles:
    - common
    - jenkins
    - sonarqube
```

### Step 5. Create `group_vars/all.yml` if you want project-level config

Create:

```text
group_vars/
└── all.yml
```

Example for Jenkins only:

```yaml
---
ansible_host: 192.0.2.10
ansible_user: ubuntu

jenkins_manage_system_prereqs: true
jenkins_deploy_mode: docker
jenkins_domain: jenkins.cambostack.codes
jenkins_enable_tls: true
jenkins_tls_email: change_me@example.com
```

Example for SonarQube only:

```yaml
---
ansible_host: 192.0.2.10
ansible_user: ubuntu

sonarqube_manage_system_prereqs: true
sonarqube_deploy_mode: docker
sonarqube_domain: sonar.cambostack.codes
sonarqube_enable_tls: true
sonarqube_tls_email: change_me@example.com
sonarqube_db_password: change_me_password
```

### Step 6. Install collections

Create `collections/requirements.yml`:

```yaml
---
collections:
  - name: community.docker
  - name: kubernetes.core
  - name: ansible.posix
```

Install:

```bash
ansible-galaxy collection install -r collections/requirements.yml
```

### Step 7. Run

```bash
ansible-playbook -i inventory.ini site.yml --syntax-check
ansible-playbook -i inventory.ini site.yml
```

## Option C. Detailed steps to use this repo as one collection

Use this if you want one repo with many roles and you are okay installing the whole repo one time.

### Step 1. Create a new project folder

```bash
mkdir -p ~/work/my-ansible-project
cd ~/work/my-ansible-project
```

### Step 2. Install the collection from Git

```bash
ansible-galaxy collection install git+https://github.com/your-org/cambostack-devops-collection.git
```

### Step 3. Create `inventory.ini`

```ini
[devops]
server ansible_host=192.0.2.10 ansible_user=ubuntu
```

### Step 4. Create `site.yml`

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

### Step 5. Create `group_vars/all.yml` if you want to override role defaults

This file is optional.

Example for Jenkins:

```yaml
---
jenkins_manage_system_prereqs: true
jenkins_deploy_mode: docker
jenkins_domain: jenkins.cambostack.codes
jenkins_enable_tls: true
jenkins_tls_email: change_me@example.com
```

Example for SonarQube:

```yaml
---
sonarqube_manage_system_prereqs: true
sonarqube_deploy_mode: docker
sonarqube_domain: sonar.cambostack.codes
sonarqube_enable_tls: true
sonarqube_tls_email: change_me@example.com
sonarqube_db_password: change_me_password
```

### Step 6. Install dependency collections if needed

Create `collections/requirements.yml`:

```yaml
---
collections:
  - name: community.docker
  - name: kubernetes.core
  - name: ansible.posix
```

Install:

```bash
ansible-galaxy collection install -r collections/requirements.yml
```

### Step 7. Run

```bash
ansible-playbook -i inventory.ini site.yml --syntax-check
ansible-playbook -i inventory.ini site.yml
```

## How `group_vars/all.yml` works

`group_vars/all.yml` is a project-level variable file.

Use it when:

- you do not want to edit role files
- you want clean project-specific config
- you may reinstall roles later and do not want your changes overwritten

Typical location:

```text
my-ansible-project/
├── group_vars/
│   └── all.yml
```

Example:

```yaml
---
ansible_host: 192.0.2.10
ansible_user: ubuntu

jenkins_manage_system_prereqs: true
jenkins_deploy_mode: docker
jenkins_domain: jenkins.cambostack.codes
jenkins_enable_tls: true
jenkins_tls_email: change_me@example.com

sonarqube_manage_system_prereqs: true
sonarqube_deploy_mode: docker
sonarqube_domain: sonar.cambostack.codes
sonarqube_enable_tls: true
sonarqube_tls_email: change_me@example.com
sonarqube_db_password: change_me_password
```

## When to edit `defaults/main.yml` inside a role

Edit the role `defaults/main.yml` when:

- you cloned the repo locally
- you copied the role into your own project
- you want the default config stored inside the role itself

Files:

- `roles/jenkins/defaults/main.yml`
- `roles/sonarqube/defaults/main.yml`

This is good for:

- your own private repo
- a template role you always reuse with the same defaults

## When not to edit installed role files

If you install a role or collection with `ansible-galaxy`, editing the installed files is usually not the best practice because:

- reinstalling can overwrite your changes
- updates become harder

In that case, prefer:

- `group_vars/all.yml`
- playbook `vars`
- inventory vars

## If you do not want all roles downloaded

If many roles are in one Git repo:

- collection install downloads the whole repo
- but you can still run only one role

If you want to install only one role and not the others:

1. publish that role to its own Git repo
2. install only that role

Example:

```yaml
---
roles:
  - name: jenkins
    src: https://github.com/your-org/ansible-role-jenkins.git
    scm: git
    version: main
```

## Role-specific docs

- [`common/README.md`](/Users/alexkgm/ansible-role/roles/common/README.md)
- [`jenkins/README.md`](/Users/alexkgm/ansible-role/roles/jenkins/README.md)
- [`sonarqube/README.md`](/Users/alexkgm/ansible-role/roles/sonarqube/README.md)
