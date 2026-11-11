#!/bin/bash

set -e

# create AWS infrastructure
terraform -chdir=terraform init
terraform -chdir=terraform apply -auto-approve -input=false

# get the public IP of the EC2 instance
EC2_INSTANCE_ID=$(terraform -chdir=terraform output -raw instance_id)


# run ansible
ansible-playbook -i ansible/inventory.yml ansible/setup.yml --extra-vars "ec2_instance_id=$EC2_INSTANCE_ID"