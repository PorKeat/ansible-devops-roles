# Role Variables

Use variables in one of these 3 places:

- `group_vars/all.yml`
- playbook `vars`
- role `defaults/main.yml`

## 1. Example in `group_vars/all.yml`

```yaml
---
install_docker: true
install_nginx: true
install_certbot: true
install_kubectl: true

jenkins_manage_system_prereqs: true
jenkins_deploy_mode: docker
jenkins_domain: jenkins.cambostack.codes
jenkins_enable_tls: true
jenkins_tls_email: alexkgm2412@gmail.com

sonarqube_manage_system_prereqs: true
sonarqube_deploy_mode: docker
sonarqube_domain: sonar.cambostack.codes
sonarqube_enable_tls: true
sonarqube_tls_email: alexkgm2412@gmail.com
sonarqube_db_password: change_this_password
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
        jenkins_tls_email: alexkgm2412@gmail.com
```

## 3. Example in role `defaults/main.yml`

Edit:

- `roles/common/defaults/main.yml`
- `roles/jenkins/defaults/main.yml`
- `roles/sonarqube/defaults/main.yml`

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

- `roles/common/defaults/main.yml`

Main variables:

- `install_docker`: install Docker packages and service. Example: `true`
- `install_nginx`: install Nginx. Example: `true`
- `install_certbot`: install Certbot packages. Example: `true`
- `install_kubectl`: install `kubectl` and Python Kubernetes packages. Example: `true`

Advanced variables:

- `common_base_packages`: base Ubuntu packages. Example: `['curl', 'git', 'python3']`
- `common_sysctl_settings`: shared sysctl settings. Example: `[{ name: vm.max_map_count, value: '262144' }]`
- `docker_packages`: Docker package list. Example: `['docker.io', 'docker-compose-plugin']`
- `nginx_packages`: Nginx package list. Example: `['nginx']`
- `certbot_packages`: Certbot package list. Example: `['certbot', 'python3-certbot-nginx']`
- `kubectl_apt_key_url`: Kubernetes apt signing key URL. Example: `https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key`
- `kubectl_apt_repo`: Kubernetes apt repo. Example: `deb https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /`
- `kubectl_packages`: kubectl package list. Example: `['kubectl', 'python3-kubernetes']`

## `jenkins`

Main file:

- `roles/jenkins/defaults/main.yml`

Main variables:

- `jenkins_deploy_mode`: deployment mode. Example: `docker` or `k8s`
- `jenkins_manage_system_prereqs`: let the role install its own packages. Example: `true`
- `jenkins_domain`: manual domain for Nginx or Ingress. Example: `jenkins.cambostack.codes`
- `jenkins_enable_tls`: enable HTTPS. Example: `true`
- `jenkins_tls_email`: email for Certbot. Example: `alexkgm2412@gmail.com`
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
- `jenkins_compose_file`: Docker Compose file path. Example: `/opt/jenkins/docker-compose.yml`
- `jenkins_container_name`: Jenkins container name. Example: `jenkins`
- `jenkins_data_dir`: Jenkins data path. Example: `/opt/jenkins/jenkins_home`
- `jenkins_java_opts`: extra JVM options. Example: `-Xms512m -Xmx1024m`
- `jenkins_nginx_site_filename`: Nginx site filename. Example: `jenkins.conf`
- `jenkins_nginx_site_path`: Nginx site path. Example: `/etc/nginx/sites-available/jenkins.conf`
- `jenkins_nginx_site_enabled_path`: enabled site symlink path. Example: `/etc/nginx/sites-enabled/jenkins.conf`

Kubernetes mode variables:

- `jenkins_kubeconfig_path`: kubeconfig path. Example: `/home/ubuntu/.kube/config`
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

- `roles/sonarqube/defaults/main.yml`

Main variables:

- `sonarqube_deploy_mode`: deployment mode. Example: `docker` or `k8s`
- `sonarqube_manage_system_prereqs`: let the role install its own packages. Example: `true`
- `sonarqube_domain`: manual domain for Nginx or Ingress. Example: `sonar.cambostack.codes`
- `sonarqube_enable_tls`: enable HTTPS. Example: `true`
- `sonarqube_tls_email`: email for Certbot. Example: `alexkgm2412@gmail.com`
- `sonarqube_install_dir`: install path in Docker mode. Example: `/opt/sonarqube`
- `sonarqube_http_port`: SonarQube web port. Example: `9000`
- `postgres_port`: PostgreSQL port. Example: `5432`
- `sonarqube_image`: SonarQube image. Example: `sonarqube:community`
- `postgres_image`: PostgreSQL image. Example: `postgres:15`
- `sonarqube_db_name`: PostgreSQL database name. Example: `sonarqube`
- `sonarqube_db_user`: PostgreSQL user. Example: `sonarqube`
- `sonarqube_db_password`: PostgreSQL password. Example: `change_this_password`
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
- `sonarqube_compose_file`: Docker Compose file path. Example: `/opt/sonarqube/docker-compose.yml`
- `sonarqube_container_name`: SonarQube container name. Example: `sonarqube`
- `postgres_container_name`: PostgreSQL container name. Example: `sonarqube-postgresql`
- `sonarqube_nginx_site_filename`: Nginx site filename. Example: `sonarqube.conf`
- `sonarqube_nginx_site_path`: Nginx site path. Example: `/etc/nginx/sites-available/sonarqube.conf`
- `sonarqube_nginx_site_enabled_path`: enabled site symlink path. Example: `/etc/nginx/sites-enabled/sonarqube.conf`

Kubernetes mode variables:

- `sonarqube_kubeconfig_path`: kubeconfig path. Example: `/home/ubuntu/.kube/config`
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
