# Role Variables

Use variables in one of these 3 places:

- `group_vars/all.yaml`
- playbook `vars`
- role `defaults/main.yaml`

For this repo's root-project workflow, edit `config.yaml`.
`group_vars/all.yaml` is used only for shared internal mapping.

## 1. Example in `group_vars/all.yaml`

```yaml
---
ansible_host: 192.0.2.10
ansible_user: ubuntu

install_docker: true
install_nginx: true
install_certbot: true
install_kubectl: true

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

harbor_domain: harbor.cambostack.codes
harbor_enable_tls: false
vault_domain: vault.cambostack.codes
vault_enable_tls: false
minio_api_domain: minio-api.cambostack.codes
minio_console_domain: minio-console.cambostack.codes
minio_root_password: change_me_minio_password
```

## 2. Example in playbook `vars`

```yaml
---
- hosts: devops
  become: true
  roles:
    - role: jenkins
      vars:
        jenkins_manage_system_prereqs: true
        jenkins_deploy_mode: docker
        jenkins_domain: jenkins.cambostack.codes
        jenkins_enable_tls: true
        jenkins_tls_email: change_me@example.com
```

## 3. Example in role `defaults/main.yaml`

Edit:

- `roles/common/defaults/main.yaml`
- `roles/harbor/defaults/main.yaml`
- `roles/jenkins/defaults/main.yaml`
- `roles/minio/defaults/main.yaml`
- `roles/sonarqube/defaults/main.yaml`
- `roles/vault/defaults/main.yaml`

Example:

```yaml
---
jenkins_deploy_mode: docker
jenkins_domain: jenkins.cambostack.codes
jenkins_enable_tls: false
jenkins_install_dir: /opt/jenkins
```

## `common`

Main file:

- `roles/common/defaults/main.yaml`

Main variables:

- `install_docker`: install Docker packages and service. Example: `true`
- `install_nginx`: install Nginx. Example: `true`
- `install_certbot`: install Certbot packages. Example: `true`
- `install_kubectl`: install `kubectl` and Python Kubernetes packages. Example: `true`

Advanced variables:

- `common_base_packages`: base Ubuntu packages. Example: `['curl', 'git', 'python3']`
- `common_sysctl_settings`: shared sysctl settings. Example: `[{ name: vm.max_map_count, value: '262144' }]`
- `docker_packages`: Docker package list. Example: `['docker-ce', 'docker-ce-cli', 'containerd.io']`
- `docker_conflicting_packages`: old packages removed before installing Docker Engine. Example: `['docker.io', 'containerd', 'runc']`
- `docker_remove_conflicting_packages`: remove old Docker packages first. Example: `true`
- `docker_apt_key_url`: Docker apt GPG key URL. Example: `https://download.docker.com/linux/ubuntu/gpg`
- `docker_apt_repo`: Docker apt repository. Example: `deb [signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu jammy stable`
- `nginx_packages`: Nginx package list. Example: `['nginx']`
- `certbot_packages`: Certbot package list. Example: `['certbot', 'python3-certbot-nginx']`
- `kubectl_apt_key_url`: Kubernetes apt signing key URL. Example: `https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key`
- `kubectl_apt_repo`: Kubernetes apt repo. Example: `deb https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /`
- `kubectl_packages`: kubectl apt package list. Example: `['kubectl']`
- `kubectl_python_packages`: Python packages for `kubernetes.core`. Example: `['kubernetes>=24.2.0', 'PyYAML>=3.11']`

## `jenkins`

Main file:

- `roles/jenkins/defaults/main.yaml`

Main variables:

- `jenkins_deploy_mode`: deployment mode. Example: `docker` or `k8s`
- `jenkins_manage_system_prereqs`: let the role install its own packages. Example: `true`
- `jenkins_domain`: manual domain for Nginx or Ingress. Example: `jenkins.cambostack.codes`
- `jenkins_enable_tls`: enable HTTPS. Example: `true`
- `jenkins_tls_email`: email for Certbot. Example: `change_me@example.com`
- `jenkins_install_dir`: install path in Docker mode. Example: `/opt/jenkins`
- `jenkins_image`: Jenkins image. Example: `jenkins/jenkins:lts`
- `jenkins_http_port`: Jenkins web port. Example: `8080`
- `jenkins_agent_port`: Jenkins agent port. Example: `50000`
- `jenkins_namespace`: Kubernetes namespace. Example: `jenkins`
- `jenkins_storage_size`: Jenkins PVC size. Example: `10Gi`

