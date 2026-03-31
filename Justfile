export ANSIBLE_LOCAL_TEMP := "/tmp/.ansible/tmp"

default:
    @just --list

init:
    mkdir -p "$ANSIBLE_LOCAL_TEMP"
    ansible-galaxy collection install -r collections/requirements.yml

syntax:
    mkdir -p "$ANSIBLE_LOCAL_TEMP"
    ansible-playbook -i inventory.ini site.yml --syntax-check

run:
    mkdir -p "$ANSIBLE_LOCAL_TEMP"
    ansible-playbook -i inventory.ini site.yml

docker:
    mkdir -p "$ANSIBLE_LOCAL_TEMP"
    ansible-playbook -i inventory.ini site.yml -e global_deploy_mode=docker

k8s:
    mkdir -p "$ANSIBLE_LOCAL_TEMP"
    ansible-playbook -i inventory.ini site.yml -e global_deploy_mode=k8s

tree:
    find . | sort
