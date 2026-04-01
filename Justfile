export ANSIBLE_LOCAL_TEMP := "/tmp/.ansible/tmp"

default:
    @just --list

init:
    ansible-galaxy collection install -r collections/requirements.yml

syntax:
    ansible-playbook -i inventory.ini site.yml --syntax-check

run:
    ansible-playbook -i inventory.ini site.yml

docker:
    ansible-playbook -i inventory.ini site.yml -e global_deploy_mode=docker

k8s:
    ansible-playbook -i inventory.ini site.yml -e global_deploy_mode=k8s

tree:
    find . | sort