System prep variables:

- `jenkins_manage_base_packages`: install base packages from this role. Example: `true`
- `jenkins_install_docker`: install Docker from this role. Example: `true`
- `jenkins_install_nginx`: install Nginx from this role. Example: `true`
- `jenkins_install_certbot`: install Certbot from this role. Example: `true`
- `jenkins_install_kubectl`: install kubectl from this role. Example: `true`
- `jenkins_system_user`: user added to docker group. Example: `ubuntu`

Docker mode variables:

- `jenkins_compose_project_name`: Docker Compose project name. Example: `jenkins`
- `jenkins_compose_file`: Docker Compose file path. Example: `/opt/jenkins/docker-compose.yaml`
- `jenkins_container_name`: Jenkins container name. Example: `jenkins`
- `jenkins_data_dir`: Jenkins data path. Example: `/opt/jenkins/jenkins_home`
- `jenkins_java_opts`: extra JVM options. Example: `-Xms512m -Xmx1024m`
- `jenkins_nginx_site_filename`: Nginx site filename. Example: `jenkins.conf`
- `jenkins_nginx_site_path`: Nginx site path. Example: `/etc/nginx/sites-available/jenkins.conf`
- `jenkins_nginx_site_enabled_path`: enabled site symlink path. Example: `/etc/nginx/sites-enabled/jenkins.conf`

Kubernetes mode variables:

- `jenkins_kubeconfig_path`: kubeconfig path. Example: `/home/{{ ansible_user }}/.kube/config`
- `jenkins_replicas`: Deployment replicas. Example: `1`
- `jenkins_service_name`: Service name. Example: `jenkins`
- `jenkins_service_type`: Service type. Example: `ClusterIP`
- `jenkins_use_pvc`: create PVC or not. Example: `true`
- `jenkins_pvc_name`: PVC name. Example: `jenkins-home`
- `jenkins_persistence_access_modes`: PVC access mode list. Example: `['ReadWriteOnce']`
- `jenkins_storage_class_name`: storage class name. Example: `""` or `local-path`
- `jenkins_ingress_name`: Ingress name. Example: `jenkins`
- `jenkins_ingress_class_name`: ingress class name. Example: `nginx`
- `jenkins_ingress_path`: ingress path. Example: `/`
- `jenkins_ingress_path_type`: ingress path type. Example: `Prefix`
- `jenkins_ingress_annotations`: ingress annotations map. Example: `{}`
- `jenkins_ingress_tls_secret_name`: TLS secret name. Example: `jenkins-tls`
- `jenkins_k8s_validate_certs`: validate Kubernetes API certs. Example: `true`

## `sonarqube`

Main file:

- `roles/sonarqube/defaults/main.yaml`

Main variables:

- `sonarqube_deploy_mode`: deployment mode. Example: `docker` or `k8s`
- `sonarqube_manage_system_prereqs`: let the role install its own packages. Example: `true`
- `sonarqube_domain`: manual domain for Nginx or Ingress. Example: `sonar.cambostack.codes`
- `sonarqube_enable_tls`: enable HTTPS. Example: `true`
- `sonarqube_tls_email`: email for Certbot. Example: `change_me@example.com`
- `sonarqube_install_dir`: install path in Docker mode. Example: `/opt/sonarqube`
- `sonarqube_http_port`: SonarQube web port. Example: `9000`
- `postgres_port`: PostgreSQL port. Example: `5432`
- `sonarqube_image`: SonarQube image. Example: `sonarqube:community`
- `postgres_image`: PostgreSQL image. Example: `postgres:15`
- `sonarqube_db_name`: PostgreSQL database name. Example: `sonarqube`
- `sonarqube_db_user`: PostgreSQL user. Example: `sonarqube`
- `sonarqube_db_password`: PostgreSQL password. Example: `change_me_password`
- `sonarqube_namespace`: Kubernetes namespace. Example: `sonarqube`
- `sonarqube_storage_size`: SonarQube PVC size. Example: `10Gi`
- `postgres_storage_size`: PostgreSQL PVC size. Example: `8Gi`

System prep variables:

