#!/bin/bash

[[ $UID != 0 ]] && { echo "Please use sudo"; exit 1; };

echo "Updating Repository"
apt-get update -y

echo "Installing pip"
apt-get install python-dev python-pip libcurl4-openssl-dev python-software-properties -y 

echo "Installing Ansible"
pip install ansible==1.8.4

ansible-playbook build.yml 

echo "Setup Env"
cat <<EOF > /etc/profile.d/env.sh
id_rsa=$(readlink -f .ssh/ansible_id_rsa)
eval \$(ssh-agent) >/dev/null 2>&1 
ssh-add \$id_rsa >/dev/null 2>&1
export ANSIBLE_HOST_KEY_CHECKING=False
EOF
