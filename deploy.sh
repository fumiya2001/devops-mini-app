#!/bin/bash

set -e

# create AWS infrastructure
terraform -chdir=terraform init
terraform -chdir=terraform apply -auto-approve -input=false

# get the public IP of the EC2 instance
#PUBLIC_IP=$(terraform -chdir=terraform output -raw instance_public_ip)


# run ansible
#ansible-playbook -i ansible/inventory.yml ansible/setup.yml --extra-vars "ec2_host=$EC2_HOST"