- `sonarqube_manage_base_packages`: install base packages from this role. Example: `true`
- `sonarqube_install_docker`: install Docker from this role. Example: `true`
- `sonarqube_install_nginx`: install Nginx from this role. Example: `true`
- `sonarqube_install_certbot`: install Certbot from this role. Example: `true`
- `sonarqube_install_kubectl`: install kubectl from this role. Example: `true`
- `sonarqube_system_user`: user added to docker group. Example: `ubuntu`

Docker mode variables:

- `sonarqube_compose_project_name`: Docker Compose project name. Example: `sonarqube`
- `sonarqube_compose_file`: Docker Compose file path. Example: `/opt/sonarqube/docker-compose.yaml`
- `sonarqube_container_name`: SonarQube container name. Example: `sonarqube`
- `postgres_container_name`: PostgreSQL container name. Example: `sonarqube-postgresql`
- `sonarqube_nginx_site_filename`: Nginx site filename. Example: `sonarqube.conf`
- `sonarqube_nginx_site_path`: Nginx site path. Example: `/etc/nginx/sites-available/sonarqube.conf`
- `sonarqube_nginx_site_enabled_path`: enabled site symlink path. Example: `/etc/nginx/sites-enabled/sonarqube.conf`

Kubernetes mode variables:

- `sonarqube_kubeconfig_path`: kubeconfig path. Example: `/home/{{ ansible_user }}/.kube/config`
- `sonarqube_service_name`: SonarQube service name. Example: `sonarqube`
- `postgres_service_name`: PostgreSQL service name. Example: `postgresql`
- `sonarqube_use_pvc`: create SonarQube PVC or not. Example: `true`
- `postgres_use_pvc`: create PostgreSQL PVC or not. Example: `true`
- `sonarqube_pvc_name`: SonarQube PVC name. Example: `sonarqube-data`
- `postgres_pvc_name`: PostgreSQL PVC name. Example: `sonarqube-postgresql`
- `sonarqube_persistence_access_modes`: SonarQube PVC access mode list. Example: `['ReadWriteOnce']`
- `postgres_persistence_access_modes`: PostgreSQL PVC access mode list. Example: `['ReadWriteOnce']`
- `sonarqube_storage_class_name`: SonarQube storage class. Example: `""` or `local-path`
- `postgres_storage_class_name`: PostgreSQL storage class. Example: `""` or `local-path`
- `sonarqube_ingress_name`: Ingress name. Example: `sonarqube`
- `sonarqube_ingress_class_name`: ingress class name. Example: `nginx`
- `sonarqube_ingress_path`: ingress path. Example: `/`
- `sonarqube_ingress_path_type`: ingress path type. Example: `Prefix`
- `sonarqube_ingress_annotations`: ingress annotations map. Example: `{}`
- `sonarqube_ingress_tls_secret_name`: TLS secret name. Example: `sonarqube-tls`
- `sonarqube_replicas`: SonarQube replicas. Example: `1`
- `postgres_replicas`: PostgreSQL replicas. Example: `1`
- `sonarqube_k8s_validate_certs`: validate Kubernetes API certs. Example: `true`

## `harbor`

Main file:

- `roles/harbor/defaults/main.yaml`

Main variables:

- `harbor_state`: deployment state. Example: `present` or `absent`
- `harbor_deploy_mode`: deployment mode. Example: `docker`
- `harbor_domain`: manual domain when `use_domain` is enabled. Example: `harbor.cambostack.codes`
- `harbor_enable_tls`: enable HTTPS with existing certificate files. Example: `true`
- `harbor_install_dir`: install path. Example: `/opt/harbor`
- `harbor_version`: Harbor version. Example: `2.14.1`
- `harbor_http_port`: Harbor HTTP port. Example: `8081`
- `harbor_https_port`: Harbor HTTPS port. Example: `8443`
- `harbor_admin_password`: Harbor initial admin password. Example: `Harbor12345`

Docker mode variables:

- `harbor_data_dir`: Harbor data path. Example: `/opt/harbor/data`
- `harbor_log_dir`: Harbor log path. Example: `/opt/harbor/log`
- `harbor_installer_url`: Harbor online installer archive URL
- `harbor_installer_archive`: downloaded archive path
- `harbor_compose_file`: generated Docker Compose file path
- `harbor_port_wait_timeout`: port wait timeout after install. Example: `30`
- `harbor_cleanup_remove_data`: remove Harbor install directory on cleanup. Example: `true`
- `harbor_cleanup_remove_docker_volumes`: remove Harbor Docker volumes on cleanup. Example: `true`

