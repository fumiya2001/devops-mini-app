#!/bin/bash

set -e

# create AWS infrastructure
terraform -chdir=terraform init
terraform -chdir=terraform apply -auto-approve -input=false

# get the public IP of the EC2 instance
#PUBLIC_IP=$(terraform -chdir=terraform output -raw instance_public_ip)
#ssh-keyscan -H $PUBLIC_IP >> ~/.ssh/known_hosts

# run ansible
#ansible-playbook -i ansible/inventory.yml ansible/setup.yml --extra-vars "ansible_host=$PUBLIC_IP"