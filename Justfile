set shell := ["bash", "-eu", "-o", "pipefail", "-c"]

inventory := "inventory.ini"
playbook := "site.yml"
collections_file := "collections/requirements.yml"

export ANSIBLE_LOCAL_TEMP := "/tmp/.ansible/tmp"

default:
    @just --list

init:
    mkdir -p "$ANSIBLE_LOCAL_TEMP"
    ansible-galaxy collection install -r {{collections_file}}

syntax:
    mkdir -p "$ANSIBLE_LOCAL_TEMP"
    ansible-playbook -i {{inventory}} {{playbook}} --syntax-check

run:
    mkdir -p "$ANSIBLE_LOCAL_TEMP"
    ansible-playbook -i {{inventory}} {{playbook}}

docker:
    mkdir -p "$ANSIBLE_LOCAL_TEMP"
    ansible-playbook -i {{inventory}} {{playbook}} -e global_deploy_mode=docker

k8s:
    mkdir -p "$ANSIBLE_LOCAL_TEMP"
    ansible-playbook -i {{inventory}} {{playbook}} -e global_deploy_mode=k8s

tree:
    find . | sort