## `vault`

Main file:

- `roles/vault/defaults/main.yaml`

Main variables:

- `vault_state`: deployment state. Example: `present` or `absent`
- `vault_deploy_mode`: deployment mode. Example: `docker`
- `vault_mode`: runtime mode. Example: `testing` or `production`
- `vault_domain`: manual domain when `use_domain` is enabled. Example: `vault.cambostack.codes`
- `vault_enable_tls`: enable HTTPS with existing certificate files. Example: `true`
- `vault_install_dir`: install path. Example: `/opt/vault`
- `vault_version`: Vault version. Example: `1.21.4`
- `vault_http_port`: Vault public port. Example: `8200`
- `vault_cluster_port`: Vault cluster port. Example: `8201`
- `vault_root_token`: root token for testing mode. Example: `change_me_vault_root_token`

Docker mode variables:

- `vault_image`: Vault image tag. Example: `hashicorp/vault:1.21.4`
- `vault_compose_file`: Docker Compose file path. Example: `/opt/vault/docker-compose.yaml`
- `vault_config_file`: Vault config path for production mode. Example: `/opt/vault/config/vault.hcl`
- `vault_data_dir`: Vault raft data path. Example: `/opt/vault/data`
- `vault_tls_certificate_path`: Vault TLS certificate path
- `vault_tls_private_key_path`: Vault TLS private key path
- `vault_port_wait_timeout`: port wait timeout after install. Example: `20`
- `vault_cleanup_remove_data`: remove Vault install directory on cleanup. Example: `true`
- `vault_cleanup_remove_docker_volumes`: remove Vault Docker volumes on cleanup. Example: `true`

## `minio`

Main file:

- `roles/minio/defaults/main.yaml`

Main variables:

- `minio_state`: deployment state. Example: `present` or `absent`
- `minio_deploy_mode`: deployment mode. Example: `docker` or `k8s`
- `minio_api_domain`: API host name when `use_domain` is enabled. Example: `minio-api.cambostack.codes`
- `minio_console_domain`: console host name when `use_domain` is enabled. Example: `minio-console.cambostack.codes`
- `minio_install_dir`: install path in Docker mode. Example: `/opt/minio`
- `minio_image`: MinIO image. Example: `minio/minio:latest`
- `minio_api_port`: MinIO S3 API port. Example: `9000`
- `minio_console_port`: MinIO console port. Example: `9001`
- `minio_root_user`: MinIO root username. Example: `minioadmin`
- `minio_root_password`: MinIO root password. Example: `change_me_minio_password`
- `minio_namespace`: Kubernetes namespace. Example: `minio`
- `minio_storage_size`: MinIO PVC size. Example: `20Gi`

Docker mode variables:

- `minio_compose_project_name`: Docker Compose project name. Example: `minio`
- `minio_compose_file`: Docker Compose file path. Example: `/opt/minio/docker-compose.yaml`
- `minio_container_name`: MinIO container name. Example: `minio`
- `minio_data_dir`: MinIO data path. Example: `/opt/minio/data`
- `minio_port_wait_timeout`: port wait timeout after start. Example: `30`
- `minio_cleanup_remove_data`: remove MinIO install directory on cleanup. Example: `true`
- `minio_cleanup_remove_docker_volumes`: remove MinIO Docker volumes on cleanup. Example: `true`

Kubernetes mode variables:

- `minio_kubeconfig_path`: kubeconfig path. Example: `/home/{{ ansible_user }}/.kube/config`
- `minio_service_name`: Service name. Example: `minio`
- `minio_use_pvc`: create PVC or not. Example: `true`
- `minio_pvc_name`: PVC name. Example: `minio-data`
- `minio_persistence_access_modes`: PVC access mode list. Example: `['ReadWriteOnce']`
- `minio_storage_class_name`: storage class name. Example: `""` or `local-path`
- `minio_k8s_api_node_port`: Kubernetes NodePort for the S3 API. Example: `30910`
- `minio_k8s_console_node_port`: Kubernetes NodePort for the web console. Example: `30911`
- `minio_replicas`: Deployment replicas. Example: `1`
- `minio_k8s_validate_certs`: validate Kubernetes API certs. Example: `true`
