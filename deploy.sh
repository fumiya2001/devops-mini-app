#!/bin/bash

set -e

# create AWS infrastructure
terraform -chdir=terraform/aws init
terraform -chdir=terraform/aws apply -auto-approve -input=false

# get the public IP of the EC2 instance
EC2_INSTANCE_ID=$(terraform -chdir=terraform/aws output -raw instance_id)
ANSIBLE_SSM_BUCKET=$(terraform -chdir=terraform/aws output -raw ansible_ssm_bucket)

# run ansible
ansible-playbook -i ansible/inventory.yml ansible/setup.yml --extra-vars "ec2_instance_id=$EC2_INSTANCE_ID ansible_ssm_bucket=$ANSIBLE_SSM_BUCKET"